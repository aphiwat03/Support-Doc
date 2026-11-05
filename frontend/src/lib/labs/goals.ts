import { GoalCheck, Lab, LabGoal, World } from './types';
import { computeDiskUsage, getEntrySizeBytes, getNode, parseOctalMode } from './vfs';

export function evaluateGoalCheck(world: World, check: GoalCheck): boolean {
  switch (check.type) {
    case 'commandMatched': {
      const rx = new RegExp(check.pattern);
      return world.history.some((h) => rx.test(h.command.trim()));
    }

    case 'fileExists': {
      return !!getNode(world, check.path);
    }

    case 'fileMissing': {
      return !getNode(world, check.path);
    }

    case 'fileSizeBelow': {
      const node = getNode(world, check.path);
      if (!node || node.type !== 'file') return false;
      return getEntrySizeBytes(node) < check.bytes;
    }

    case 'outputContains': {
      const sub = check.substring;
      return world.history.some((h) => {
        if (check.pattern && !new RegExp(check.pattern).test(h.command.trim())) {
          return false;
        }
        return h.stdout.includes(sub) || h.stderr.includes(sub);
      });
    }

    case 'escalationValid': {
      if (world.escalations.length === 0) return false;
      return world.escalations.some((note) => {
        const lower = note.toLowerCase();
        return check.mustMention.every((group) =>
          group.some((keyword) => lower.includes(keyword.toLowerCase()))
        );
      });
    }

    case 'stateEquals': {
      const p = check.path;

      // disks[idx].usePercentBelow
      const diskMatch = p.match(/^disks\[(\d+)\]\.usePercentBelow$/);
      if (diskMatch) {
        const idx = parseInt(diskMatch[1], 10);
        const usages = computeDiskUsage(world);
        if (!usages[idx]) return false;
        return usages[idx].usePercent < Number(check.value);
      }

      // services.<name>.state
      const svcMatch = p.match(/^services\.([a-zA-Z0-9_-]+)\.state$/);
      if (svcMatch) {
        const svcName = svcMatch[1];
        const svc = world.services.find((s) => s.name === svcName);
        return svc?.state === check.value;
      }

      // fs[<path>].safeExecutable
      const safeExecMatch = p.match(/^fs\[([^\]]+)\]\.safeExecutable$/);
      if (safeExecMatch) {
        const filePath = safeExecMatch[1];
        const node = getNode(world, filePath);
        if (!node || node.type !== 'file') return false;
        const modeNum = parseOctalMode(node.mode);
        const isExec = (modeNum & 0o100) !== 0;
        const isNotWorldWritable = (modeNum & 0o002) === 0 && modeNum !== 0o777;
        const isSafe = isExec && isNotWorldWritable && !world.insecureChmod777Used;
        return isSafe === Boolean(check.value);
      }

      // fs[<path>].mode
      const modeMatch = p.match(/^fs\[([^\]]+)\]\.mode$/);
      if (modeMatch) {
        const filePath = modeMatch[1];
        const node = getNode(world, filePath);
        return node?.mode === String(check.value);
      }

      return false;
    }

    default:
      return false;
  }
}

export interface GoalStatus {
  goal: LabGoal;
  completed: boolean;
}

export function evaluateLabGoals(world: World, lab: Lab): {
  statuses: GoalStatus[];
  allCompleted: boolean;
} {
  const statuses = lab.goals.map((goal) => ({
    goal,
    completed: evaluateGoalCheck(world, goal.check),
  }));
  return {
    statuses,
    allCompleted: statuses.length > 0 && statuses.every((s) => s.completed),
  };
}
