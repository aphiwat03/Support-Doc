import { ExecResult, World } from '../types';
import { getNode, resolvePath } from '../vfs';
import { parseCommandFlags, readFileLines } from './flagUtils';
import { writeRedirectOutput } from './fsCommands';

export function runTextCommand(
  cmd: string,
  args: string[],
  world: World,
  isSudo: boolean,
  stdin = ''
): ExecResult | null {
  switch (cmd) {
    case 'echo': {
      let noNewline = false;
      let startIdx = 0;
      if (args[0] === '-n') {
        noNewline = true;
        startIdx = 1;
      } else if (args[0] === '-e') {
        startIdx = 1;
      }
      const out = args.slice(startIdx).join(' ');
      return {
        world,
        stdout: noNewline ? out : out,
        stderr: '',
        exitCode: 0,
      };
    }

    case 'grep': {
      const parsed = parseCommandFlags(args, {
        allowedShort: 'invcrE',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      if (parsed.positional.length === 0) {
        return { world, stdout: '', stderr: 'Usage: grep [OPTION]... PATTERNS [FILE]...', exitCode: 2 };
      }

      const patternStr = parsed.positional[0];
      const fileTargets = parsed.positional.slice(1);
      const ignoreCase = parsed.shortFlags.has('i');
      const showLineNum = parsed.shortFlags.has('n');
      const invertMatch = parsed.shortFlags.has('v');
      const countOnly = parsed.shortFlags.has('c');
      const recursive = parsed.shortFlags.has('r');

      let rx: RegExp;
      try {
        rx = new RegExp(patternStr, ignoreCase ? 'i' : '');
      } catch {
        return { world, stdout: '', stderr: `grep: Invalid regular expression`, exitCode: 2 };
      }

      const matchingOutputs: string[] = [];
      let totalMatches = 0;

      const processLines = (lines: string[], prefixFile?: string) => {
        let fileMatches = 0;
        lines.forEach((line, idx) => {
          const matched = rx.test(line);
          const pass = invertMatch ? !matched : matched;
          if (pass) {
            fileMatches++;
            totalMatches++;
            if (!countOnly) {
              let formatted = line;
              if (showLineNum) formatted = `${idx + 1}:${formatted}`;
              if (prefixFile) formatted = `${prefixFile}:${formatted}`;
              matchingOutputs.push(formatted);
            }
          }
        });
        if (countOnly) {
          matchingOutputs.push(prefixFile ? `${prefixFile}:${fileMatches}` : `${fileMatches}`);
        }
      };

      if (fileTargets.length === 0) {
        const lines = stdin ? stdin.replace(/\n$/, '').split('\n') : [];
        processLines(lines);
      } else {
        const expandedFiles: string[] = [];
        for (const t of fileTargets) {
          const abs = resolvePath(world.cwd, t, world.env.HOME);
          const node = getNode(world, abs);
          if (node && node.type === 'dir') {
            if (!recursive) {
              return {
                world,
                stdout: '',
                stderr: `grep: ${t}: Is a directory`,
                exitCode: 2,
              };
            }
            const prefix = abs === '/' ? '/' : abs + '/';
            for (const f of world.fs) {
              if (f.type === 'file' && f.path.startsWith(prefix)) {
                expandedFiles.push(f.path);
              }
            }
          } else {
            expandedFiles.push(t);
          }
        }

        const multi = expandedFiles.length > 1;
        for (const fPath of expandedFiles) {
          const res = readFileLines(world, fPath, isSudo);
          if (!res.ok) {
            return { world, stdout: '', stderr: `grep: ${res.error}`, exitCode: 2 };
          }
          processLines(res.lines, multi ? fPath : undefined);
        }
      }

      return {
        world,
        stdout: matchingOutputs.join('\n'),
        stderr: '',
        exitCode: totalMatches > 0 || countOnly ? 0 : 1,
      };
    }

    case 'wc': {
      const parsed = parseCommandFlags(args, { allowedShort: 'lwc' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const linesOnly = parsed.shortFlags.has('l');

      let lines: string[] = [];
      let label = '';
      if (parsed.positional.length === 0) {
        const trimmedIn = stdin.replace(/\n$/, '');
        lines = trimmedIn.length > 0 ? trimmedIn.split('\n') : [];
      } else {
        label = parsed.positional[0];
        const res = readFileLines(world, label, isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `wc: ${res.error}`, exitCode: 1 };
        }
        lines = res.lines;
      }

      if (linesOnly || parsed.shortFlags.size === 0) {
        const out = label && linesOnly ? `${lines.length} ${label}` : `${lines.length}`;
        if (!linesOnly && parsed.shortFlags.size === 0) {
          const fullText = lines.join('\n');
          const words = fullText.trim() ? fullText.trim().split(/\s+/).length : 0;
          const bytes = fullText.length;
          return {
            world,
            stdout: `${lines.length} ${words} ${bytes}${label ? ' ' + label : ''}`,
            stderr: '',
            exitCode: 0,
          };
        }
        return { world, stdout: out, stderr: '', exitCode: 0 };
      }

      return { world, stdout: `${lines.length}`, stderr: '', exitCode: 0 };
    }

    case 'sort': {
      const parsed = parseCommandFlags(args, { allowedShort: 'nru' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const numeric = parsed.shortFlags.has('n');
      const reverse = parsed.shortFlags.has('r');
      const unique = parsed.shortFlags.has('u');

      let lines: string[] = [];
      if (parsed.positional.length === 0) {
        const trimmedIn = stdin.replace(/\n$/, '');
        lines = trimmedIn ? trimmedIn.split('\n') : [];
      } else {
        const res = readFileLines(world, parsed.positional[0], isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `sort: ${res.error}`, exitCode: 2 };
        }
        lines = [...res.lines];
      }

      lines.sort((a, b) => {
        if (numeric) {
          const na = parseFloat(a.trim()) || 0;
          const nb = parseFloat(b.trim()) || 0;
          if (na !== nb) return reverse ? nb - na : na - nb;
        }
        const cmp = a.localeCompare(b);
        return reverse ? -cmp : cmp;
      });

      if (unique) {
        lines = Array.from(new Set(lines));
      }

      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'uniq': {
      const parsed = parseCommandFlags(args, { allowedShort: 'cd' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const showCount = parsed.shortFlags.has('c');
      const onlyDuplicates = parsed.shortFlags.has('d');

      let lines: string[] = [];
      if (parsed.positional.length === 0) {
        const trimmedIn = stdin.replace(/\n$/, '');
        lines = trimmedIn ? trimmedIn.split('\n') : [];
      } else {
        const res = readFileLines(world, parsed.positional[0], isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `uniq: ${res.error}`, exitCode: 1 };
        }
        lines = res.lines;
      }

      const groups: Array<{ line: string; count: number }> = [];
      for (const l of lines) {
        if (groups.length > 0 && groups[groups.length - 1].line === l) {
          groups[groups.length - 1].count++;
        } else {
          groups.push({ line: l, count: 1 });
        }
      }

      const filtered = onlyDuplicates ? groups.filter((g) => g.count > 1) : groups;
      const out = filtered.map((g) =>
        showCount ? `${String(g.count).padStart(7, ' ')} ${g.line}` : g.line
      );

      return { world, stdout: out.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'cut': {
      const parsed = parseCommandFlags(args, {
        shortWithValue: 'df',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const delim = parsed.flagValues.get('-d') ?? '\t';
      const fieldsSpec = parsed.flagValues.get('-f');
      if (!fieldsSpec) {
        return {
          world,
          stdout: '',
          stderr: 'cut: you must specify a list of bytes, characters, or fields',
          exitCode: 1,
        };
      }

      const fieldIndices = fieldsSpec
        .split(',')
        .map((n) => parseInt(n, 10) - 1)
        .filter((n) => !Number.isNaN(n) && n >= 0);

      let lines: string[] = [];
      if (parsed.positional.length === 0) {
        const trimmedIn = stdin.replace(/\n$/, '');
        lines = trimmedIn ? trimmedIn.split('\n') : [];
      } else {
        const res = readFileLines(world, parsed.positional[0], isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `cut: ${res.error}`, exitCode: 1 };
        }
        lines = res.lines;
      }

      const out = lines.map((line) => {
        const parts = line.split(delim);
        return fieldIndices.map((idx) => parts[idx] ?? '').join(delim);
      });

      return { world, stdout: out.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'awk': {
      // Support awk [-F delim] '{print $N}' [file]
      const parsed = parseCommandFlags(args, {
        shortWithValue: 'F',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const prog = parsed.positional[0] || '';
      const m = prog.trim().match(/^\{\s*print\s+((?:\$\d+(?:\s*,\s*\$\d+)*))\s*\}$/);
      if (!m) {
        return {
          world,
          stdout: '',
          stderr: "(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง (awk รองรับเฉพาะรูปแบบ '{print $N}')",
          exitCode: 2,
        };
      }

      const cols = m[1].split(',').map((s) => parseInt(s.trim().slice(1), 10));
      const fieldSep = parsed.flagValues.get('-F');

      let lines: string[] = [];
      if (parsed.positional.length < 2) {
        const trimmedIn = stdin.replace(/\n$/, '');
        lines = trimmedIn ? trimmedIn.split('\n') : [];
      } else {
        const res = readFileLines(world, parsed.positional[1], isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `awk: ${res.error}`, exitCode: 2 };
        }
        lines = res.lines;
      }

      const out = lines.map((line) => {
        const tokens = fieldSep ? line.split(fieldSep) : line.trim().split(/\s+/);
        return cols
          .map((c) => {
            if (c === 0) return line;
            return tokens[c - 1] ?? '';
          })
          .join(' ');
      });

      return { world, stdout: out.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'tee': {
      const parsed = parseCommandFlags(args, { allowedShort: 'a' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const append = parsed.shortFlags.has('a');
      const contentToWrite = stdin.endsWith('\n') ? stdin : stdin + '\n';
      for (const target of parsed.positional) {
        const res = writeRedirectOutput(
          world,
          target,
          contentToWrite,
          append ? 'append' : 'write',
          isSudo
        );
        if (!res.ok) {
          return { world, stdout: stdin, stderr: res.error, exitCode: 1 };
        }
      }
      return { world, stdout: stdin, stderr: '', exitCode: 0 };
    }

    default:
      return null;
  }
}
