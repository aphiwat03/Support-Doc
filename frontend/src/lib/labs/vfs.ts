import { DiskMount, Lab, VfsEntry, World } from './types';

const textEncoder = new TextEncoder();

export function byteLength(str: string): number {
  return textEncoder.encode(str).length;
}

export function getEntrySizeBytes(entry: VfsEntry): number {
  if (typeof entry.sizeBytes === 'number') {
    return entry.sizeBytes;
  }
  if (typeof entry.content === 'string') {
    return byteLength(entry.content);
  }
  return entry.type === 'dir' ? 4096 : 0;
}

export function resolvePath(cwd: string, targetPath: string, homeDir = '/home/support'): string {
  let raw = targetPath.trim();
  if (!raw || raw === '~') {
    raw = homeDir;
  } else if (raw.startsWith('~/')) {
    raw = homeDir + raw.slice(1);
  } else if (!raw.startsWith('/')) {
    raw = (cwd === '/' ? '' : cwd) + '/' + raw;
  }

  const parts = raw.split('/');
  const stack: string[] = [];
  for (const part of parts) {
    if (!part || part === '.') continue;
    if (part === '..') {
      stack.pop();
    } else {
      stack.push(part);
    }
  }
  return '/' + stack.join('/');
}

export function dirname(absPath: string): string {
  const normalized = resolvePath('/', absPath);
  if (normalized === '/') return '/';
  const idx = normalized.lastIndexOf('/');
  return idx <= 0 ? '/' : normalized.slice(0, idx);
}

export function basename(absPath: string): string {
  const normalized = resolvePath('/', absPath);
  if (normalized === '/') return '/';
  const idx = normalized.lastIndexOf('/');
  return normalized.slice(idx + 1);
}

export function ensureParentDirs(entries: VfsEntry[], defaultOwner = 'root'): VfsEntry[] {
  const map = new Map<string, VfsEntry>();

  const addDirChain = (dirPath: string, owner = defaultOwner) => {
    const normalized = resolvePath('/', dirPath);
    const parts = normalized.split('/').filter(Boolean);
    let current = '';
    if (!map.has('/')) {
      map.set('/', {
        path: '/',
        type: 'dir',
        mode: '0755',
        owner: 'root',
        group: 'root',
        mtime: '2026-11-04T08:00:00Z',
      });
    }
    for (const part of parts) {
      current += '/' + part;
      if (!map.has(current)) {
        map.set(current, {
          path: current,
          type: 'dir',
          mode: '0755',
          owner,
          group: owner,
          mtime: '2026-11-04T08:00:00Z',
        });
      }
    }
  };

  addDirChain('/');
  addDirChain('/etc');
  addDirChain('/var');
  addDirChain('/var/log');
  addDirChain('/tmp');

  for (const entry of entries) {
    const normPath = resolvePath('/', entry.path);
    const parent = dirname(normPath);
    addDirChain(parent);
    map.set(normPath, {
      ...entry,
      path: normPath,
      sizeBytes: getEntrySizeBytes(entry),
    });
  }

  return Array.from(map.values()).sort((a, b) => a.path.localeCompare(b.path));
}

export function createInitialWorld(lab: Lab): World {
  const homeDir = `/home/${lab.host.user}`;
  const baseEntries: VfsEntry[] = [
    {
      path: homeDir,
      type: 'dir',
      mode: '0755',
      owner: lab.host.user,
      group: lab.host.user,
      mtime: '2026-11-04T08:00:00Z',
    },
    ...lab.world.fs.map((e) => ({
      ...e,
      previewLines: e.previewLines ? [...e.previewLines] : undefined,
    })),
  ];

  // Ensure cwd exists
  const initialCwd = resolvePath('/', lab.host.cwd, homeDir);
  if (!baseEntries.some((e) => resolvePath('/', e.path) === initialCwd)) {
    baseEntries.push({
      path: initialCwd,
      type: 'dir',
      mode: '0755',
      owner: lab.host.user,
      group: lab.host.user,
      mtime: '2026-11-04T08:00:00Z',
    });
  }

  const fsWithParents = ensureParentDirs(baseEntries, 'root');

  return {
    fs: fsWithParents,
    disks: lab.world.disks.map((d) => ({ ...d })),
    memory: { ...lab.world.memory },
    processes: lab.world.processes.map((p) => ({ ...p })),
    services: lab.world.services.map((s) => ({
      ...s,
      ports: s.ports ? [...s.ports] : undefined,
      dependsOnFreePorts: s.dependsOnFreePorts ? [...s.dependsOnFreePorts] : undefined,
      journal: s.journal
        ? {
            active: s.journal.active ? [...s.journal.active] : undefined,
            failed: s.journal.failed ? [...s.journal.failed] : undefined,
            inactive: s.journal.inactive ? [...s.journal.inactive] : undefined,
          }
        : undefined,
    })),
    network: {
      interfaces: lab.world.network.interfaces
        ? lab.world.network.interfaces.map((i) => ({ ...i }))
        : undefined,
      routes: lab.world.network.routes ? [...lab.world.network.routes] : undefined,
      listening: lab.world.network.listening
        ? lab.world.network.listening.map((l) => ({ ...l }))
        : undefined,
      uptime: lab.world.network.uptime,
      uname: lab.world.network.uname,
      nproc: lab.world.network.nproc,
      dmesg: lab.world.network.dmesg ? [...lab.world.network.dmesg] : undefined,
      lsof: lab.world.network.lsof ? [...lab.world.network.lsof] : undefined,
      crontab: lab.world.network.crontab ? [...lab.world.network.crontab] : undefined,
    },
    user: lab.host.user,
    hostname: lab.host.hostname,
    cwd: initialCwd,
    env: {
      HOME: homeDir,
      USER: lab.host.user,
      HOSTNAME: lab.host.hostname,
      PATH: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    },
    lastExitCode: 0,
    history: [],
    escalations: [],
    insecureChmod777Used: false,
  };
}

export function cloneWorld(world: World): World {
  return {
    fs: world.fs.map((e) => ({
      ...e,
      previewLines: e.previewLines ? [...e.previewLines] : undefined,
    })),
    disks: world.disks.map((d) => ({ ...d })),
    memory: { ...world.memory },
    processes: world.processes.map((p) => ({ ...p })),
    services: world.services.map((s) => ({
      ...s,
      ports: s.ports ? [...s.ports] : undefined,
      dependsOnFreePorts: s.dependsOnFreePorts ? [...s.dependsOnFreePorts] : undefined,
      journal: s.journal
        ? {
            active: s.journal.active ? [...s.journal.active] : undefined,
            failed: s.journal.failed ? [...s.journal.failed] : undefined,
            inactive: s.journal.inactive ? [...s.journal.inactive] : undefined,
          }
        : undefined,
    })),
    network: {
      interfaces: world.network.interfaces
        ? world.network.interfaces.map((i) => ({ ...i }))
        : undefined,
      routes: world.network.routes ? [...world.network.routes] : undefined,
      listening: world.network.listening
        ? world.network.listening.map((l) => ({ ...l }))
        : undefined,
      uptime: world.network.uptime,
      uname: world.network.uname,
      nproc: world.network.nproc,
      dmesg: world.network.dmesg ? [...world.network.dmesg] : undefined,
      lsof: world.network.lsof ? [...world.network.lsof] : undefined,
      crontab: world.network.crontab ? [...world.network.crontab] : undefined,
    },
    user: world.user,
    hostname: world.hostname,
    cwd: world.cwd,
    env: { ...world.env },
    lastExitCode: world.lastExitCode,
    history: world.history.map((h) => ({ ...h })),
    escalations: [...world.escalations],
    insecureChmod777Used: world.insecureChmod777Used,
  };
}

export function getNode(world: World, absPath: string): VfsEntry | undefined {
  const norm = resolvePath('/', absPath);
  return world.fs.find((e) => e.path === norm);
}

export function resolveSymlink(world: World, entry: VfsEntry, maxDepth = 5): VfsEntry {
  let current = entry;
  let depth = 0;
  while (current.type === 'symlink' && current.target && depth < maxDepth) {
    const targetAbs = resolvePath(dirname(current.path), current.target, world.env.HOME);
    const next = getNode(world, targetAbs);
    if (!next) break;
    current = next;
    depth++;
  }
  return current;
}

export function listChildren(world: World, dirAbsPath: string): VfsEntry[] {
  const norm = resolvePath('/', dirAbsPath);
  const prefix = norm === '/' ? '/' : norm + '/';
  return world.fs.filter((e) => {
    if (e.path === norm) return false;
    if (!e.path.startsWith(prefix)) return false;
    const rest = e.path.slice(prefix.length);
    return !rest.includes('/');
  });
}

export function getSubtreeBytes(world: World, dirAbsPath: string): number {
  const norm = resolvePath('/', dirAbsPath);
  const prefix = norm === '/' ? '/' : norm + '/';
  let sum = 0;
  for (const e of world.fs) {
    if (e.path === norm || e.path.startsWith(prefix)) {
      if (e.type === 'file') {
        sum += getEntrySizeBytes(e);
      }
    }
  }
  return sum;
}

export interface ComputedDiskUsage extends DiskMount {
  usedBytes: number;
  availBytes: number;
  usePercent: number;
  inodesTotal: number;
  inodesUsed: number;
  inodesAvail: number;
  inodesUsePercent: number;
}

export function computeDiskUsage(world: World): ComputedDiskUsage[] {
  // Sort mounts by path length descending to match longest prefix first
  const sortedMounts = [...world.disks].sort((a, b) => b.mount.length - a.mount.length);
  const fileSums = new Map<string, number>();
  const fileCounts = new Map<string, number>();

  for (const d of world.disks) {
    fileSums.set(d.mount, 0);
    fileCounts.set(d.mount, 0);
  }

  for (const entry of world.fs) {
    const matched = sortedMounts.find((m) =>
      m.mount === '/' ? true : entry.path === m.mount || entry.path.startsWith(m.mount + '/')
    );
    if (matched) {
      if (entry.type === 'file') {
        fileSums.set(matched.mount, (fileSums.get(matched.mount) || 0) + getEntrySizeBytes(entry));
      }
      fileCounts.set(matched.mount, (fileCounts.get(matched.mount) || 0) + 1);
    }
  }

  return world.disks.map((d) => {
    const filesBytes = fileSums.get(d.mount) || 0;
    const usedBytes = Math.min(d.sizeBytes, Math.max(0, d.otherUsedBytes + filesBytes));
    const availBytes = Math.max(0, d.sizeBytes - usedBytes);
    const usePercent = d.sizeBytes > 0 ? Math.min(100, Math.ceil((usedBytes / d.sizeBytes) * 100)) : 0;

    const inodesTotal = d.inodesTotal ?? 3276800;
    const inodesUsed = d.inodesUsed ?? 124000 + (fileCounts.get(d.mount) || 0);
    const inodesAvail = Math.max(0, inodesTotal - inodesUsed);
    const inodesUsePercent = inodesTotal > 0 ? Math.min(100, Math.ceil((inodesUsed / inodesTotal) * 100)) : 1;

    return {
      ...d,
      usedBytes,
      availBytes,
      usePercent,
      inodesTotal,
      inodesUsed,
      inodesAvail,
      inodesUsePercent,
    };
  });
}

export function parseOctalMode(modeStr: string): number {
  const clean = modeStr.replace(/^0+/, '') || '0';
  const parsed = parseInt(clean.slice(-3), 8);
  return Number.isNaN(parsed) ? 0o644 : parsed;
}

export function formatOctalMode(modeNum: number): string {
  return '0' + (modeNum & 0o777).toString(8).padStart(3, '0');
}

export function formatSymbolicMode(entry: VfsEntry): string {
  const typeChar = entry.type === 'dir' ? 'd' : entry.type === 'symlink' ? 'l' : '-';
  const modeNum = parseOctalMode(entry.mode);
  const triplet = (bits: number) =>
    ((bits & 4) ? 'r' : '-') + ((bits & 2) ? 'w' : '-') + ((bits & 1) ? 'x' : '-');
  const u = (modeNum >> 6) & 7;
  const g = (modeNum >> 3) & 7;
  const o = modeNum & 7;
  return typeChar + triplet(u) + triplet(g) + triplet(o);
}

export function applyChmodMode(currentMode: string, spec: string): { mode: string; valid: boolean } {
  const trimmed = spec.trim();
  if (/^[0-7]{3,4}$/.test(trimmed)) {
    const val = parseInt(trimmed.slice(-3), 8);
    return { mode: formatOctalMode(val), valid: true };
  }

  let modeNum = parseOctalMode(currentMode);
  const clauses = trimmed.split(',');
  for (const clause of clauses) {
    const m = clause.match(/^([ugoa]*)([+-=])([rwx]+)$/);
    if (!m) {
      return { mode: currentMode, valid: false };
    }
    const who = m[1] || 'a';
    const op = m[2];
    const perms = m[3];

    let bitMask = 0;
    if (perms.includes('r')) bitMask |= 4;
    if (perms.includes('w')) bitMask |= 2;
    if (perms.includes('x')) bitMask |= 1;

    const applyToShift = (shift: number) => {
      const shiftedMask = bitMask << shift;
      const clearMask = ~(7 << shift);
      if (op === '+') modeNum |= shiftedMask;
      else if (op === '-') modeNum &= ~shiftedMask;
      else if (op === '=') modeNum = (modeNum & clearMask) | shiftedMask;
    };

    if (who.includes('u') || who.includes('a')) applyToShift(6);
    if (who.includes('g') || who.includes('a')) applyToShift(3);
    if (who.includes('o') || who.includes('a')) applyToShift(0);
  }

  return { mode: formatOctalMode(modeNum), valid: true };
}

export function hasPermission(
  entry: VfsEntry,
  user: string,
  perm: 'r' | 'w' | 'x',
  isSudo = false
): boolean {
  const modeNum = parseOctalMode(entry.mode);
  const bit = perm === 'r' ? 4 : perm === 'w' ? 2 : 1;

  if (isSudo || user === 'root') {
    if (perm === 'x' && entry.type === 'file') {
      // Even root needs at least one execute bit set to execute a file
      return (modeNum & 0o111) !== 0;
    }
    return true;
  }

  if (entry.owner === user) {
    return (((modeNum >> 6) & 7) & bit) !== 0;
  }
  if (entry.group === user) {
    return (((modeNum >> 3) & 7) & bit) !== 0;
  }
  return ((modeNum & 7) & bit) !== 0;
}

export function globToRegex(globPattern: string): RegExp {
  let regexStr = '^';
  for (let i = 0; i < globPattern.length; i++) {
    const c = globPattern[i];
    if (c === '*') {
      regexStr += '[^/]*';
    } else if (c === '?') {
      regexStr += '[^/]';
    } else if ('.+^${}()|[]\\'.includes(c)) {
      regexStr += '\\' + c;
    } else {
      regexStr += c;
    }
  }
  regexStr += '$';
  return new RegExp(regexStr);
}

export function expandGlobToken(world: World, token: string): string[] {
  if (!token.includes('*') && !token.includes('?')) {
    return [token];
  }

  const isAbs = token.startsWith('/');
  const absPattern = resolvePath(world.cwd, token, world.env.HOME);
  const patternParts = absPattern.split('/').filter(Boolean);

  let candidates = ['/'];
  for (const part of patternParts) {
    const nextCandidates: string[] = [];
    const rx = globToRegex(part);
    for (const base of candidates) {
      const children = listChildren(world, base);
      for (const child of children) {
        const name = basename(child.path);
        if (rx.test(name)) {
          nextCandidates.push(child.path);
        }
      }
    }
    candidates = nextCandidates;
    if (candidates.length === 0) break;
  }

  if (candidates.length === 0) {
    return [token];
  }

  const sorted = candidates.sort();
  if (isAbs) {
    return sorted;
  }

  // Convert back to relative path if input was relative to cwd
  const cwdPrefix = world.cwd === '/' ? '/' : world.cwd + '/';
  return sorted.map((abs) => (abs.startsWith(cwdPrefix) ? abs.slice(cwdPrefix.length) : abs));
}

export function formatHumanBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes}B`;
  const units = ['K', 'M', 'G', 'T'];
  let val = bytes;
  let uIdx = -1;
  while (val >= 1024 && uIdx < units.length - 1) {
    val /= 1024;
    uIdx++;
  }
  const rounded = val >= 10 ? Math.round(val).toString() : val.toFixed(1).replace(/\.0$/, '');
  return `${rounded}${units[uIdx]}`;
}
