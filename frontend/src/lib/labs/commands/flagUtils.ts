import { VfsEntry, World } from '../types';
import { getNode, hasPermission, resolvePath, resolveSymlink } from '../vfs';

export interface ParsedFlags {
  ok: true;
  shortFlags: Set<string>;
  longFlags: Set<string>;
  flagValues: Map<string, string>;
  positional: string[];
}

export interface InvalidFlags {
  ok: false;
  error: string;
}

export function parseCommandFlags(
  args: string[],
  config: {
    allowedShort?: string; // e.g. 'laht'
    shortWithValue?: string; // e.g. 'n' for -n 20
    allowedLong?: string[]; // e.g. ['--max-depth', '--since']
    allowPlusFlags?: boolean; // e.g. dig +short
  }
): ParsedFlags | InvalidFlags {
  const allowedShortSet = new Set((config.allowedShort || '').split(''));
  const shortValSet = new Set((config.shortWithValue || '').split(''));
  const allowedLongList = config.allowedLong || [];

  const shortFlags = new Set<string>();
  const longFlags = new Set<string>();
  const flagValues = new Map<string, string>();
  const positional: string[] = [];

  let i = 0;
  let stopFlags = false;
  while (i < args.length) {
    const arg = args[i];

    if (stopFlags) {
      positional.push(arg);
      i++;
      continue;
    }

    if (arg === '--') {
      stopFlags = true;
      i++;
      continue;
    }

    if (config.allowPlusFlags && arg.startsWith('+')) {
      longFlags.add(arg);
      i++;
      continue;
    }

    if (arg.startsWith('--')) {
      const eqIdx = arg.indexOf('=');
      const baseFlag = eqIdx !== -1 ? arg.slice(0, eqIdx) : arg;
      if (!allowedLongList.includes(baseFlag)) {
        return {
          ok: false,
          error: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${baseFlag}`,
        };
      }
      longFlags.add(baseFlag);
      if (eqIdx !== -1) {
        flagValues.set(baseFlag, arg.slice(eqIdx + 1));
      } else if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
        flagValues.set(baseFlag, args[i + 1]);
        i++;
      }
      i++;
      continue;
    }

    if (arg.startsWith('-') && arg.length > 1) {
      // Check if it's a negative number when positional is expected
      const chars = arg.slice(1);
      for (let cIdx = 0; cIdx < chars.length; cIdx++) {
        const ch = chars[cIdx];
        if (shortValSet.has(ch)) {
          shortFlags.add(ch);
          const rest = chars.slice(cIdx + 1);
          if (rest.length > 0) {
            flagValues.set(`-${ch}`, rest);
          } else if (i + 1 < args.length) {
            flagValues.set(`-${ch}`, args[i + 1]);
            i++;
          } else {
            return {
              ok: false,
              error: `option requires an argument -- '${ch}'`,
            };
          }
          break;
        }
        if (allowedShortSet.has(ch)) {
          shortFlags.add(ch);
        } else {
          return {
            ok: false,
            error: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: -${ch}`,
          };
        }
      }
      i++;
      continue;
    }

    positional.push(arg);
    i++;
  }

  return {
    ok: true,
    shortFlags,
    longFlags,
    flagValues,
    positional,
  };
}

export function readFileLines(
  world: World,
  targetPath: string,
  isSudo: boolean
): { ok: true; lines: string[]; entry: VfsEntry } | { ok: false; error: string } {
  const abs = resolvePath(world.cwd, targetPath, world.env.HOME);
  const rawNode = getNode(world, abs);
  if (!rawNode) {
    return { ok: false, error: `${targetPath}: No such file or directory` };
  }
  const node = resolveSymlink(world, rawNode);
  if (node.type === 'dir') {
    return { ok: false, error: `${targetPath}: Is a directory` };
  }
  if (!hasPermission(node, world.user, 'r', isSudo)) {
    return { ok: false, error: `${targetPath}: Permission denied` };
  }

  if (typeof node.content === 'string') {
    const raw = node.content.endsWith('\n') ? node.content.slice(0, -1) : node.content;
    return { ok: true, lines: raw ? raw.split('\n') : [], entry: node };
  }
  if (Array.isArray(node.previewLines)) {
    return { ok: true, lines: [...node.previewLines], entry: node };
  }
  return { ok: true, lines: [], entry: node };
}
