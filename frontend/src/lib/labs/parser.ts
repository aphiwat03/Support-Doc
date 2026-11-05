export interface RedirectSpec {
  mode: 'write' | 'append';
  target: string;
  mergeStderr?: boolean;
}

export interface ParsedCommand {
  sudo: boolean;
  argv: string[];
  quotedFlags: boolean[]; // true if token was quoted (suppress glob expansion)
  redirect?: RedirectSpec;
  mergeStderrToStdout?: boolean;
}

export interface PipelineSegment {
  connector: 'FIRST' | 'AND' | 'SEQ'; // FIRST, &&, or ;
  commands: ParsedCommand[]; // separated by |
}

export type ParseOutcome =
  | { ok: true; segments: PipelineSegment[] }
  | { ok: false; error: string };

const UNSUPPORTED_CONTROL_WORDS = new Set([
  'for',
  'while',
  'until',
  'if',
  'then',
  'else',
  'elif',
  'fi',
  'do',
  'done',
  'case',
  'esac',
  'select',
  'function',
]);

interface RawToken {
  value: string;
  quoted: boolean;
  isOperator: boolean;
}

export function parseCommandLine(
  rawLine: string,
  env: Record<string, string>,
  lastExitCode: number
): ParseOutcome {
  if (rawLine.length > 500) {
    return {
      ok: false,
      error: '(sandbox) คำสั่งยาวเกินขีดจำกัด 500 ตัวอักษร',
    };
  }

  const trimmed = rawLine.trim();
  if (!trimmed || trimmed.startsWith('#')) {
    return { ok: true, segments: [] };
  }

  // Tokenize character by character respecting quotes and escapes
  const tokens: RawToken[] = [];
  let current = '';
  let currentQuoted = false;
  let hasContent = false;
  let i = 0;

  const expandVarAt = (str: string, pos: number): { val: string; nextPos: number } => {
    if (pos + 1 >= str.length) return { val: '$', nextPos: pos + 1 };
    const nextChar = str[pos + 1];
    if (nextChar === '(') {
      return { val: '__UNSUPPORTED_SUBSHELL__', nextPos: pos + 2 };
    }
    if (nextChar === '?') {
      return { val: String(lastExitCode), nextPos: pos + 2 };
    }
    const m = str.slice(pos + 1).match(/^[A-Za-z_][A-Za-z0-9_]*/);
    if (m) {
      const varName = m[0];
      return { val: env[varName] ?? '', nextPos: pos + 1 + varName.length };
    }
    return { val: '$', nextPos: pos + 1 };
  };

  const flushToken = () => {
    if (hasContent) {
      tokens.push({ value: current, quoted: currentQuoted, isOperator: false });
      current = '';
      currentQuoted = false;
      hasContent = false;
    }
  };

  while (i < trimmed.length) {
    const ch = trimmed[i];

    // Whitespace outside quotes
    if (/\s/.test(ch)) {
      flushToken();
      i++;
      continue;
    }

    // Comment outside quotes
    if (ch === '#' && !hasContent) {
      break;
    }

    // Backtick subshell check
    if (ch === '`') {
      return {
        ok: false,
        error: '(sandbox) ไม่รองรับ subshell (`...` หรือ $(...)) ในโหมดจำลอง',
      };
    }

    // Single quotes
    if (ch === "'") {
      hasContent = true;
      currentQuoted = true;
      i++;
      while (i < trimmed.length && trimmed[i] !== "'") {
        current += trimmed[i];
        i++;
      }
      if (i >= trimmed.length) {
        return { ok: false, error: 'bash: unexpected EOF while looking for matching `\'\'' };
      }
      i++; // skip closing '
      continue;
    }

    // Double quotes
    if (ch === '"') {
      hasContent = true;
      currentQuoted = true;
      i++;
      while (i < trimmed.length && trimmed[i] !== '"') {
        if (trimmed[i] === '\\' && i + 1 < trimmed.length) {
          const esc = trimmed[i + 1];
          if (esc === '"' || esc === '\\' || esc === '$' || esc === '`') {
            current += esc;
            i += 2;
            continue;
          }
        }
        if (trimmed[i] === '`') {
          return {
            ok: false,
            error: '(sandbox) ไม่รองรับ subshell (`...` หรือ $(...)) ในโหมดจำลอง',
          };
        }
        if (trimmed[i] === '$') {
          const expanded = expandVarAt(trimmed, i);
          if (expanded.val === '__UNSUPPORTED_SUBSHELL__') {
            return {
              ok: false,
              error: '(sandbox) ไม่รองรับ subshell $(...) ในโหมดจำลอง',
            };
          }
          current += expanded.val;
          i = expanded.nextPos;
          continue;
        }
        current += trimmed[i];
        i++;
      }
      if (i >= trimmed.length) {
        return { ok: false, error: 'bash: unexpected EOF while looking for matching `"\'' };
      }
      i++; // skip closing "
      continue;
    }

    // Escape outside quotes
    if (ch === '\\') {
      hasContent = true;
      if (i + 1 < trimmed.length) {
        current += trimmed[i + 1];
        i += 2;
      } else {
        i++;
      }
      continue;
    }

    // Variable expansion outside quotes
    if (ch === '$') {
      hasContent = true;
      const expanded = expandVarAt(trimmed, i);
      if (expanded.val === '__UNSUPPORTED_SUBSHELL__') {
        return {
          ok: false,
          error: '(sandbox) ไม่รองรับ subshell $(...) ในโหมดจำลอง',
        };
      }
      current += expanded.val;
      i = expanded.nextPos;
      continue;
    }

    // Check 2>&1 operator
    if (trimmed.slice(i, i + 4) === '2>&1') {
      flushToken();
      tokens.push({ value: '2>&1', quoted: false, isOperator: true });
      i += 4;
      continue;
    }

    // Check << heredoc
    if (trimmed.slice(i, i + 2) === '<<') {
      return {
        ok: false,
        error: '(sandbox) ไม่รองรับ heredoc (<<) ในโหมดจำลอง',
      };
    }

    // Check >>
    if (trimmed.slice(i, i + 2) === '>>') {
      flushToken();
      tokens.push({ value: '>>', quoted: false, isOperator: true });
      i += 2;
      continue;
    }

    // Check &&
    if (trimmed.slice(i, i + 2) === '&&') {
      flushToken();
      tokens.push({ value: '&&', quoted: false, isOperator: true });
      i += 2;
      continue;
    }

    // Check ||
    if (trimmed.slice(i, i + 2) === '||') {
      return {
        ok: false,
        error: '(sandbox) ไม่รองรับตัวเชื่อม || ในโหมดจำลอง',
      };
    }

    // Check single & (background)
    if (ch === '&') {
      return {
        ok: false,
        error: '(sandbox) ไม่รองรับการรันเบื้องหลัง (&) ในโหมดจำลอง',
      };
    }

    // Check single-char operators: |, ;, >
    if (ch === '|' || ch === ';' || ch === '>') {
      flushToken();
      tokens.push({ value: ch, quoted: false, isOperator: true });
      i++;
      continue;
    }

    hasContent = true;
    current += ch;
    i++;
  }

  flushToken();

  if (tokens.length === 0) {
    return { ok: true, segments: [] };
  }

  // Split tokens into segments by && and ;
  const segments: PipelineSegment[] = [];
  let currentConnector: 'FIRST' | 'AND' | 'SEQ' = 'FIRST';
  let segmentTokens: RawToken[] = [];

  const buildPipelineCommands = (
    toks: RawToken[]
  ): { ok: false; error: string } | { ok: true; commands: ParsedCommand[] } => {
    const pipeGroups: RawToken[][] = [];
    let curGroup: RawToken[] = [];

    for (const t of toks) {
      if (t.isOperator && t.value === '|') {
        if (curGroup.length === 0) {
          return { ok: false, error: 'bash: syntax error near unexpected token `|\'' };
        }
        pipeGroups.push(curGroup);
        curGroup = [];
      } else {
        curGroup.push(t);
      }
    }
    if (curGroup.length === 0) {
      return { ok: false, error: 'bash: syntax error near unexpected token `|\'' };
    }
    pipeGroups.push(curGroup);

    const parsedCommands: ParsedCommand[] = [];
    for (const group of pipeGroups) {
      let sudo = false;
      const argv: string[] = [];
      const quotedFlags: boolean[] = [];
      let redirect: RedirectSpec | undefined;
      let mergeStderrToStdout = false;

      let idx = 0;
      while (idx < group.length) {
        const tok = group[idx];

        if (tok.isOperator && tok.value === '2>&1') {
          mergeStderrToStdout = true;
          if (redirect) {
            redirect.mergeStderr = true;
          }
          idx++;
          continue;
        }

        if (tok.isOperator && (tok.value === '>' || tok.value === '>>')) {
          const nextTok = group[idx + 1];
          if (!nextTok || nextTok.isOperator) {
            return { ok: false, error: 'bash: syntax error near unexpected token `newline\'' };
          }
          redirect = {
            mode: tok.value === '>>' ? 'append' : 'write',
            target: nextTok.value,
            mergeStderr: mergeStderrToStdout,
          };
          idx += 2;
          continue;
        }

        if (argv.length === 0 && !tok.quoted && tok.value === 'sudo') {
          sudo = true;
          idx++;
          continue;
        }

        if (argv.length === 0 && !tok.quoted && UNSUPPORTED_CONTROL_WORDS.has(tok.value)) {
          return {
            ok: false,
            error: `(sandbox) ไม่รองรับโครงสร้างควบคุม (${tok.value}) ในโหมดจำลอง`,
          };
        }

        argv.push(tok.value);
        quotedFlags.push(tok.quoted);
        idx++;
      }

      if (argv.length === 0 && !redirect) {
        return { ok: false, error: 'bash: syntax error: empty command' };
      }

      parsedCommands.push({
        sudo,
        argv,
        quotedFlags,
        redirect,
        mergeStderrToStdout,
      });
    }

    return { ok: true, commands: parsedCommands };
  };

  for (let tIdx = 0; tIdx < tokens.length; tIdx++) {
    const tok = tokens[tIdx];
    if (tok.isOperator && (tok.value === '&&' || tok.value === ';')) {
      if (segmentTokens.length === 0) {
        if (tok.value === ';') continue;
        return { ok: false, error: `bash: syntax error near unexpected token \`${tok.value}'` };
      }
      const built = buildPipelineCommands(segmentTokens);
      if (!built.ok) return built;
      segments.push({ connector: currentConnector, commands: built.commands });
      segmentTokens = [];
      currentConnector = tok.value === '&&' ? 'AND' : 'SEQ';
    } else {
      segmentTokens.push(tok);
    }
  }

  if (segmentTokens.length > 0) {
    const built = buildPipelineCommands(segmentTokens);
    if (!built.ok) return built;
    segments.push({ connector: currentConnector, commands: built.commands });
  } else if (currentConnector === 'AND') {
    return { ok: false, error: 'bash: syntax error: unexpected end of command after &&' };
  }

  return { ok: true, segments };
}
