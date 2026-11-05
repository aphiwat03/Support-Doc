export type LabTopic =
  | 'linux'
  | 'network'
  | 'sql'
  | 'web-api'
  | 'docker'
  | 'troubleshooting';

export type LabDifficulty = 'beginner' | 'intermediate' | 'advanced';

export interface LabTicket {
  id: string;
  severity: 'P1' | 'P2' | 'P3' | 'P4';
  reporter: string;
  summary: string;
  detail: string;
}

export interface LabHost {
  hostname: string;
  user: string;
  cwd: string;
}

export interface VfsEntry {
  path: string;
  type: 'file' | 'dir' | 'symlink';
  content?: string;
  previewLines?: string[];
  sizeBytes?: number;
  mode: string; // e.g. "0644" or "0755"
  owner: string;
  group: string;
  mtime: string; // ISO string
  target?: string; // symlink target
}

export interface DiskMount {
  device: string;
  mount: string;
  sizeBytes: number;
  otherUsedBytes: number;
  inodesTotal?: number;
  inodesUsed?: number;
}

export interface MemoryInfo {
  totalMB: number;
  usedMB: number;
  freeMB: number;
  buffCacheMB: number;
  swapTotalMB?: number;
  swapUsedMB?: number;
}

export interface ProcessInfo {
  pid: number;
  user: string;
  cpu: number;
  mem: number;
  vsz?: number;
  rss?: number;
  stat?: string;
  start?: string;
  time?: string;
  command: string;
  service?: string;
}

export interface ServiceJournal {
  active?: string[];
  failed?: string[];
  inactive?: string[];
}

export interface ServiceInfo {
  name: string;
  description?: string;
  state: 'active' | 'inactive' | 'failed';
  enabled?: boolean;
  pid?: number;
  ports?: number[];
  dependsOnFreePorts?: number[];
  journal?: ServiceJournal;
}

export interface ListeningSocket {
  proto: 'tcp' | 'udp';
  localAddr: string;
  port: number;
  pid: number;
  process: string;
  service?: string;
}

export interface NetworkInterface {
  name: string;
  state: 'UP' | 'DOWN' | 'UNKNOWN';
  addr: string;
}

export interface NetworkInfo {
  interfaces?: NetworkInterface[];
  routes?: string[];
  listening?: ListeningSocket[];
  uptime?: string;
  uname?: string;
  nproc?: number;
  dmesg?: string[];
  lsof?: string[];
  crontab?: string[];
}

export interface WorldConfig {
  fs: VfsEntry[];
  disks: DiskMount[];
  memory: MemoryInfo;
  processes: ProcessInfo[];
  services: ServiceInfo[];
  network: NetworkInfo;
}

export interface ScriptedEffect {
  type: 'setServiceState' | 'writeFile';
  service?: string;
  state?: 'active' | 'inactive' | 'failed';
  path?: string;
  content?: string;
}

export interface ScriptedRule {
  match: string;
  stdout: string;
  stderr?: string;
  exitCode: number;
  effects?: ScriptedEffect[];
}

export type GoalCheck =
  | {
      type: 'commandMatched';
      pattern: string;
    }
  | {
      type: 'stateEquals';
      path: string;
      value: string | number | boolean;
    }
  | {
      type: 'fileSizeBelow';
      path: string;
      bytes: number;
    }
  | {
      type: 'fileExists';
      path: string;
    }
  | {
      type: 'fileMissing';
      path: string;
    }
  | {
      type: 'outputContains';
      pattern?: string;
      substring: string;
    }
  | {
      type: 'escalationValid';
      mustMention: string[][];
    };

export interface LabGoal {
  id: string;
  text: string;
  check: GoalCheck;
}

export interface Lab {
  slug: string;
  title: string;
  topic: LabTopic;
  difficulty: LabDifficulty;
  estimatedMinutes: number;
  relatedLessons: string[];
  ticket: LabTicket;
  runbook: string[];
  host: LabHost;
  world: WorldConfig;
  scripted?: ScriptedRule[];
  goals: LabGoal[];
  hints: string[];
  debrief: string;
}

export interface HistoryRecord {
  command: string;
  stdout: string;
  stderr: string;
  exitCode: number;
}

export interface World extends WorldConfig {
  user: string;
  hostname: string;
  cwd: string;
  env: Record<string, string>;
  lastExitCode: number;
  history: HistoryRecord[];
  escalations: string[];
  insecureChmod777Used?: boolean;
}

export interface ExecResult {
  world: World;
  stdout: string;
  stderr: string;
  exitCode: number;
  clear?: boolean;
}
