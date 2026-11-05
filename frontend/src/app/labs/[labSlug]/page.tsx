'use client';

import React, { useEffect, useState, useMemo } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { getAllLabs, getLabBySlug } from '@/lib/labs/loader';
import { createInitialWorld } from '@/lib/labs/vfs';
import { execLine } from '@/lib/labs/engine';
import { evaluateLabGoals } from '@/lib/labs/goals';
import { Lab, World } from '@/lib/labs/types';
import { useLabStore } from '@/stores/useLabStore';
import TicketPanel from '@/components/labs/TicketPanel';
import Terminal, { TerminalLogItem } from '@/components/labs/Terminal';

function LabWorkspace({ lab, nextLabSlug }: { lab: Lab; nextLabSlug?: string }) {
  const { recordCompletion, recordHintUsed } = useLabStore();

  const [world, setWorld] = useState<World>(() => createInitialWorld(lab));
  const [logs, setLogs] = useState<TerminalLogItem[]>([]);
  const [hintsRevealed, setHintsRevealed] = useState(0);
  const [mobileTab, setMobileTab] = useState<'ticket' | 'terminal'>('terminal');

  const goalEvaluation = useMemo(() => {
    return evaluateLabGoals(world, lab);
  }, [lab, world]);

  useEffect(() => {
    if (goalEvaluation.allCompleted) {
      recordCompletion(lab.slug, world.history.length, hintsRevealed);
    }
  }, [lab.slug, world.history.length, goalEvaluation.allCompleted, hintsRevealed, recordCompletion]);

  const handleExecute = (rawCmd: string) => {
    const displayCwd =
      world.cwd === world.env.HOME
        ? '~'
        : world.cwd.startsWith(world.env.HOME + '/')
        ? '~' + world.cwd.slice(world.env.HOME.length)
        : world.cwd;
    const promptBefore = `${world.user}@${world.hostname}:${displayCwd}$`;

    const res = execLine(world, rawCmd, { lab });
    setWorld(res.world);

    if (res.clear) {
      setLogs([]);
      return;
    }

    const newItem: TerminalLogItem = {
      id: `${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
      prompt: promptBefore,
      command: rawCmd,
      stdout: res.stdout,
      stderr: res.stderr,
      exitCode: res.exitCode,
    };

    setLogs((prev) => [...prev.slice(-199), newItem]);
  };

  const handleClear = () => {
    setLogs([]);
  };

  const handleReset = () => {
    setWorld(createInitialWorld(lab));
    setLogs([]);
    setHintsRevealed(0);
  };

  const handleRevealHint = () => {
    if (hintsRevealed < lab.hints.length) {
      const nextCount = hintsRevealed + 1;
      setHintsRevealed(nextCount);
      recordHintUsed(lab.slug, nextCount);
    }
  };

  const completedGoalsCount = goalEvaluation.statuses.filter((g) => g.completed).length;

  return (
    <div className="max-w-[1440px] mx-auto px-4 sm:px-6 py-4 flex flex-col h-[calc(100vh-4rem)]">
      {/* Top Breadcrumb + Mobile Tab Switcher */}
      <div className="flex flex-wrap items-center justify-between gap-2 pb-3 shrink-0">
        <div className="flex items-center gap-2 text-xs">
          <Link
            href="/labs"
            className="text-[var(--color-text-muted)] hover:text-[var(--color-accent)] font-medium transition-colors"
          >
            ← แล็บทั้งหมด
          </Link>
          <span className="text-[var(--color-border)]">/</span>
          <span className="font-mono font-semibold text-[var(--color-accent)]">
            {lab.ticket.id}
          </span>
          <span className="font-heading font-semibold truncate max-w-[240px] sm:max-w-md text-[var(--color-text)]">
            {lab.title}
          </span>
        </div>

        {/* Mobile Tab Switcher (< 1024px) */}
        <div className="flex lg:hidden items-center gap-1 p-1 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface-2)]">
          <button
            type="button"
            onClick={() => setMobileTab('ticket')}
            className={`px-3 py-1 rounded text-xs font-semibold transition-colors ${
              mobileTab === 'ticket'
                ? 'bg-[var(--color-accent)] text-slate-950 shadow-sm'
                : 'text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
            }`}
          >
            โจทย์ ({completedGoalsCount}/{lab.goals.length})
          </button>
          <button
            type="button"
            onClick={() => setMobileTab('terminal')}
            className={`px-3 py-1 rounded text-xs font-semibold transition-colors ${
              mobileTab === 'terminal'
                ? 'bg-[var(--color-accent)] text-slate-950 shadow-sm'
                : 'text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
            }`}
          >
            เทอร์มินัล
          </button>
        </div>
      </div>

      {/* Main Split Workspace */}
      <div className="flex-1 min-h-0 flex flex-col lg:flex-row gap-4">
        <div
          className={`lg:w-96 lg:shrink-0 h-full min-h-0 ${
            mobileTab === 'ticket' ? 'block' : 'hidden lg:block'
          }`}
        >
          <TicketPanel
            lab={lab}
            nextLabSlug={nextLabSlug}
            goalStatuses={goalEvaluation.statuses}
            allCompleted={goalEvaluation.allCompleted}
            hintsRevealed={hintsRevealed}
            commandsCount={world.history.length}
            onRevealHint={handleRevealHint}
            onResetLab={handleReset}
          />
        </div>

        <div
          className={`flex-1 h-full min-h-0 ${
            mobileTab === 'terminal' ? 'block' : 'hidden lg:block'
          }`}
        >
          <Terminal
            lab={lab}
            world={world}
            logs={logs}
            onExecute={handleExecute}
            onClear={handleClear}
            onReset={handleReset}
          />
        </div>
      </div>
    </div>
  );
}

export default function LabDetailPage() {
  const params = useParams();
  const labSlug = typeof params?.labSlug === 'string' ? params.labSlug : '';
  const lab = getLabBySlug(labSlug);
  const allLabs = getAllLabs();
  const { hydrate } = useLabStore();

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  const nextLabSlug = useMemo(() => {
    if (!lab) return undefined;
    const idx = allLabs.findIndex((l) => l.slug === lab.slug);
    if (idx === -1 || idx + 1 >= allLabs.length) return undefined;
    return allLabs[idx + 1].slug;
  }, [lab, allLabs]);

  if (!lab) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-16 text-center space-y-4">
        <h1 className="font-heading text-xl font-bold text-[var(--color-text)]">
          ไม่พบแล็บที่คุณต้องการ
        </h1>
        <p className="font-body text-sm text-[var(--color-text-muted)]">
          รหัสแล็บ <code className="font-mono text-[var(--color-accent)] bg-[var(--color-surface-2)] px-1.5 py-0.5 rounded border border-[var(--color-border)]">{labSlug}</code> ไม่มีอยู่ในระบบ
        </p>
        <div>
          <Link
            href="/labs"
            className="inline-block px-4 py-2 rounded-lg text-sm font-semibold bg-[var(--color-accent)] text-slate-950 hover:bg-[var(--color-accent-hover)] transition-colors"
          >
            ← กลับไปหน้ารวมแล็บ
          </Link>
        </div>
      </div>
    );
  }

  return <LabWorkspace key={lab.slug} lab={lab} nextLabSlug={nextLabSlug} />;
}
