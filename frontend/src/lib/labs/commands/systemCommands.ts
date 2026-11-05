import { ExecResult, World } from '../types';
import {
  computeDiskUsage,
  formatHumanBytes,
  getNode,
  getSubtreeBytes,
  listChildren,
  resolvePath,
} from '../vfs';
import { parseCommandFlags } from './flagUtils';

export function runSystemCommand(
  cmd: string,
  args: string[],
  world: World,
  _isSudo: boolean
): ExecResult | null {
  void _isSudo;
  switch (cmd) {
    case 'df': {
      const parsed = parseCommandFlags(args, { allowedShort: 'hiT' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const human = parsed.shortFlags.has('h');
      const inodes = parsed.shortFlags.has('i');
      const usages = computeDiskUsage(world);

      if (inodes) {
        const lines = [
          'Filesystem       Inodes  IUsed   IFree IUse% Mounted on',
          ...usages.map((u) => {
            const dev = u.device.padEnd(14, ' ');
            const tot = String(u.inodesTotal).padStart(8, ' ');
            const used = String(u.inodesUsed).padStart(6, ' ');
            const avail = String(u.inodesAvail).padStart(7, ' ');
            const pct = `${u.inodesUsePercent}%`.padStart(5, ' ');
            return `${dev} ${tot} ${used} ${avail} ${pct} ${u.mount}`;
          }),
        ];
        return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
      }

      const lines = [
        human
          ? 'Filesystem      Size  Used Avail Use% Mounted on'
          : 'Filesystem     1K-blocks      Used Available Use% Mounted on',
        ...usages.map((u) => {
          const dev = u.device.padEnd(14, ' ');
          const sizeStr = (human ? formatHumanBytes(u.sizeBytes) : String(Math.round(u.sizeBytes / 1024))).padStart(
            human ? 5 : 9,
            ' '
          );
          const usedStr = (human ? formatHumanBytes(u.usedBytes) : String(Math.round(u.usedBytes / 1024))).padStart(
            human ? 5 : 9,
            ' '
          );
          const availStr = (
            human ? formatHumanBytes(u.availBytes) : String(Math.round(u.availBytes / 1024))
          ).padStart(human ? 5 : 9, ' ');
          const pctStr = `${u.usePercent}%`.padStart(4, ' ');
          return `${dev} ${sizeStr} ${usedStr} ${availStr} ${pctStr} ${u.mount}`;
        }),
      ];

      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'du': {
      // Handle -d 1 as --max-depth=1
      const parsed = parseCommandFlags(args, {
        allowedShort: 'shax',
        shortWithValue: 'd',
        allowedLong: ['--max-depth'],
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const human = parsed.shortFlags.has('h');
      const summaryOnly = parsed.shortFlags.has('s');
      const maxDepthStr = parsed.flagValues.get('--max-depth') ?? parsed.flagValues.get('-d');
      const maxDepth = summaryOnly ? 0 : maxDepthStr !== undefined ? parseInt(maxDepthStr, 10) : 1;

      const targets = parsed.positional.length > 0 ? parsed.positional : ['.'];
      const outLines: string[] = [];
      const errLines: string[] = [];
      let exitCode = 0;

      const formatDuSize = (bytes: number): string =>
        human ? formatHumanBytes(bytes) : String(Math.max(4, Math.ceil(bytes / 1024)));

      for (const t of targets) {
        const abs = resolvePath(world.cwd, t, world.env.HOME);
        const node = getNode(world, abs);
        if (!node) {
          errLines.push(`du: cannot access '${t}': No such file or directory`);
          exitCode = 1;
          continue;
        }

        if (maxDepth > 0 && node.type === 'dir') {
          const children = listChildren(world, abs);
          for (const child of children) {
            if (child.type === 'dir' || parsed.shortFlags.has('a')) {
              const childBytes = getSubtreeBytes(world, child.path);
              const displayChild =
                t === '.' ? `./${ child.path.slice(abs === '/' ? 1 : abs.length + 1) }` : child.path;
              outLines.push(`${formatDuSize(childBytes)}\t${displayChild}`);
            }
          }
        }

        const totalBytes = getSubtreeBytes(world, abs);
        outLines.push(`${formatDuSize(totalBytes)}\t${t}`);
      }

      return {
        world,
        stdout: outLines.join('\n'),
        stderr: errLines.join('\n'),
        exitCode,
      };
    }

    case 'free': {
      const parsed = parseCommandFlags(args, { allowedShort: 'hmbg' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const human = parsed.shortFlags.has('h');
      const mem = world.memory;
      const availMB = mem.freeMB + Math.round(mem.buffCacheMB * 0.8);
      const swapTotal = mem.swapTotalMB ?? 2048;
      const swapUsed = mem.swapUsedMB ?? 0;
      const swapFree = Math.max(0, swapTotal - swapUsed);

      const fmt = (mb: number) =>
        human ? (mb >= 1024 ? `${(mb / 1024).toFixed(1)}Gi` : `${mb}Mi`) : String(mb);

      const out = [
        '               total        used        free      shared  buff/cache   available',
        `Mem:        ${fmt(mem.totalMB).padStart(8)}    ${fmt(mem.usedMB).padStart(8)}    ${fmt(mem.freeMB).padStart(8)}        ${fmt(24).padStart(4)}    ${fmt(mem.buffCacheMB).padStart(8)}    ${fmt(availMB).padStart(8)}`,
        `Swap:       ${fmt(swapTotal).padStart(8)}    ${fmt(swapUsed).padStart(8)}    ${fmt(swapFree).padStart(8)}`,
      ].join('\n');

      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'uptime': {
      const parsed = parseCommandFlags(args, { allowedShort: 'p' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const up =
        world.network.uptime ||
        '10:20:05 up 42 days,  4:02,  1 user,  load average: 0.25, 0.30, 0.28';
      return { world, stdout: up, stderr: '', exitCode: 0 };
    }

    case 'ps': {
      // Allow `ps aux`, `ps -ef`, `ps`
      for (const a of args) {
        if (a !== 'aux' && a !== '-ef' && a !== '-aux' && a !== '-e' && a !== 'ef') {
          return {
            world,
            stdout: '',
            stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${a}`,
            exitCode: 2,
          };
        }
      }
      const lines = [
        'USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND',
        ...world.processes.map((p) => {
          const usr = p.user.padEnd(8, ' ');
          const pid = String(p.pid).padStart(7, ' ');
          const cpu = p.cpu.toFixed(1).padStart(4, ' ');
          const mem = p.mem.toFixed(1).padStart(4, ' ');
          const vsz = String(p.vsz ?? 182400).padStart(6, ' ');
          const rss = String(p.rss ?? 28400).padStart(5, ' ');
          const stat = (p.stat ?? 'Ss').padEnd(4, ' ');
          const start = (p.start ?? '08:00').padEnd(5, ' ');
          const time = (p.time ?? '0:01').padStart(6, ' ');
          return `${usr} ${pid} ${cpu} ${mem} ${vsz} ${rss} ?        ${stat} ${start} ${time} ${p.command}`;
        }),
      ];
      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'top': {
      // Support top, top -bn1, top -b -n 1
      const normArgs = args.map((a) => (a === '-bn1' ? ['-b', '-n', '1'] : [a])).flat();
      const parsed = parseCommandFlags(normArgs, {
        allowedShort: 'b',
        shortWithValue: 'n',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const mem = world.memory;
      const header = [
        `top - ${world.network.uptime || '10:20:05 up 42 days,  4:02,  1 user,  load average: 0.25, 0.30, 0.28'}`,
        `Tasks: ${world.processes.length} total,   1 running, ${Math.max(0, world.processes.length - 1)} sleeping,   0 stopped,   0 zombie`,
        '%Cpu(s):  2.1 us,  0.8 sy,  0.0 ni, 96.9 id,  0.2 wa,  0.0 hi,  0.0 si,  0.0 st',
        `MiB Mem :   ${mem.totalMB.toFixed(1)} total,   ${mem.freeMB.toFixed(1)} free,   ${mem.usedMB.toFixed(1)} used,   ${mem.buffCacheMB.toFixed(1)} buff/cache`,
        '',
        '    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND',
        ...world.processes.map((p) => {
          const pid = String(p.pid).padStart(7, ' ');
          const usr = p.user.slice(0, 8).padEnd(9, ' ');
          const cpu = p.cpu.toFixed(1).padStart(5, ' ');
          const m = p.mem.toFixed(1).padStart(5, ' ');
          const cmdName = p.command.split(' ')[0].split('/').pop() || p.command;
          return `${pid} ${usr} 20   0  182400  28400  12000 S ${cpu} ${m}   0:01.24 ${cmdName}`;
        }),
      ];
      return { world, stdout: header.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'kill':
    case 'pkill': {
      const cleanArgs = args.filter((a) => a !== '-9' && a !== '-15' && a !== '-TERM' && a !== '-KILL');
      for (const a of cleanArgs) {
        if (a.startsWith('-')) {
          return {
            world,
            stdout: '',
            stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${a}`,
            exitCode: 2,
          };
        }
      }
      if (cleanArgs.length === 0) {
        return { world, stdout: '', stderr: `${cmd}: usage: ${cmd} [-9] <pid|name>`, exitCode: 1 };
      }

      const target = cleanArgs[0];
      const procIdx = world.processes.findIndex((p) =>
        cmd === 'kill' ? String(p.pid) === target : p.command.includes(target)
      );
      if (procIdx === -1) {
        return {
          world,
          stdout: '',
          stderr: `bash: ${cmd}: (${target}) - No such process`,
          exitCode: 1,
        };
      }
      const proc = world.processes[procIdx];
      if (proc.pid === 1) {
        return { world, stdout: '', stderr: `${cmd}: (1) - Operation not permitted`, exitCode: 1 };
      }
      world.processes.splice(procIdx, 1);
      if (proc.service) {
        const svc = world.services.find((s) => s.name === proc.service);
        if (svc) svc.state = 'inactive';
        if (world.network.listening) {
          world.network.listening = world.network.listening.filter(
            (l) => l.service !== proc.service && l.pid !== proc.pid
          );
        }
      }
      return { world, stdout: '', stderr: '', exitCode: 0 };
    }

    case 'uname': {
      const parsed = parseCommandFlags(args, { allowedShort: 'arsnmv' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.shortFlags.has('a')) {
        return {
          world,
          stdout:
            world.network.uname ||
            `Linux ${world.hostname} 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 x86_64 GNU/Linux`,
          stderr: '',
          exitCode: 0,
        };
      }
      if (parsed.shortFlags.has('r')) {
        return { world, stdout: '6.1.0-26-amd64', stderr: '', exitCode: 0 };
      }
      return { world, stdout: 'Linux', stderr: '', exitCode: 0 };
    }

    case 'hostname': {
      const parsed = parseCommandFlags(args, { allowedShort: 'Iif' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      return { world, stdout: world.hostname, stderr: '', exitCode: 0 };
    }

    case 'date': {
      const parsed = parseCommandFlags(args, { allowedShort: 'uR' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      return { world, stdout: 'Wed Nov  4 10:35:00 ICT 2026', stderr: '', exitCode: 0 };
    }

    case 'nproc': {
      const parsed = parseCommandFlags(args, {});
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      return { world, stdout: String(world.network.nproc ?? 4), stderr: '', exitCode: 0 };
    }

    case 'dmesg': {
      const parsed = parseCommandFlags(args, { allowedShort: 'T' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const lines = world.network.dmesg || [
        '[    0.000000] Linux version 6.1.0-26-amd64 (debian-kernel@lists.debian.org)',
        '[    1.421008] EXT4-fs (sda1): mounted filesystem with ordered data mode.',
      ];
      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'lsof': {
      const parsed = parseCommandFlags(args, {
        allowedShort: 'Pn',
        shortWithValue: 'i',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (world.network.lsof && world.network.lsof.length > 0) {
        return { world, stdout: world.network.lsof.join('\n'), stderr: '', exitCode: 0 };
      }
      const listening = world.network.listening || [];
      const lines = [
        'COMMAND    PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME',
        ...listening.map(
          (l) =>
            `${l.process.padEnd(9, ' ')} ${String(l.pid).padStart(4, ' ')}     root    6u  IPv4  18492      0t0  ${l.proto.toUpperCase()} ${l.localAddr}:${l.port} (LISTEN)`
        ),
      ];
      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'crontab': {
      const parsed = parseCommandFlags(args, { allowedShort: 'l' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (!parsed.shortFlags.has('l')) {
        return {
          world,
          stdout: '',
          stderr: '(sandbox) รองรับเฉพาะ crontab -l ในโหมดจำลอง',
          exitCode: 2,
        };
      }
      const cronLines = world.network.crontab || [
        '# m h  dom mon dow   command',
        '0 3 * * * /usr/local/bin/backup-db.sh >> /var/log/backup.log 2>&1',
      ];
      return { world, stdout: cronLines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'systemctl': {
      const parsed = parseCommandFlags(args, {
        allowedShort: 'l',
        allowedLong: ['--no-pager'],
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const [action, rawSvcName] = parsed.positional;
      if (!action) {
        return {
          world,
          stdout: '',
          stderr: 'systemctl: missing action (status|start|stop|restart|is-active|enable)',
          exitCode: 1,
        };
      }

      const validActions = new Set(['status', 'start', 'stop', 'restart', 'is-active', 'enable']);
      if (!validActions.has(action)) {
        return {
          world,
          stdout: '',
          stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: systemctl ${action}`,
          exitCode: 2,
        };
      }

      if (!rawSvcName) {
        return {
          world,
          stdout: '',
          stderr: `systemctl ${action}: missing unit name`,
          exitCode: 1,
        };
      }

      const svcName = rawSvcName.replace(/\.service$/, '');
      const svc = world.services.find((s) => s.name === svcName);
      if (!svc) {
        return {
          world,
          stdout: '',
          stderr: `Unit ${svcName}.service could not be found.`,
          exitCode: 4,
        };
      }

      const stopService = () => {
        svc.state = 'inactive';
        if (world.network.listening) {
          world.network.listening = world.network.listening.filter(
            (l) => l.service !== svc.name && (!svc.pid || l.pid !== svc.pid)
          );
        }
        world.processes = world.processes.filter((p) => p.service !== svc.name);
        svc.pid = undefined;
      };

      const startService = (): { ok: boolean; err?: string } => {
        const requiredPorts = svc.dependsOnFreePorts || svc.ports || [];
        const listening = world.network.listening || [];
        for (const port of requiredPorts) {
          const conflict = listening.find((l) => l.port === port && l.service !== svc.name);
          if (conflict) {
            svc.state = 'failed';
            return {
              ok: false,
              err: `Job for ${svc.name}.service failed because the control process exited with error code.\nSee "systemctl status ${svc.name}.service" and "journalctl -xeu ${svc.name}.service" for details.`,
            };
          }
        }

        svc.state = 'active';
        const newPid = svc.pid || 2240;
        svc.pid = newPid;

        if (!world.network.listening) world.network.listening = [];
        for (const port of svc.ports || []) {
          if (!world.network.listening.some((l) => l.port === port && l.service === svc.name)) {
            world.network.listening.push({
              proto: 'tcp',
              localAddr: '0.0.0.0',
              port,
              pid: newPid,
              process: svc.name,
              service: svc.name,
            });
          }
        }

        if (!world.processes.some((p) => p.service === svc.name)) {
          world.processes.push({
            pid: newPid,
            user: 'root',
            cpu: 0.2,
            mem: 1.2,
            command: `/usr/sbin/${svc.name} -g daemon on;`,
            service: svc.name,
          });
        }

        return { ok: true };
      };

      if (action === 'is-active') {
        return {
          world,
          stdout: svc.state,
          stderr: '',
          exitCode: svc.state === 'active' ? 0 : 3,
        };
      }

      if (action === 'enable') {
        svc.enabled = true;
        return { world, stdout: '', stderr: '', exitCode: 0 };
      }

      if (action === 'stop') {
        stopService();
        return { world, stdout: '', stderr: '', exitCode: 0 };
      }

      if (action === 'start') {
        const res = startService();
        if (!res.ok) {
          return { world, stdout: '', stderr: res.err || 'Failed to start service', exitCode: 1 };
        }
        return { world, stdout: '', stderr: '', exitCode: 0 };
      }

      if (action === 'restart') {
        stopService();
        const res = startService();
        if (!res.ok) {
          return { world, stdout: '', stderr: res.err || 'Failed to restart service', exitCode: 1 };
        }
        return { world, stdout: '', stderr: '', exitCode: 0 };
      }

      // status
      const dot = svc.state === 'active' ? '●' : svc.state === 'failed' ? '×' : '○';
      const activeDetail =
        svc.state === 'active'
          ? 'active (running)'
          : svc.state === 'failed'
          ? 'failed (Result: exit-code)'
          : 'inactive (dead)';
      const journalLines =
        (svc.state === 'active'
          ? svc.journal?.active
          : svc.state === 'failed'
          ? svc.journal?.failed
          : svc.journal?.inactive) || [];

      const out = [
        `${dot} ${svc.name}.service - ${svc.description || svc.name + ' service'}`,
        `     Loaded: loaded (/lib/systemd/system/${svc.name}.service; ${svc.enabled ? 'enabled' : 'disabled'}; preset: enabled)`,
        `     Active: ${activeDetail} since Wed 2026-11-04 10:15:02 ICT; 2min ago`,
        ...(svc.pid ? [`   Main PID: ${svc.pid} (${svc.name})`] : []),
        '',
        ...journalLines,
      ].join('\n');

      return {
        world,
        stdout: out,
        stderr: '',
        exitCode: svc.state === 'active' ? 0 : 3,
      };
    }

    case 'journalctl': {
      const parsed = parseCommandFlags(args, {
        allowedShort: 'fxe',
        shortWithValue: 'un',
        allowedLong: ['--since', '--no-pager'],
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      const unitRaw = parsed.flagValues.get('-u');
      const countStr = parsed.flagValues.get('-n') || '50';
      const count = Math.max(1, parseInt(countStr, 10) || 50);

      if (unitRaw) {
        const svcName = unitRaw.replace(/\.service$/, '');
        const svc = world.services.find((s) => s.name === svcName);
        if (!svc) {
          return { world, stdout: '-- No entries --', stderr: '', exitCode: 0 };
        }
        const lines =
          (svc.state === 'active'
            ? svc.journal?.active
            : svc.state === 'failed'
            ? svc.journal?.failed
            : svc.journal?.inactive) || [];
        return {
          world,
          stdout: lines.slice(-count).join('\n') || '-- No entries --',
          stderr: '',
          exitCode: 0,
        };
      }

      const allLines: string[] = [];
      for (const s of world.services) {
        const sLines =
          (s.state === 'active'
            ? s.journal?.active
            : s.state === 'failed'
            ? s.journal?.failed
            : s.journal?.inactive) || [];
        allLines.push(...sLines);
      }
      return {
        world,
        stdout: allLines.slice(-count).join('\n') || '-- No entries --',
        stderr: '',
        exitCode: 0,
      };
    }

    default:
      return null;
  }
}
