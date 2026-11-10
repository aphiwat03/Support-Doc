import { ExecResult, World } from '../types';
import { getNode } from '../vfs';
import { parseCommandFlags } from './flagUtils';

const MAN_PAGES: Record<string, string> = {
  df: [
    'NAME: df - report file system disk space usage',
    'SYNOPSIS: df [-h] [-i]',
    'DESCRIPTION: Displays the amount of disk space available on each mounted filesystem.',
    '  -h  Print sizes in human readable format (e.g., 1K 234M 2G)',
    '  -i  List inode information instead of block usage',
  ].join('\n'),
  du: [
    'NAME: du - estimate file space usage',
    'SYNOPSIS: du [-sh] [--max-depth=N] [FILE]...',
    'DESCRIPTION: Summarizes disk usage of the set of FILEs, recursively for directories.',
    '  -s  Display only a total for each argument',
    '  -h  Print sizes in human readable format',
  ].join('\n'),
  systemctl: [
    'NAME: systemctl - Control the systemd system and service manager',
    'SYNOPSIS: systemctl [status|start|stop|restart|is-active|enable] UNIT',
    'DESCRIPTION: Query or send control commands to the systemd manager.',
  ].join('\n'),
  journalctl: [
    'NAME: journalctl - Query the systemd journal',
    'SYNOPSIS: journalctl [-u UNIT] [-n LINES]',
    'DESCRIPTION: Print log entries stored in the systemd journal.',
  ].join('\n'),
  ss: [
    'NAME: ss - another utility to investigate sockets',
    'SYNOPSIS: ss [-tulnp]',
    'DESCRIPTION: Dump socket statistics and listening ports with process info.',
  ].join('\n'),
  chmod: [
    'NAME: chmod - change file mode bits',
    'SYNOPSIS: chmod [MODE] FILE',
    'DESCRIPTION: Changes the file mode bits of each given file (e.g. u+x, 0755).',
  ].join('\n'),
  grep: [
    'NAME: grep - print lines that match patterns',
    'SYNOPSIS: grep [-invcrE] PATTERN [FILE]...',
    'DESCRIPTION: Searches input files for lines containing a match to the given PATTERN.',
  ].join('\n'),
  awk: [
    "NAME: awk - pattern scanning and processing language",
    "SYNOPSIS: awk '{print $N}' [FILE]",
    'DESCRIPTION: Extracts whitespace-delimited fields from each input line.',
  ].join('\n'),
  dig: [
    'NAME: dig - DNS lookup utility',
    'SYNOPSIS: dig [@server] name [+short]',
    'DESCRIPTION: Interrogates DNS name servers for domain resolution.',
  ].join('\n'),
  escalate: [
    'NAME: escalate - send incident escalation note (SupportHub Sandbox)',
    'SYNOPSIS: escalate "<message>"',
    'DESCRIPTION: Records an escalation report to Tier 2 / Infrastructure team.',
  ].join('\n'),
};

export const SUPPORTED_COMMANDS = [
  'pwd',
  'ls',
  'cd',
  'cat',
  'head',
  'tail',
  'mkdir',
  'touch',
  'cp',
  'mv',
  'rm',
  'ln',
  'stat',
  'find',
  'file',
  'chmod',
  'chown',
  'id',
  'whoami',
  'echo',
  'grep',
  'wc',
  'sort',
  'uniq',
  'cut',
  'awk',
  'tee',
  'df',
  'du',
  'free',
  'uptime',
  'ps',
  'top',
  'kill',
  'pkill',
  'uname',
  'hostname',
  'date',
  'nproc',
  'dmesg',
  'lsof',
  'systemctl',
  'journalctl',
  'crontab',
  'ip',
  'ping',
  'ss',
  'curl',
  'dig',
  'nc',
  'traceroute',
  'ssh',
  'mdadm',
  'smartctl',
  'ipmitool',
  'help',
  'man',
  'history',
  'clear',
  'exit',
  'escalate',
];

export function runNetworkShellCommand(
  cmd: string,
  args: string[],
  world: World
): ExecResult | null {
  switch (cmd) {
    case 'ip': {
      // Support `ip -br addr`, `ip addr`, `ip a`, `ip route`, `ip r`
      const isBrief = args.includes('-br') || args.includes('-brief');
      const rest = args.filter((a) => a !== '-br' && a !== '-brief' && a !== '-4');
      for (const r of rest) {
        if (r.startsWith('-')) {
          return {
            world,
            stdout: '',
            stderr: `(sandbox) option นี้ยังไม่รองรับในโหมดจำลอง: ${r}`,
            exitCode: 2,
          };
        }
      }
      const sub = rest[0] || 'addr';
      if (sub === 'addr' || sub === 'a' || sub === 'address') {
        const ifaces = world.network.interfaces || [
          { name: 'lo', state: 'UNKNOWN', addr: '127.0.0.1/8' },
          { name: 'eth0', state: 'UP', addr: '10.0.1.10/24' },
        ];
        if (isBrief) {
          const out = ifaces
            .map((i) => `${i.name.padEnd(15, ' ')} ${i.state.padEnd(14, ' ')} ${i.addr}`)
            .join('\n');
          return { world, stdout: out, stderr: '', exitCode: 0 };
        }
        const out = ifaces
          .map(
            (i, idx) =>
              `${idx + 1}: ${i.name}: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state ${i.state}\n    inet ${i.addr} scope global ${i.name}`
          )
          .join('\n');
        return { world, stdout: out, stderr: '', exitCode: 0 };
      }

      if (sub === 'route' || sub === 'r') {
        const routes = world.network.routes || [
          'default via 10.0.1.1 dev eth0 proto static',
          '10.0.1.0/24 dev eth0 proto kernel scope link src 10.0.1.10',
        ];
        return { world, stdout: routes.join('\n'), stderr: '', exitCode: 0 };
      }

      return {
        world,
        stdout: '',
        stderr: `Object "${sub}" is unknown, try "ip addr" or "ip route".`,
        exitCode: 1,
      };
    }

    case 'ss': {
      const parsed = parseCommandFlags(args, { allowedShort: 'tulnpa46' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const listening = world.network.listening || [];
      const showProc = parsed.shortFlags.has('p');
      const lines = [
        'Netid  State   Recv-Q  Send-Q   Local Address:Port    Peer Address:Port  Process',
        ...listening.map((l) => {
          const proto = l.proto.padEnd(6, ' ');
          const local = `${l.localAddr}:${l.port}`.padEnd(21, ' ');
          const peer = '0.0.0.0:*'.padEnd(18, ' ');
          const procInfo = showProc ? `users:(("${l.process}",pid=${l.pid},fd=6))` : '';
          return `${proto} LISTEN  0       511      ${local} ${peer} ${procInfo}`.trimEnd();
        }),
      ];
      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'ping': {
      const parsed = parseCommandFlags(args, {
        shortWithValue: 'cW',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const target = parsed.positional[0];
      if (!target) {
        return { world, stdout: '', stderr: 'ping: usage error: Destination address required', exitCode: 1 };
      }
      const count = Math.min(10, Math.max(1, parseInt(parsed.flagValues.get('-c') || '3', 10) || 3));

      // Check if DNS resolution is required
      const isIp = /^\d+\.\d+\.\d+\.\d+$/.test(target) || target === 'localhost';
      if (!isIp) {
        const resolv = getNode(world, '/etc/resolv.conf');
        if (resolv?.content?.includes('10.99.99.254')) {
          return {
            world,
            stdout: '',
            stderr: `ping: ${target}: Name or service not known`,
            exitCode: 2,
          };
        }
      }

      const ip = target === 'localhost' ? '127.0.0.1' : isIp ? target : '93.184.215.14';
      const seqLines = Array.from(
        { length: count },
        (_, idx) => `64 bytes from ${ip}: icmp_seq=${idx + 1} ttl=117 time=12.4 ms`
      );
      const out = [
        `PING ${target} (${ip}) 56(84) bytes of data.`,
        ...seqLines,
        '',
        `--- ${target} ping statistics ---`,
        `${count} packets transmitted, ${count} received, 0% packet loss, time ${(count - 1) * 1001}ms`,
        'rtt min/avg/max/mdev = 12.100/12.400/12.700/0.200 ms',
      ].join('\n');
      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'dig': {
      const parsed = parseCommandFlags(args, {
        allowPlusFlags: true,
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };

      let server = '';
      let domain = '';
      for (const p of parsed.positional) {
        if (p.startsWith('@')) server = p.slice(1);
        else if (!domain) domain = p;
      }

      if (!domain) {
        return { world, stdout: '', stderr: 'Usage: dig [@server] domain [+short]', exitCode: 1 };
      }

      const isShort = parsed.longFlags.has('+short');
      const resolv = getNode(world, '/etc/resolv.conf');
      const defaultBadDns = resolv?.content?.includes('10.99.99.254');

      if ((!server && defaultBadDns) || server === '10.99.99.254') {
        return {
          world,
          stdout: ';; connection timed out; no servers could be reached',
          stderr: '',
          exitCode: 9,
        };
      }

      const resolvedIp = domain.includes('example.com') ? '93.184.215.14' : '10.0.1.50';
      if (isShort) {
        return { world, stdout: resolvedIp, stderr: '', exitCode: 0 };
      }

      const usedServer = server || '8.8.8.8';
      const out = [
        ';; QUESTION SECTION:',
        `;${domain}.\t\t\tIN\tA`,
        '',
        ';; ANSWER SECTION:',
        `${domain}.\t\t300\tIN\tA\t${resolvedIp}`,
        '',
        ';; Query time: 16 msec',
        `;; SERVER: ${usedServer}#53(${usedServer})`,
        ';; MSG SIZE  rcvd: 56',
      ].join('\n');
      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'curl': {
      const parsed = parseCommandFlags(args, {
        allowedShort: 'IsvkL',
        shortWithValue: 'owHX',
      });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const url = parsed.positional[0];
      if (!url) {
        return {
          world,
          stdout: '',
          stderr: 'curl: try \'curl --help\' for more information',
          exitCode: 2,
        };
      }

      const isHead = parsed.shortFlags.has('I');
      const isVerbose = parsed.shortFlags.has('v');
      const writeOut = parsed.flagValues.get('-w');
      const outTarget = parsed.flagValues.get('-o');

      // Check if localhost / port 80
      let port = 80;
      const portMatch = url.match(/:(\d+)/);
      if (portMatch) port = parseInt(portMatch[1], 10);
      else if (url.startsWith('https://')) port = 443;

      const isLocal = url.includes('localhost') || url.includes('127.0.0.1');
      if (isLocal) {
        const listener = (world.network.listening || []).find((l) => l.port === port);
        if (!listener) {
          return {
            world,
            stdout: '',
            stderr: `curl: (7) Failed to connect to localhost port ${port}: Connection refused`,
            exitCode: 7,
          };
        }
        const serverName = listener.service === 'nginx' ? 'nginx/1.24.0' : 'Apache/2.4.59 (Debian)';
        const headers = [
          'HTTP/1.1 200 OK',
          `Server: ${serverName}`,
          'Date: Wed, 04 Nov 2026 03:20:00 GMT',
          'Content-Type: text/html; charset=UTF-8',
          'Connection: keep-alive',
        ].join('\n');

        if (writeOut?.includes('%{http_code}')) {
          return { world, stdout: '200', stderr: '', exitCode: 0 };
        }
        if (isHead) {
          return { world, stdout: headers, stderr: '', exitCode: 0 };
        }
        if (outTarget === '/dev/null') {
          return { world, stdout: '', stderr: '', exitCode: 0 };
        }
        const body = `<!DOCTYPE html><html><head><title>Welcome to ${listener.service || 'web'}!</title></head><body><h1>OK</h1></body></html>`;
        const full = isVerbose ? `* Connected to localhost (127.0.0.1) port ${port}\n< ${headers.replace(/\n/g, '\n< ')}\n\n${body}` : body;
        return { world, stdout: full, stderr: '', exitCode: 0 };
      }

      return {
        world,
        stdout: isHead ? 'HTTP/1.1 200 OK\nContent-Type: application/json' : '{"status":"ok"}',
        stderr: '',
        exitCode: 0,
      };
    }

    case 'nc': {
      const parsed = parseCommandFlags(args, { allowedShort: 'zvnw' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      if (parsed.positional.length < 2) {
        return { world, stdout: '', stderr: 'usage: nc [-zv] host port', exitCode: 1 };
      }
      const [host, portStr] = parsed.positional;
      const port = parseInt(portStr, 10);
      const isOpen = (world.network.listening || []).some((l) => l.port === port);
      if (isOpen) {
        return {
          world,
          stdout: `Connection to ${host} ${port} port [tcp/*] succeeded!`,
          stderr: '',
          exitCode: 0,
        };
      }
      return {
        world,
        stdout: '',
        stderr: `nc: connect to ${host} port ${port} (tcp) failed: Connection refused`,
        exitCode: 1,
      };
    }

    case 'traceroute': {
      const parsed = parseCommandFlags(args, { allowedShort: 'n' });
      if (!parsed.ok) return { world, stdout: '', stderr: parsed.error, exitCode: 2 };
      const target = parsed.positional[0] || '8.8.8.8';
      const out = [
        `traceroute to ${target} (${target}), 30 hops max, 60 byte packets`,
        ' 1  10.0.2.1  0.842 ms  0.790 ms  0.755 ms',
        ' 2  172.16.0.1  3.412 ms  3.380 ms  3.510 ms',
        ` 3  ${target}  14.120 ms  13.980 ms  14.050 ms`,
      ].join('\n');
      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'ssh': {
      return {
        world,
        stdout: '',
        stderr: 'ssh: connect to remote host: Connection refused (sandbox)',
        exitCode: 255,
      };
    }

    case 'help': {
      const out = [
        'SupportHub Terminal Sandbox — คำสั่งที่รองรับ:',
        '  นำทาง/ไฟล์ : pwd, ls (-laht), cd, cat, head, tail, mkdir (-p), touch, cp, mv, rm (-rf), ln -s, stat, find, file',
        '  สิทธิ์ผู้ใช้  : chmod, chown, id, whoami',
        '  ข้อความ    : echo, grep (-invcrE), wc (-l), sort (-nr), uniq (-c), cut (-d -f), awk \'{print $N}\', tee',
        '  ระบบ       : df (-h -i), du (-sh), free -h, uptime, ps aux, top -bn1, kill, pkill, uname -a, hostname, date, nproc, dmesg, lsof',
        '  Service/Log: systemctl (status|start|stop|restart|is-active|enable), journalctl (-u -n), crontab -l',
        '  เครือข่าย   : ip (-br addr|route), ping (-c), ss (-tulnp), curl (-I -s -v), dig (@server +short), nc (-zv), traceroute -n',
        '  เชลล์/พิเศษ : man <cmd>, history, clear, escalate "<ข้อความรายงาน>"',
      ].join('\n');
      return { world, stdout: out, stderr: '', exitCode: 0 };
    }

    case 'man': {
      const topic = args[0];
      if (!topic) {
        return { world, stdout: '', stderr: 'What manual page do you want?', exitCode: 1 };
      }
      const page = MAN_PAGES[topic];
      if (!page) {
        return { world, stdout: '', stderr: `No manual entry for ${topic}`, exitCode: 16 };
      }
      return { world, stdout: page, stderr: '', exitCode: 0 };
    }

    case 'history': {
      const lines = world.history.map(
        (h, idx) => `${String(idx + 1).padStart(5, ' ')}  ${h.command}`
      );
      return { world, stdout: lines.join('\n'), stderr: '', exitCode: 0 };
    }

    case 'clear': {
      return { world, stdout: '', stderr: '', exitCode: 0, clear: true };
    }

    case 'exit': {
      return {
        world,
        stdout: '(sandbox) เทอร์มินัลจำลองไม่ปิดตัวเอง — ใช้ปุ่ม "เริ่มใหม่" หรือกลับไปหน้ารวมแล็บ',
        stderr: '',
        exitCode: 0,
      };
    }

    case 'alias': {
      return {
        world,
        stdout: '',
        stderr: '(sandbox) ไม่รองรับคำสั่ง alias ในโหมดจำลอง',
        exitCode: 2,
      };
    }

    case 'escalate': {
      const note = args.join(' ').trim();
      if (!note) {
        return {
          world,
          stdout: '',
          stderr: 'Usage: escalate "<รายละเอียดปัญหาและข้อมูลที่ตรวจพบ>"',
          exitCode: 1,
        };
      }
      world.escalations.push(note);
      return {
        world,
        stdout: `[ESCALATION RECORDED] ส่งรายงานต่อให้ทีมที่เกี่ยวข้องเรียบร้อย: "${note}"`,
        stderr: '',
        exitCode: 0,
      };
    }

    default:
      return null;
  }
}
