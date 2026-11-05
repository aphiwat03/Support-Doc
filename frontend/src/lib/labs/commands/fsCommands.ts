import { ExecResult, VfsEntry, World } from '../types';
import {
  applyChmodMode,
  basename,
  byteLength,
  dirname,
  formatHumanBytes,
  formatSymbolicMode,
  getEntrySizeBytes,
  getNode,
  globToRegex,
  hasPermission,
  listChildren,
  resolvePath,
  resolveSymlink,
} from '../vfs';
import { parseCommandFlags, readFileLines } from './flagUtils';

function formatMtimeShort(iso: string): string {
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return 'Nov  4 09:00';
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const mon = months[d.getUTCMonth()];
  const day = String(d.getUTCDate()).padStart(2, ' ');
  const hh = String(d.getUTCHours()).padStart(2, '0');
  const mm = String(d.getUTCMinutes()).padStart(2, '0');
  return `${mon} ${day} ${hh}:${mm}`;
}

export function runFsCommand(
  cmd: string,
  args: string[],
  world: World,
  isSudo: boolean,
  stdin = ''
): ExecResult | null {
  switch (cmd) {
    case 'pwd': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      return { world, stdout: world.cwd, stderr: '', exitCode: 0 };
    }

    case 'whoami': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      return { world, stdout: isSudo ? 'root' : world.user, stderr: '', exitCode: 0 };
    }

    case 'id': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (isSudo || world.user === 'root') {
        return {
          world,
          stdout: 'uid=0(root) gid=0(root) groups=0(root)',
          stderr: '',
          exitCode: 0,
        };
      }
      return {
        world,
        stdout: `uid=1000(${world.user}) gid=1000(${world.user}) groups=1000(${world.user}),4(adm),27(sudo)`,
        stderr: '',
        exitCode: 0,
      };
    }

    case 'cd': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const target = parsed.positional[0] || '~';
      const abs = resolvePath(world.cwd, target, world.env.HOME);
      const rawNode = getNode(world, abs);
      if (!rawNode) {
        return {
          world,
          stdout: '',
          stderr: `bash: cd: ${target}: No such file or directory`,
          exitCode: 1,
        };
      }
      const node = resolveSymlink(world, rawNode);
      if (node.type !== 'dir') {
        return {
          world,
          stdout: '',
          stderr: `bash: cd: ${target}: Not a directory`,
          exitCode: 1,
        };
      }
      if (!hasPermission(node, world.user, 'x', isSudo)) {
        return {
          world,
          stdout: '',
          stderr: `bash: cd: ${target}: Permission denied`,
          exitCode: 1,
        };
      }
      world.cwd = node.path;
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'ls': {
      const parsed = parseCommandFlags(args, { allowedShort: 'lahtr1d' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const isLong = parsed.shortFlags.has('l');
      const showAll = parsed.shortFlags.has('a');
      const human = parsed.shortFlags.has('h');
      const sortByTime = parsed.shortFlags.has('t');

      const targets = parsed.positional.length > 0 ? parsed.positional : ['.'];
      const outLines: string[] = [];
      const errLines: string[] = [];
      let exitCode = 0;

      const formatEntryLine = (e: VfsEntry, displayName: string): string => {
        if (!isLong) return displayName;
        const sym = formatSymbolicMode(e);
        const sizeNum = getEntrySizeBytes(e);
        const sizeStr = (human ? formatHumanBytes(sizeNum) : String(sizeNum)).padStart(7, ' ');
        const mtimeStr = formatMtimeShort(e.mtime);
        const linkSuffix = e.type === 'symlink' && e.target ? ` -> ${e.target}` : '';
        return `${sym} 1 ${e.owner.padEnd(8, ' ')} ${e.group.padEnd(8, ' ')} ${sizeStr} ${mtimeStr} ${displayName}${linkSuffix}`;
      };

      for (const t of targets) {
        const abs = resolvePath(world.cwd, t, world.env.HOME);
        const node = getNode(world, abs);
        if (!node) {
          errLines.push(`ls: cannot access '${t}': No such file or directory`);
          exitCode = 2;
          continue;
        }
        if (node.type === 'dir' && !parsed.shortFlags.has('d')) {
          if (targets.length > 1) {
            outLines.push(`${t}:`);
          }
          let items = listChildren(world, abs);
          if (!showAll) {
            items = items.filter((item) => !basename(item.path).startsWith('.'));
          }
          if (sortByTime) {
            items.sort((a, b) => new Date(b.mtime).getTime() - new Date(a.mtime).getTime());
          } else {
            items.sort((a, b) => basename(a.path).localeCompare(basename(b.path)));
          }

          if (showAll) {
            const dotEntries: Array<{ e: VfsEntry; name: string }> = [
              { e: node, name: '.' },
              { e: getNode(world, dirname(abs)) || node, name: '..' },
              ...items.map((item) => ({ e: item, name: basename(item.path) })),
            ];
            if (isLong) {
              for (const de of dotEntries) {
                outLines.push(formatEntryLine(de.e, de.name));
              }
            } else {
              outLines.push(dotEntries.map((de) => de.name).join('  '));
            }
          } else {
            if (isLong) {
              for (const item of items) {
                outLines.push(formatEntryLine(item, basename(item.path)));
              }
            } else if (items.length > 0) {
              outLines.push(items.map((item) => basename(item.path)).join('  '));
            }
          }
        } else {
          outLines.push(formatEntryLine(node, t));
        }
      }

      return {
        world,
        stdout: outLines.join('\n'),
        stderr: errLines.join('\n'),
        exitCode,
      };
    }

    case 'cat': {
      const parsed = parseCommandFlags(args, { allowedShort: 'n' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const showLineNumbers = parsed.shortFlags.has('n');

      if (parsed.positional.length === 0) {
        const lines = stdin ? stdin.split('\n') : [];
        const out = showLineNumbers
          ? lines.map((l, idx) => `${String(idx + 1).padStart(6, ' ')}\t${l}`).join('\n')
          : stdin;
        return { world, stdout: out, stderr: '', exitCode: 0 };
      }

      const outLines: string[] = [];
      const errLines: string[] = [];
      let exitCode = 0;

      for (const fileArg of parsed.positional) {
        const res = readFileLines(world, fileArg, isSudo);
        if (!res.ok) {
          errLines.push(`cat: ${res.error}`);
          exitCode = 1;
        } else {
          res.lines.forEach((line, idx) => {
            outLines.push(
              showLineNumbers ? `${String(idx + 1).padStart(6, ' ')}\t${line}` : line
            );
          });
        }
      }

      return {
        world,
        stdout: outLines.join('\n'),
        stderr: errLines.join('\n'),
        exitCode,
      };
    }

    case 'head':
    case 'tail': {
      // Support -n 20 or -20 shorthand
      const normalizedArgs = args.map((a) => (/^-\d+$/.test(a) ? `-n${a.slice(1)}` : a));
      const parsed = parseCommandFlags(normalizedArgs, {
        allowedShort: 'f',
        shortWithValue: 'n',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const countStr = parsed.flagValues.get('-n') || '10';
      const count = Math.max(1, parseInt(countStr, 10) || 10);

      let lines: string[] = [];
      if (parsed.positional.length === 0) {
        lines = stdin ? stdin.replace(/\n$/, '').split('\n') : [];
      } else {
        const res = readFileLines(world, parsed.positional[0], isSudo);
        if (!res.ok) {
          return { world, stdout: '', stderr: `${cmd}: ${res.error}`, exitCode: 1 };
        }
        lines = res.lines;
      }

      const sliced = cmd === 'head' ? lines.slice(0, count) : lines.slice(-count);
      return { world, stdout: sliced.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'mkdir': {
      const parsed = parseCommandFlags(args, { allowedShort: 'p' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length === 0) {
        return { world, stdout: '', stderr: 'mkdir: missing operand', exitCode: 1 };
      }
      const makeParents = parsed.shortFlags.has('p');
      const owner = isSudo ? 'root' : world.user;

      for (const target of parsed.positional) {
        const abs = resolvePath(world.cwd, target, world.env.HOME);
        const existing = getNode(world, abs);
        if (existing) {
          if (makeParents && existing.type === 'dir') continue;
          return {
            world,
            stdout: '',
            stderr: `mkdir: cannot create directory '${target}': File exists`,
            exitCode: 1,
          };
        }
        const parentAbs = dirname(abs);
        const parentNode = getNode(world, parentAbs);
        if (!parentNode && !makeParents) {
          return {
            world,
            stdout: '',
            stderr: `mkdir: cannot create directory '${target}': No such file or directory`,
            exitCode: 1,
          };
        }
        if (makeParents) {
          const parts = abs.split('/').filter(Boolean);
          let cur = '';
          for (const p of parts) {
            cur += '/' + p;
            if (!getNode(world, cur)) {
              world.fs.push({
                path: cur,
                type: 'dir',
                mode: '0755',
                owner,
                group: owner,
                mtime: new Date().toISOString(),
              });
            }
          }
        } else {
          world.fs.push({
            path: abs,
            type: 'dir',
            mode: '0755',
            owner,
            group: owner,
            mtime: new Date().toISOString(),
          });
        }
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'touch': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length === 0) {
        return { world, stdout: '', stderr: 'touch: missing file operand', exitCode: 1 };
      }
      const owner = isSudo ? 'root' : world.user;
      for (const target of parsed.positional) {
        const abs = resolvePath(world.cwd, target, world.env.HOME);
        const existing = getNode(world, abs);
        if (existing) {
          existing.mtime = new Date().toISOString();
        } else {
          const parent = getNode(world, dirname(abs));
          if (!parent || parent.type !== 'dir') {
            return {
              world,
              stdout: '',
              stderr: `touch: cannot touch '${target}': No such file or directory`,
              exitCode: 1,
            };
          }
          world.fs.push({
            path: abs,
            type: 'file',
            content: '',
            sizeBytes: 0,
            mode: '0644',
            owner,
            group: owner,
            mtime: new Date().toISOString(),
          });
        }
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'cp': {
      const parsed = parseCommandFlags(args, { allowedShort: 'rfp' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length < 2) {
        return { world, stdout: '', stderr: 'cp: missing file operand', exitCode: 1 };
      }
      const [srcArg, destArg] = parsed.positional;
      const srcAbs = resolvePath(world.cwd, srcArg, world.env.HOME);
      const srcNode = getNode(world, srcAbs);
      if (!srcNode) {
        return {
          world,
          stdout: '',
          stderr: `cp: cannot stat '${srcArg}': No such file or directory`,
          exitCode: 1,
        };
      }
      if (srcNode.type === 'dir' && !parsed.shortFlags.has('r')) {
        return {
          world,
          stdout: '',
          stderr: `cp: -r not specified; omitting directory '${srcArg}'`,
          exitCode: 1,
        };
      }
      let destAbs = resolvePath(world.cwd, destArg, world.env.HOME);
      const destNode = getNode(world, destAbs);
      if (destNode && destNode.type === 'dir') {
        destAbs = resolvePath(destAbs, basename(srcAbs));
      }
      const existingIdx = world.fs.findIndex((e) => e.path === destAbs);
      const clonedEntry: VfsEntry = {
        ...srcNode,
        path: destAbs,
        mtime: new Date().toISOString(),
      };
      if (existingIdx !== -1) {
        world.fs[existingIdx] = clonedEntry;
      } else {
        world.fs.push(clonedEntry);
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'mv': {
      const parsed = parseCommandFlags(args, { allowedShort: 'f' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length < 2) {
        return { world, stdout: '', stderr: 'mv: missing file operand', exitCode: 1 };
      }
      const [srcArg, destArg] = parsed.positional;
      const srcAbs = resolvePath(world.cwd, srcArg, world.env.HOME);
      const srcNode = getNode(world, srcAbs);
      if (!srcNode) {
        return {
          world,
          stdout: '',
          stderr: `mv: cannot stat '${srcArg}': No such file or directory`,
          exitCode: 1,
        };
      }
      let destAbs = resolvePath(world.cwd, destArg, world.env.HOME);
      const destNode = getNode(world, destAbs);
      if (destNode && destNode.type === 'dir') {
        destAbs = resolvePath(destAbs, basename(srcAbs));
      }
      world.fs = world.fs.filter((e) => e.path !== destAbs);
      srcNode.path = destAbs;
      srcNode.mtime = new Date().toISOString();
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'rm': {
      const parsed = parseCommandFlags(args, { allowedShort: 'rfR' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const recursive = parsed.shortFlags.has('r') || parsed.shortFlags.has('R');
      const force = parsed.shortFlags.has('f');

      if (parsed.positional.length === 0) {
        return force
          ? { world, stdout: '', stderr: '', exitCode: 0 }
          : { world, stdout: '', stderr: 'rm: missing operand', exitCode: 1 };
      }

      for (const target of parsed.positional) {
        const abs = resolvePath(world.cwd, target, world.env.HOME);
        if (abs === '/' || target.trim() === '/*') {
          return {
            world,
            stdout: '',
            stderr: "rm: it is dangerous to operate recursively on '/'\nrm: use --no-preserve-root to override this failsafe",
            exitCode: 1,
          };
        }
        const node = getNode(world, abs);
        if (!node) {
          if (force) continue;
          return {
            world,
            stdout: '',
            stderr: `rm: cannot remove '${target}': No such file or directory`,
            exitCode: 1,
          };
        }
        if (node.type === 'dir' && !recursive) {
          return {
            world,
            stdout: '',
            stderr: `rm: cannot remove '${target}': Is a directory`,
            exitCode: 1,
          };
        }
        const prefix = abs + '/';
        world.fs = world.fs.filter((e) => e.path !== abs && !e.path.startsWith(prefix));
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'ln': {
      const parsed = parseCommandFlags(args, { allowedShort: 'sf' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (!parsed.shortFlags.has('s')) {
        return {
          world,
          stdout: '',
          stderr: '(sandbox) รองรับเฉพาะ symbolic link (ln -s) ในโหมดจำลอง',
          exitCode: 2,
        };
      }
      if (parsed.positional.length < 2) {
        return { world, stdout: '', stderr: 'ln: missing file operand', exitCode: 1 };
      }
      const [target, linkName] = parsed.positional;
      const linkAbs = resolvePath(world.cwd, linkName, world.env.HOME);
      world.fs = world.fs.filter((e) => e.path !== linkAbs);
      world.fs.push({
        path: linkAbs,
        type: 'symlink',
        target,
        mode: '0777',
        owner: isSudo ? 'root' : world.user,
        group: isSudo ? 'root' : world.user,
        mtime: new Date().toISOString(),
      });
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'stat': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length === 0) {
        return { world, stdout: '', stderr: 'stat: missing operand', exitCode: 1 };
      }
      const target = parsed.positional[0];
      const abs = resolvePath(world.cwd, target, world.env.HOME);
      const node = getNode(world, abs);
      if (!node) {
        return {
          world,
          stdout: '',
          stderr: `stat: cannot statx '${target}': No such file or directory`,
          exitCode: 1,
        };
      }
      const size = getEntrySizeBytes(node);
      const sym = formatSymbolicMode(node);
      const ftype =
        node.type === 'dir'
          ? 'directory'
          : node.type === 'symlink'
          ? 'symbolic link'
          : 'regular file';
      const out = [
        `  File: ${target}`,
        `  Size: ${size}\tBlocks: ${Math.ceil(size / 512)}\tIO Block: 4096   ${ftype}`,
        `Access: (${node.mode}/${sym})  Uid: ( 1000/${node.owner})   Gid: ( 1000/${node.group})`,
        `Modify: ${node.mtime}`,
      ].join('\n');
      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'file': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length === 0) {
        return { world, stdout: '', stderr: 'Usage: file <filename>', exitCode: 1 };
      }
      const target = parsed.positional[0];
      const abs = resolvePath(world.cwd, target, world.env.HOME);
      const node = getNode(world, abs);
      if (!node) {
        return {
          world,
          stdout: `${target}: cannot open \`${target}' (No such file or directory)`,
          stderr: '',
          exitCode: 1,
        };
      }
      if (node.type === 'dir') {
        return { world, stdout: `${target}: directory`, stderr: '', exitCode: 0 };
      }
      if (node.type === 'symlink') {
        return {
          world,
          stdout: `${target}: symbolic link to ${node.target}`,
          stderr: '',
          exitCode: 0,
        };
      }
      const desc = node.content?.startsWith('#!')
        ? 'Bourne-Again shell script, ASCII text executable'
        : 'ASCII text';
      return { world, stdout: `${target}: ${desc}`, stderr: '', exitCode: 0 };
    }

    case 'find': {
      // Basic find supporting: find [path] [-name pat] [-type f|d] [-size +NM|+NG] [-mtime -N|+N]
      let searchRoot = '.';
      let i = 0;
      if (args.length > 0 && !args[0].startsWith('-')) {
        searchRoot = args[0];
        i = 1;
      }

      let namePattern: RegExp | null = null;
      let typeFilter: 'f' | 'd' | 'l' | null = null;
      let minSizeBytes: number | null = null;

      while (i < args.length) {
        const opt = args[i];
        if (opt === '-name') {
          const val = args[i + 1];
          if (!val) return { world, stdout: '', stderr: 'find: missing argument to `-name\'', exitCode: 1 };
          namePattern = globToRegex(val);
          i += 2;
        } else if (opt === '-type') {
          const val = args[i + 1];
          if (val !== 'f' && val !== 'd' && val !== 'l') {
            return { world, stdout: '', stderr: 'find: invalid argument to -type', exitCode: 1 };
          }
          typeFilter = val;
          i += 2;
        } else if (opt === '-size') {
          const val = args[i + 1] || '';
          const m = val.match(/^\+?(\d+)([kMGc]?)$/);
          if (m) {
            const num = parseInt(m[1], 10);
            const unit = m[2];
            const mult =
              unit === 'G'
                ? 1024 ** 3
                : unit === 'M'
                ? 1024 ** 2
                : unit === 'k'
                ? 1024
                : 1;
            minSizeBytes = num * mult;
          }
          i += 2;
        } else if (opt === '-mtime') {
          i += 2;
        } else {
          return {
            world,
            stdout: '',
            stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${opt}`,
            exitCode: 2,
          };
        }
      }

      const rootAbs = resolvePath(world.cwd, searchRoot, world.env.HOME);
      const prefix = rootAbs === '/' ? '/' : rootAbs + '/';
      const matches = world.fs
        .filter((e) => {
          if (e.path !== rootAbs && !e.path.startsWith(prefix)) return false;
          if (typeFilter === 'f' && e.type !== 'file') return false;
          if (typeFilter === 'd' && e.type !== 'dir') return false;
          if (typeFilter === 'l' && e.type !== 'symlink') return false;
          if (namePattern && !namePattern.test(basename(e.path))) return false;
          if (minSizeBytes !== null && getEntrySizeBytes(e) < minSizeBytes) return false;
          return true;
        })
        .map((e) => {
          if (searchRoot === '.') {
            if (e.path === rootAbs) return '.';
            return './' + e.path.slice(prefix.length);
          }
          return e.path;
        });

      return { world, stdout: matches.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'chmod': {
      // Allow -R flag or direct mode + file
      let recursive = false;
      const filtered: string[] = [];
      for (const a of args) {
        if (a === '-R') {
          recursive = true;
        } else if (a.startsWith('-') && !/^[+-][rwx]+$/.test(a)) {
          return {
            world,
            stdout: '',
            stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${a}`,
            exitCode: 2,
          };
        } else {
          filtered.push(a);
        }
      }

      if (filtered.length < 2) {
        return { world, stdout: '', stderr: 'chmod: missing operand', exitCode: 1 };
      }

      const [modeSpec, ...targets] = filtered;
      let warningMsg = '';

      for (const t of targets) {
        const abs = resolvePath(world.cwd, t, world.env.HOME);
        const node = getNode(world, abs);
        if (!node) {
          return {
            world,
            stdout: '',
            stderr: `chmod: cannot access '${t}': No such file or directory`,
            exitCode: 1,
          };
        }
        if (!isSudo && world.user !== 'root' && node.owner !== world.user) {
          return {
            world,
            stdout: '',
            stderr: `chmod: changing permissions of '${t}': Operation not permitted`,
            exitCode: 1,
          };
        }

        const res = applyChmodMode(node.mode, modeSpec);
        if (!res.valid) {
          return {
            world,
            stdout: '',
            stderr: `chmod: invalid mode: '${modeSpec}'`,
            exitCode: 1,
          };
        }

        if (res.mode === '0777') {
          world.insecureChmod777Used = true;
          warningMsg =
            '[SECURITY WARNING] chmod 777 เปิดสิทธิ์เขียนให้ผู้ใช้ทุกคนในระบบ (world-writable) ซึ่งผิดมาตรฐานความปลอดภัย กรุณาใช้ chmod u+x หรือ chmod 755 แทน';
        } else if (res.mode === '0755' || res.mode === '0744' || res.mode === '0754') {
          // If user corrects the permission to a safe executable mode, clear the 777 flag
          world.insecureChmod777Used = false;
        }

        node.mode = res.mode;
        if (recursive && node.type === 'dir') {
          const prefix = abs === '/' ? '/' : abs + '/';
          for (const child of world.fs) {
            if (child.path.startsWith(prefix)) {
              const childRes = applyChmodMode(child.mode, modeSpec);
              if (childRes.valid) child.mode = childRes.mode;
            }
          }
        }
      }

      return { world, stdout: '', stderr: warningMsg, exitCode: 0 };
    }

    case 'chown': {
      const parsed = parseCommandFlags(args, { allowedShort: 'R' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length < 2) {
        return { world, stdout: '', stderr: 'chown: missing operand', exitCode: 1 };
      }
      if (!isSudo && world.user !== 'root') {
        return {
          world,
          stdout: '',
          stderr: 'chown: changing ownership: Operation not permitted',
          exitCode: 1,
        };
      }
      const [ownerGroup, ...targets] = parsed.positional;
      const [newOwner, newGroup] = ownerGroup.split(':');
      for (const t of targets) {
        const abs = resolvePath(world.cwd, t, world.env.HOME);
        const node = getNode(world, abs);
        if (!node) {
          return {
            world,
            stdout: '',
            stderr: `chown: cannot access '${t}': No such file or directory`,
            exitCode: 1,
          };
        }
        if (newOwner) node.owner = newOwner;
        if (newGroup) node.group = newGroup;
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    default:
      return null;
  }
}

export function writeRedirectOutput(
  world: World,
  targetPath: string,
  content: string,
  mode: 'write' | 'append',
  isSudo: boolean
): { ok: true } | { ok: false; error: string } {
  const abs = resolvePath(world.cwd, targetPath, world.env.HOME);
  if (abs === '/dev/null') {
    return { ok: true };
  }
  const existing = getNode(world, abs);
  if (existing) {
    if (existing.type === 'dir') {
      return { ok: false, error: `bash: ${targetPath}: Is a directory` };
    }
    if (!hasPermission(existing, world.user, 'w', isSudo)) {
      return { ok: false, error: `bash: ${targetPath}: Permission denied` };
    }
    const nextContent =
      mode === 'append' ? (existing.content || '') + content : content;
    existing.content = nextContent;
    existing.previewLines = undefined;
    existing.sizeBytes = byteLength(nextContent);
    existing.mtime = new Date().toISOString();
    return { ok: true };
  }

  const parent = getNode(world, dirname(abs));
  if (!parent || parent.type !== 'dir') {
    return { ok: false, error: `bash: ${targetPath}: No such file or directory` };
  }
  if (!hasPermission(parent, world.user, 'w', isSudo)) {
    return { ok: false, error: `bash: ${targetPath}: Permission denied` };
  }

  const owner = isSudo ? 'root' : world.user;
  world.fs.push({
    path: abs,
    type: 'file',
    content,
    sizeBytes: byteLength(content),
    mode: '0644',
    owner,
    group: owner,
    mtime: new Date().toISOString(),
  });
  return { ok: true };
}
