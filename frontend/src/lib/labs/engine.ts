import { ExecResult, Lab, World } from './types';
import { parseCommandLine, ParsedCommand } from './parser';
import {
  basename,
  cloneWorld,
  expandGlobToken,
  getNode,
  hasPermission,
  listChildren,
  resolvePath,
} from './vfs';
import { runFsCommand, writeRedirectOutput } from './commands/fsCommands';
import { runTextCommand } from './commands/textCommands';
import { runSystemCommand } from './commands/systemCommands';
import {
  runNetworkShellCommand,
  SUPPORTED_COMMANDS,
} from './commands/networkShellCommands';

const MAX_OUTPUT_LINES = 500;
const MAX_HISTORY_ITEMS = 200;

function truncateLines(text: string): string {
  if (!text) return '';
  const lines = text.split('\n');
  if (lines.length <= MAX_OUTPUT_LINES) {
    return text;
  }
  return [...lines.slice(0, MAX_OUTPUT_LINES), '... (truncated)'].join('\n');
}

function appendHistory(
  world: World,
  command: string,
  stdout: string,
  stderr: string,
  exitCode: number
) {
  world.history.push({ command, stdout, stderr, exitCode });
  if (world.history.length > MAX_HISTORY_ITEMS) {
    world.history = world.history.slice(world.history.length - MAX_HISTORY_ITEMS);
  }
  world.lastExitCode = exitCode;
}

function executeSingleCommand(
  parsedCmd: ParsedCommand,
  world: World,
  lab: Lab,
  stdin: string
): ExecResult {
  // Expand globs for unquoted arguments
  const expandedArgv: string[] = [];
  parsedCmd.argv.forEach((arg, idx) => {
    const isQuoted = parsedCmd.quotedFlags[idx];
    if (isQuoted || idx === 0) {
      expandedArgv.push(arg);
    } else {
      expandedArgv.push(...expandGlobToken(world, arg));
    }
  });

  // Standalone redirect e.g. `> /var/log/app/app.log`
  if (expandedArgv.length === 0 && parsedCmd.redirect) {
    const redirRes = writeRedirectOutput(
      world,
      parsedCmd.redirect.target,
      '',
      parsedCmd.redirect.mode,
      parsedCmd.sudo
    );
    if (!redirRes.ok) {
      return { world, stdout: '', stderr: redirRes.error, exitCode: 1 };
    }
    return { world, stdout: '', stderr: '', exitCode: 0 };
  }

  const reconstructed = expandedArgv.join(' ').trim();

  // Check scripted rules from Lab first
  if (lab.scripted && lab.scripted.length > 0) {
    for (const rule of lab.scripted) {
      const rx = new RegExp(rule.match);
      if (rx.test(reconstructed)) {
        if (rule.effects) {
          for (const eff of rule.effects) {
            if (eff.type === 'setServiceState' && eff.service && eff.state) {
              const svc = world.services.find((s) => s.name === eff.service);
              if (svc) svc.state = eff.state;
            } else if (eff.type === 'writeFile' && eff.path !== undefined) {
              writeRedirectOutput(world, eff.path, eff.content || '', 'write', true);
            }
          }
        }
        return {
          world,
          stdout: rule.stdout || '',
          stderr: rule.stderr || '',
          exitCode: rule.exitCode,
        };
      }
    }
  }

  const [cmdName, ...args] = expandedArgv;

  // Handle script execution: ./script.sh or /path/to/script.sh or bash/sh script.sh
  if (cmdName.includes('/') || cmdName === 'bash' || cmdName === 'sh') {
    const isInterpreter = cmdName === 'bash' || cmdName === 'sh';
    const scriptTarget = isInterpreter ? args[0] : cmdName;
    if (!scriptTarget) {
      return { world, stdout: '', stderr: `${cmdName}: missing script file`, exitCode: 2 };
    }
    const abs = resolvePath(world.cwd, scriptTarget, world.env.HOME);
    const node = getNode(world, abs);
    if (!node) {
      return {
        world,
        stdout: '',
        stderr: `bash: ${scriptTarget}: No such file or directory`,
        exitCode: 127,
      };
    }
    if (node.type === 'dir') {
      return {
        world,
        stdout: '',
        stderr: `bash: ${scriptTarget}: Is a directory`,
        exitCode: 126,
      };
    }
    if (!isInterpreter && !hasPermission(node, world.user, 'x', parsedCmd.sudo)) {
      return {
        world,
        stdout: '',
        stderr: `bash: ${scriptTarget}: Permission denied`,
        exitCode: 126,
      };
    }
    if (!hasPermission(node, world.user, 'r', parsedCmd.sudo)) {
      return {
        world,
        stdout: '',
        stderr: `bash: ${scriptTarget}: Permission denied`,
        exitCode: 126,
      };
    }

    const scriptLines = (node.content || '')
      .split('\n')
      .map((l) => l.trim())
      .filter((l) => l && !l.startsWith('#'));

    const outParts: string[] = [];
    const errParts: string[] = [];
    let currentWorld = world;
    let lastCode = 0;

    for (const sLine of scriptLines) {
      const subRes = execLineInternal(currentWorld, sLine, { lab }, false);
      currentWorld = subRes.world;
      if (subRes.stdout) outParts.push(subRes.stdout);
      if (subRes.stderr) errParts.push(subRes.stderr);
      lastCode = subRes.exitCode;
      if (lastCode !== 0) break;
    }

    return {
      world: currentWorld,
      stdout: outParts.join('\n'),
      stderr: errParts.join('\n'),
      exitCode: lastCode,
    };
  }

  // Dispatch to command groups
  const fsRes = runFsCommand(cmdName, args, world, parsedCmd.sudo, stdin);
  if (fsRes) return fsRes;

  const textRes = runTextCommand(cmdName, args, world, parsedCmd.sudo, stdin);
  if (textRes) return textRes;

  const sysRes = runSystemCommand(cmdName, args, world, parsedCmd.sudo);
  if (sysRes) return sysRes;

  const netRes = runNetworkShellCommand(cmdName, args, world);
  if (netRes) return netRes;

  return {
    world,
    stdout: '',
    stderr: `bash: ${cmdName}: command not found`,
    exitCode: 127,
  };
}

function execLineInternal(
  inputWorld: World,
  line: string,
  ctx: { lab: Lab },
  recordInHistory: boolean
): ExecResult {
  const world = cloneWorld(inputWorld);
  const trimmed = line.trim();
  if (!trimmed) {
    return { world, stdout: '', stderr: '', exitCode: world.lastExitCode };
  }

  const parsed = parseCommandLine(line, world.env, world.lastExitCode);
  if (!parsed.ok) {
    if (recordInHistory) {
      appendHistory(world, trimmed, '', parsed.error, 2);
    }
    return {
      world,
      stdout: '',
      stderr: parsed.error,
      exitCode: 2,
    };
  }

  if (parsed.segments.length === 0) {
    return { world, stdout: '', stderr: '', exitCode: 0 };
  }

  const allStdout: string[] = [];
  const allStderr: string[] = [];
  let lastExitCode = 0;
  let shouldClear = false;
  let currentWorld = world;

  for (const seg of parsed.segments) {
    if (seg.connector === 'AND' && lastExitCode !== 0) {
      continue;
    }

    let pipeInput = '';
    const pipeStderr: string[] = [];
    let pipeExitCode = 0;

    for (let cIdx = 0; cIdx < seg.commands.length; cIdx++) {
      const cmdObj = seg.commands[cIdx];
      const isLastInPipe = cIdx === seg.commands.length - 1;

      const res = executeSingleCommand(cmdObj, currentWorld, ctx.lab, pipeInput);
      currentWorld = res.world;
      if (res.clear) {
        shouldClear = true;
      }

      let cmdStdout = res.stdout;
      let cmdStderr = res.stderr;

      if (cmdObj.mergeStderrToStdout && cmdStderr) {
        cmdStdout = cmdStdout ? `${cmdStdout}\n${cmdStderr}` : cmdStderr;
        cmdStderr = '';
      }

      if (cmdObj.redirect && cmdObj.argv.length > 0) {
        const payload = cmdStdout ? cmdStdout + '\n' : '';
        const redirRes = writeRedirectOutput(
          currentWorld,
          cmdObj.redirect.target,
          payload,
          cmdObj.redirect.mode,
          cmdObj.sudo
        );
        if (!redirRes.ok) {
          cmdStderr = cmdStderr ? `${cmdStderr}\n${redirRes.error}` : redirRes.error;
          pipeExitCode = 1;
        } else {
          pipeExitCode = res.exitCode;
        }
        cmdStdout = '';
      } else {
        pipeExitCode = res.exitCode;
      }

      if (cmdStderr) {
        pipeStderr.push(cmdStderr);
      }

      if (isLastInPipe) {
        if (cmdStdout) allStdout.push(cmdStdout);
      } else {
        pipeInput = cmdStdout;
      }
    }

    if (pipeStderr.length > 0) {
      allStderr.push(pipeStderr.join('\n'));
    }
    lastExitCode = pipeExitCode;
  }

  const finalStdout = truncateLines(allStdout.join('\n'));
  const finalStderr = truncateLines(allStderr.join('\n'));

  if (recordInHistory) {
    appendHistory(currentWorld, trimmed, finalStdout, finalStderr, lastExitCode);
  }

  return {
    world: currentWorld,
    stdout: finalStdout,
    stderr: finalStderr,
    exitCode: lastExitCode,
    clear: shouldClear,
  };
}

export function execLine(
  world: World,
  line: string,
  ctxOrLab: { lab: Lab } | Lab
): ExecResult {
  const ctx = 'lab' in ctxOrLab ? ctxOrLab : { lab: ctxOrLab };
  return execLineInternal(world, line, ctx, true);
}

export function completeInput(
  world: World,
  input: string
): { completed: string; suggestions: string[] } {
  const endsWithSpace = /\s$/.test(input);
  const parts = input.trimStart().split(/\s+/);
  if (input.trim() === '') {
    return { completed: input, suggestions: [] };
  }

  const isFirstToken = parts.length === 1 && !endsWithSpace;
  const lastToken = endsWithSpace ? '' : parts[parts.length - 1];

  // Command completion if first token and not a path
  if (isFirstToken && !lastToken.includes('/')) {
    const matches = SUPPORTED_COMMANDS.filter((c) => c.startsWith(lastToken)).sort();
    if (matches.length === 1) {
      return { completed: matches[0] + ' ', suggestions: matches };
    }
    return { completed: input, suggestions: matches };
  }

  // Path completion
  const slashIdx = lastToken.lastIndexOf('/');
  const dirPart = slashIdx !== -1 ? lastToken.slice(0, slashIdx + 1) : '';
  const namePrefix = slashIdx !== -1 ? lastToken.slice(slashIdx + 1) : lastToken;

  const searchDirAbs = dirPart
    ? resolvePath(world.cwd, dirPart, world.env.HOME)
    : world.cwd;
  const children = listChildren(world, searchDirAbs);
  const matchingEntries = children
    .filter((c) => basename(c.path).startsWith(namePrefix))
    .sort((a, b) => a.path.localeCompare(b.path));

  if (matchingEntries.length === 0) {
    return { completed: input, suggestions: [] };
  }

  if (matchingEntries.length === 1) {
    const entry = matchingEntries[0];
    const name = basename(entry.path) + (entry.type === 'dir' ? '/' : ' ');
    const replacement = dirPart + name;
    const prefixInput = endsWithSpace
      ? input
      : input.slice(0, input.length - lastToken.length);
    return {
      completed: prefixInput + replacement,
      suggestions: [basename(entry.path) + (entry.type === 'dir' ? '/' : '')],
    };
  }

  const suggestions = matchingEntries.map(
    (e) => basename(e.path) + (e.type === 'dir' ? '/' : '')
  );
  return { completed: input, suggestions };
}
