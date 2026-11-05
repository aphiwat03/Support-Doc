import { describe, it, expect } from 'vitest';
import { parseCommandLine } from '../parser';
import {
  resolvePath,
  createInitialWorld,
  computeDiskUsage,
  applyChmodMode,
  expandGlobToken,
  getNode,
} from '../vfs';
import { getAllLabs, getLabBySlug, validateLab } from '../loader';
import { evaluateLabGoals, evaluateGoalCheck } from '../goals';
import { execLine, completeInput } from '../engine';

describe('Phase 10 — Interactive Terminal Sandbox Engine', () => {
  describe('1. Shell Input Parser (parser.ts)', () => {
    it('tokenizes single/double quotes, escapes, pipes, redirects, and chaining', () => {
      const world = createInitialWorld(getLabBySlug('disk-full')!);
      const parsed = parseCommandLine(
        'grep "ERROR" /var/log/app/app.log | awk \'{print $4}\' > /tmp/out.txt && echo "done: $USER"',
        world.env,
        world.lastExitCode
      );
      expect(parsed.ok).toBe(true);
      if (parsed.ok) {
        expect(parsed.segments.length).toBe(2);
        expect(parsed.segments[0].connector).toBe('FIRST');
        expect(parsed.segments[0].commands.length).toBe(2);
        expect(parsed.segments[0].commands[0].argv).toEqual([
          'grep',
          'ERROR',
          '/var/log/app/app.log',
        ]);
        expect(parsed.segments[0].commands[1].argv).toEqual(['awk', '{print $4}']);
        expect(parsed.segments[0].commands[1].redirect).toEqual({
          target: '/tmp/out.txt',
          mode: 'write',
          mergeStderr: false,
        });
        expect(parsed.segments[1].connector).toBe('AND');
        expect(parsed.segments[1].commands[0].argv).toEqual(['echo', 'done: support']);
      }
    });

    it('supports standalone redirection (> /path/file) to truncate files', () => {
      const world = createInitialWorld(getLabBySlug('disk-full')!);
      const parsed = parseCommandLine('> /var/log/app/app.log', world.env, world.lastExitCode);
      expect(parsed.ok).toBe(true);
      if (parsed.ok) {
        expect(parsed.segments[0].commands[0].argv).toEqual([]);
        expect(parsed.segments[0].commands[0].redirect).toEqual({
          target: '/var/log/app/app.log',
          mode: 'write',
          mergeStderr: false,
        });
      }
    });

    it('rejects input longer than 500 characters', () => {
      const world = createInitialWorld(getLabBySlug('disk-full')!);
      const longCmd = 'echo ' + 'a'.repeat(505);
      const parsed = parseCommandLine(longCmd, world.env, world.lastExitCode);
      expect(parsed.ok).toBe(false);
      if (!parsed.ok) {
        expect(parsed.error).toContain('500');
      }
    });

    it('rejects unsupported constructs (loops, subshell, background &)', () => {
      const world = createInitialWorld(getLabBySlug('disk-full')!);
      const r1 = parseCommandLine('for i in 1 2 3; do echo $i; done', world.env, 0);
      const r2 = parseCommandLine('echo $(whoami)', world.env, 0);
      const r3 = parseCommandLine('sleep 10 &', world.env, 0);
      const r4 = parseCommandLine('cat << EOF', world.env, 0);

      expect(r1.ok).toBe(false);
      expect(r2.ok).toBe(false);
      expect(r3.ok).toBe(false);
      expect(r4.ok).toBe(false);
      if (!r1.ok) expect(r1.error).toContain('(sandbox)');
      if (!r2.ok) expect(r2.error).toContain('(sandbox)');
      if (!r3.ok) expect(r3.error).toContain('(sandbox)');
      if (!r4.ok) expect(r4.error).toContain('(sandbox)');
    });
  });

  describe('2. Virtual File System (vfs.ts)', () => {
    it('resolves relative paths, ., .., and ~ properly', () => {
      expect(resolvePath('/home/support', '.')).toBe('/home/support');
      expect(resolvePath('/home/support', '..')).toBe('/home');
      expect(resolvePath('/home/support', '../../var/log/app/../nginx')).toBe('/var/log/nginx');
      expect(resolvePath('/var/log', '~/notes.txt', '/home/support')).toBe('/home/support/notes.txt');
    });

    it('expands glob patterns (* and ?) in a directory', () => {
      const world = createInitialWorld(getLabBySlug('disk-full')!);
      const expanded = expandGlobToken(world, '/var/log/*');
      expect(expanded).toContain('/var/log/app');
      expect(expanded).toContain('/var/log/nginx');
      expect(expanded).toContain('/var/log/syslog');
    });

    it('applies numeric and symbolic chmod modes accurately', () => {
      expect(applyChmodMode('0644', '755')).toEqual({ mode: '0755', valid: true });
      expect(applyChmodMode('0644', '+x')).toEqual({ mode: '0755', valid: true });
      expect(applyChmodMode('0644', 'u+x')).toEqual({ mode: '0744', valid: true });
      expect(applyChmodMode('0777', 'go-w')).toEqual({ mode: '0755', valid: true });
    });

    it('protects against rm -rf / and rm -rf /*', () => {
      const lab = getLabBySlug('disk-full')!;
      const world = createInitialWorld(lab);
      const res = execLine(world, 'sudo rm -rf /', { lab });
      expect(res.exitCode).toBe(1);
      expect(res.stderr).toContain("dangerous to operate recursively on '/'");
      expect(getNode(res.world, '/etc')).toBeDefined();
    });
  });

  describe('3. Dynamic Disk Usage & Service Port Conflicts', () => {
    it('recalculates df -h dynamically when large files are truncated or deleted', () => {
      const lab = getLabBySlug('disk-full')!;
      let world = createInitialWorld(lab);

      const beforeMounts = computeDiskUsage(world);
      const rootBefore = beforeMounts.find((m) => m.mount === '/')!;
      expect(rootBefore.usePercent).toBeGreaterThanOrEqual(95);

      // Truncate /var/log/app/app.log
      world = execLine(world, '> /var/log/app/app.log', { lab }).world;

      const afterMounts = computeDiskUsage(world);
      const rootAfter = afterMounts.find((m) => m.mount === '/')!;
      expect(rootAfter.usePercent).toBeLessThan(80);
    });

    it('blocks starting nginx while apache2 holds port 80, and succeeds after stopping apache2', () => {
      const lab = getLabBySlug('service-port-conflict')!;
      let world = createInitialWorld(lab);

      const failStart = execLine(world, 'sudo systemctl start nginx', { lab });
      expect(failStart.exitCode).not.toBe(0);
      expect(failStart.stderr).toContain('Job for nginx.service failed');
      expect(failStart.world.services.find((s) => s.name === 'nginx')?.state).toBe('failed');

      const journalRes = execLine(failStart.world, 'journalctl -u nginx -n 20', { lab });
      expect(journalRes.stdout).toContain('Address already in use');

      world = execLine(journalRes.world, 'sudo systemctl stop apache2', { lab }).world;
      expect(world.services.find((s) => s.name === 'apache2')?.state).toBe('inactive');

      const okStart = execLine(world, 'sudo systemctl start nginx', { lab });
      expect(okStart.exitCode).toBe(0);
      expect(okStart.world.services.find((s) => s.name === 'nginx')?.state).toBe('active');
    });
  });

  describe('4. Lab Schema Validation & Goal Evaluators', () => {
    it('loads all 5 labs with valid schema', () => {
      const labs = getAllLabs();
      expect(labs.length).toBe(5);
      for (const lab of labs) {
        expect(() => validateLab(lab, lab.slug)).not.toThrow();
      }
    });

    it('throws descriptive error when validating malformed lab JSON', () => {
      expect(() => validateLab({ id: 'broken' }, 'broken.json')).toThrow(/Lab Schema Error/);
    });

    it('prevents chmod 777 from passing permission-denied lab goal', () => {
      const lab = getLabBySlug('permission-denied')!;
      let world = createInitialWorld(lab);
      world = execLine(world, 'chmod 777 /home/support/deploy.sh', { lab }).world;
      expect(world.insecureChmod777Used).toBe(true);

      const goal2 = lab.goals.find((g) => g.id === 'g2')!;
      expect(evaluateGoalCheck(world, goal2.check)).toBe(false);

      // Fixing to 755 clears insecureChmod777Used and passes the goal
      world = execLine(world, 'chmod 755 /home/support/deploy.sh', { lab }).world;
      expect(world.insecureChmod777Used).toBe(false);
      expect(evaluateGoalCheck(world, goal2.check)).toBe(true);
    });
  });

  describe('5. Tab Completion (completeInput)', () => {
    it('autocompletes command names and file paths', () => {
      const lab = getLabBySlug('disk-full')!;
      const world = createInitialWorld(lab);

      const cmdComplete = completeInput(world, 'sys');
      expect(cmdComplete.completed).toBe('systemctl ');

      const pathComplete = completeInput(world, 'cat /var/log/app/app.l');
      expect(pathComplete.suggestions.length).toBeGreaterThanOrEqual(1);
    });
  });

  describe('6. End-to-End Solution Walkthrough for All 5 Labs', () => {
    it('Lab 1: disk-full completes 100% of goals along solution path', () => {
      const lab = getLabBySlug('disk-full')!;
      let world = createInitialWorld(lab);

      world = execLine(world, 'df -h', { lab }).world;
      world = execLine(world, 'du -sh /var/log/*', { lab }).world;
      world = execLine(world, '> /var/log/app/app.log', { lab }).world;
      world = execLine(world, 'df -h', { lab }).world;

      const evalResult = evaluateLabGoals(world, lab);
      expect(evalResult.statuses.map((s) => s.completed)).toEqual([true, true, true, true]);
      expect(evalResult.allCompleted).toBe(true);
    });

    it('Lab 2: service-port-conflict completes 100% of goals along solution path', () => {
      const lab = getLabBySlug('service-port-conflict')!;
      let world = createInitialWorld(lab);

      world = execLine(world, 'systemctl status nginx', { lab }).world;
      world = execLine(world, 'journalctl -u nginx -n 20', { lab }).world;
      world = execLine(world, 'ss -tulnp', { lab }).world;
      world = execLine(world, 'sudo systemctl stop apache2', { lab }).world;
      world = execLine(world, 'sudo systemctl start nginx', { lab }).world;
      world = execLine(world, 'curl -I http://localhost', { lab }).world;

      const evalResult = evaluateLabGoals(world, lab);
      expect(evalResult.statuses.map((s) => s.completed)).toEqual([true, true, true, true]);
      expect(evalResult.allCompleted).toBe(true);
    });

    it('Lab 3: permission-denied completes 100% of goals along solution path', () => {
      const lab = getLabBySlug('permission-denied')!;
      let world = createInitialWorld(lab);

      world = execLine(world, 'ls -l deploy.sh', { lab }).world;
      world = execLine(world, 'chmod u+x deploy.sh', { lab }).world;
      const runRes = execLine(world, './deploy.sh', { lab });
      world = runRes.world;
      expect(runRes.exitCode).toBe(0);

      const evalResult = evaluateLabGoals(world, lab);
      expect(evalResult.statuses.map((s) => s.completed)).toEqual([true, true, true]);
      expect(evalResult.allCompleted).toBe(true);
    });

    it('Lab 4: dns-failure completes 100% of goals along solution path', () => {
      const lab = getLabBySlug('dns-failure')!;
      let world = createInitialWorld(lab);

      world = execLine(world, 'ping -c 2 8.8.8.8', { lab }).world;
      world = execLine(world, 'cat /etc/resolv.conf', { lab }).world;
      world = execLine(world, 'dig @8.8.8.8 example.com +short', { lab }).world;
      const escRes = execLine(
        world,
        'escalate "DNS in /etc/resolv.conf points to unreachable nameserver 10.99.99.254"',
        { lab }
      );
      world = escRes.world;
      expect(escRes.exitCode).toBe(0);

      const evalResult = evaluateLabGoals(world, lab);
      expect(evalResult.statuses.map((s) => s.completed)).toEqual([true, true, true, true]);
      expect(evalResult.allCompleted).toBe(true);
    });

    it('Lab 5: log-hunt completes 100% of goals along solution path', () => {
      const lab = getLabBySlug('log-hunt')!;
      let world = createInitialWorld(lab);

      world = execLine(world, "grep ' 500 ' access.log | wc -l", { lab }).world;
      world = execLine(
        world,
        "awk '{print $1}' access.log | sort | uniq -c | sort -nr | head",
        { lab }
      ).world;

      const evalResult = evaluateLabGoals(world, lab);
      expect(evalResult.statuses.map((s) => s.completed)).toEqual([true, true, true]);
      expect(evalResult.allCompleted).toBe(true);
    });
  });
});
