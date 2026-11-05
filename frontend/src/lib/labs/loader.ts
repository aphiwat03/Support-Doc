import { Lab } from './types';
import diskFullRaw from '@/content/labs/disk-full.json';
import servicePortConflictRaw from '@/content/labs/service-port-conflict.json';
import permissionDeniedRaw from '@/content/labs/permission-denied.json';
import dnsFailureRaw from '@/content/labs/dns-failure.json';
import logHuntRaw from '@/content/labs/log-hunt.json';

const VALID_TOPICS = new Set([
  'linux',
  'network',
  'sql',
  'web-api',
  'docker',
  'troubleshooting',
]);

const VALID_DIFFICULTIES = new Set(['beginner', 'intermediate', 'advanced']);
const VALID_SEVERITIES = new Set(['P1', 'P2', 'P3', 'P4']);
const VALID_CHECK_TYPES = new Set([
  'commandMatched',
  'stateEquals',
  'fileSizeBelow',
  'fileExists',
  'fileMissing',
  'outputContains',
  'escalationValid',
]);

export function validateLab(raw: unknown, sourceName = 'unknown.json'): Lab {
  const fail = (field: string, reason: string): never => {
    throw new Error(`[Lab Schema Error in ${sourceName}] Field "${field}": ${reason}`);
  };

  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) {
    fail('root', 'Expected a JSON object');
  }

  const obj = raw as Record<string, unknown>;

  if (typeof obj.slug !== 'string' || !/^[a-z0-9-]+$/.test(obj.slug)) {
    fail('slug', 'Must be a non-empty kebab-case string');
  }
  if (typeof obj.title !== 'string' || !obj.title.trim()) {
    fail('title', 'Must be a non-empty string');
  }
  if (typeof obj.topic !== 'string' || !VALID_TOPICS.has(obj.topic)) {
    fail('topic', `Must be one of ${Array.from(VALID_TOPICS).join(', ')}`);
  }
  if (typeof obj.difficulty !== 'string' || !VALID_DIFFICULTIES.has(obj.difficulty)) {
    fail('difficulty', `Must be one of ${Array.from(VALID_DIFFICULTIES).join(', ')}`);
  }
  if (typeof obj.estimatedMinutes !== 'number' || obj.estimatedMinutes <= 0) {
    fail('estimatedMinutes', 'Must be a positive number');
  }
  if (!Array.isArray(obj.relatedLessons) || !obj.relatedLessons.every((s) => typeof s === 'string')) {
    fail('relatedLessons', 'Must be an array of lesson slug strings');
  }

  // Ticket
  if (!obj.ticket || typeof obj.ticket !== 'object') {
    fail('ticket', 'Must be an object');
  }
  const ticket = obj.ticket as Record<string, unknown>;
  if (typeof ticket.id !== 'string' || !ticket.id.trim()) fail('ticket.id', 'Must be a non-empty string');
  if (typeof ticket.severity !== 'string' || !VALID_SEVERITIES.has(ticket.severity)) {
    fail('ticket.severity', 'Must be P1, P2, P3, or P4');
  }
  if (typeof ticket.reporter !== 'string' || !ticket.reporter.trim()) {
    fail('ticket.reporter', 'Must be a non-empty string');
  }
  if (typeof ticket.summary !== 'string' || !ticket.summary.trim()) {
    fail('ticket.summary', 'Must be a non-empty string');
  }
  if (typeof ticket.detail !== 'string') {
    fail('ticket.detail', 'Must be a string');
  }

  if (!Array.isArray(obj.runbook) || obj.runbook.length === 0 || !obj.runbook.every((r) => typeof r === 'string')) {
    fail('runbook', 'Must be a non-empty array of strings');
  }

  // Host
  if (!obj.host || typeof obj.host !== 'object') {
    fail('host', 'Must be an object');
  }
  const host = obj.host as Record<string, unknown>;
  if (typeof host.hostname !== 'string' || !host.hostname.trim()) fail('host.hostname', 'Required string');
  if (typeof host.user !== 'string' || !host.user.trim()) fail('host.user', 'Required string');
  if (typeof host.cwd !== 'string' || !host.cwd.startsWith('/')) fail('host.cwd', 'Must be an absolute path');

  // World
  if (!obj.world || typeof obj.world !== 'object') {
    fail('world', 'Must be an object');
  }
  const world = obj.world as Record<string, unknown>;
  if (!Array.isArray(world.fs)) fail('world.fs', 'Must be an array');
  (world.fs as unknown[]).forEach((entry: unknown, idx: number) => {
    if (!entry || typeof entry !== 'object') fail(`world.fs[${idx}]`, 'Must be an object');
    const e = entry as Record<string, unknown>;
    if (typeof e.path !== 'string' || !e.path.startsWith('/')) {
      fail(`world.fs[${idx}].path`, 'Must be an absolute path');
    }
    if (e.type !== 'file' && e.type !== 'dir' && e.type !== 'symlink') {
      fail(`world.fs[${idx}].type`, 'Must be file, dir, or symlink');
    }
    if (typeof e.mode !== 'string') fail(`world.fs[${idx}].mode`, 'Must be a mode string');
    if (typeof e.owner !== 'string') fail(`world.fs[${idx}].owner`, 'Must be a string');
    if (typeof e.group !== 'string') fail(`world.fs[${idx}].group`, 'Must be a string');
    if (typeof e.mtime !== 'string') fail(`world.fs[${idx}].mtime`, 'Must be an ISO timestamp string');
  });

  if (!Array.isArray(world.disks) || world.disks.length === 0) {
    fail('world.disks', 'Must be a non-empty array');
  }

  // Goals
  if (!Array.isArray(obj.goals) || obj.goals.length === 0) {
    fail('goals', 'Must be a non-empty array');
  }
  (obj.goals as unknown[]).forEach((goal: unknown, idx: number) => {
    if (!goal || typeof goal !== 'object') fail(`goals[${idx}]`, 'Must be an object');
    const g = goal as Record<string, unknown>;
    if (typeof g.id !== 'string' || !g.id.trim()) fail(`goals[${idx}].id`, 'Must be a non-empty string');
    if (typeof g.text !== 'string' || !g.text.trim()) fail(`goals[${idx}].text`, 'Must be a non-empty string');
    if (!g.check || typeof g.check !== 'object') fail(`goals[${idx}].check`, 'Must be an object');
    const chk = g.check as Record<string, unknown>;
    if (typeof chk.type !== 'string' || !VALID_CHECK_TYPES.has(chk.type)) {
      fail(`goals[${idx}].check.type`, `Invalid goal check type "${String(chk.type)}"`);
    }
  });

  if (!Array.isArray(obj.hints) || !obj.hints.every((h) => typeof h === 'string')) {
    fail('hints', 'Must be an array of strings');
  }
  if (typeof obj.debrief !== 'string' || !obj.debrief.trim()) {
    fail('debrief', 'Must be a non-empty string');
  }

  return obj as unknown as Lab;
}

const ALL_LABS: Lab[] = [
  validateLab(diskFullRaw, 'disk-full.json'),
  validateLab(servicePortConflictRaw, 'service-port-conflict.json'),
  validateLab(permissionDeniedRaw, 'permission-denied.json'),
  validateLab(dnsFailureRaw, 'dns-failure.json'),
  validateLab(logHuntRaw, 'log-hunt.json'),
];

export function getAllLabs(): Lab[] {
  return ALL_LABS;
}

export function getLabBySlug(slug: string): Lab | undefined {
  return ALL_LABS.find((l) => l.slug === slug);
}

export function getLabsForLesson(lessonSlug: string): Lab[] {
  return ALL_LABS.filter((l) => l.relatedLessons.includes(lessonSlug));
}
