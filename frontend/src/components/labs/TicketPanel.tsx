'use client';

import React from 'react';
import Link from 'next/link';
import { Lab } from '@/lib/labs/types';
import { GoalStatus } from '@/lib/labs/goals';

interface TicketPanelProps {
  lab: Lab;
  nextLabSlug?: string;
  goalStatuses: GoalStatus[];
  allCompleted: boolean;
  hintsRevealed: number;
  commandsCount: number;
  onRevealHint: () => void;
  onResetLab: () => void;
}

const SEVERITY_STYLES: Record<
  Lab['ticket']['severity'],
  { bg: string; border: string; color: string }
> = {
  P1: {
    bg: 'rgba(248, 81, 73, 0.14)',
    border: 'rgba(248, 81, 73, 0.4)',
    color: '#ff7b72',
  },
  P2: {
    bg: 'rgba(210, 153, 34, 0.14)',
    border: 'rgba(210, 153, 34, 0.4)',
    color: '#e3b341',
  },
  P3: {
    bg: 'rgba(56, 139, 253, 0.14)',
    border: 'rgba(56, 139, 253, 0.4)',
    color: '#79c0ff',
  },
  P4: {
    bg: 'rgba(139, 148, 158, 0.14)',
    border: 'rgba(139, 148, 158, 0.4)',
    color: '#8b949e',
  },
};

export default function TicketPanel({
  lab,
  nextLabSlug,
  goalStatuses,
  allCompleted,
  hintsRevealed,
  commandsCount,
  onRevealHint,
  onResetLab,
}: TicketPanelProps) {
  const sevStyle = SEVERITY_STYLES[lab.ticket.severity];
  const completedCount = goalStatuses.filter((g) => g.completed).length;

  return (
    <div className="flex flex-col h-full rounded-xl border border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text)] overflow-y-auto p-5 space-y-5">
      {/* Ticket Header */}
      <div className="space-y-2 pb-4 border-b border-[var(--color-border)]">
        <div className="flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <span
              className="px-2 py-0.5 text-xs font-mono font-bold rounded border"
              style={{
                background: sevStyle.bg,
                borderColor: sevStyle.border,
                color: sevStyle.color,
              }}
            >
              {lab.ticket.severity}
            </span>
            <span className="font-mono text-xs font-semibold text-[var(--color-accent)]">
              {lab.ticket.id}
            </span>
          </div>
          <span className="text-xs text-[var(--color-text-muted)]">
            ผู้แจ้ง: {lab.ticket.reporter}
          </span>
        </div>

        <h1 className="font-heading text-base font-bold text-[var(--color-text)] leading-snug">
          {lab.title}
        </h1>

        <p className="font-body text-sm font-medium text-[var(--color-text)] leading-relaxed">
          {lab.ticket.summary}
        </p>
        <p className="font-body text-xs text-[var(--color-text-muted)] leading-relaxed">
          {lab.ticket.detail}
        </p>
      </div>

      {/* Completion Banner & Debrief */}
      {allCompleted && (
        <div className="p-4 rounded-xl border border-emerald-500/40 bg-emerald-500/10 space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-sm font-bold text-emerald-400">
              ✓ แก้ไขเคสสำเร็จครบทุกเป้าหมาย!
            </span>
            <span className="text-xs font-mono text-[var(--color-text-muted)]">
              {commandsCount} คำสั่ง • คำใบ้ {hintsRevealed}/{lab.hints.length}
            </span>
          </div>

          <p className="font-body text-xs text-[var(--color-text)] leading-relaxed">
            {lab.debrief}
          </p>

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <button
              type="button"
              onClick={onResetLab}
              className="px-3 py-1.5 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text)] hover:text-[var(--color-accent)] hover:border-[var(--color-accent)]/50 text-xs font-medium transition-colors"
            >
              ลองทำซ้ำ
            </button>
            {nextLabSlug && (
              <Link
                href={`/labs/${nextLabSlug}`}
                className="px-3 py-1.5 rounded-lg text-xs font-semibold bg-[var(--color-accent)] text-slate-950 hover:bg-[var(--color-accent-hover)] transition-colors shadow-sm"
              >
                ไปแล็บถัดไป →
              </Link>
            )}
          </div>
        </div>
      )}

      {/* Goals Checklist */}
      <div className="space-y-2.5">
        <div className="flex items-center justify-between">
          <h2 className="font-heading text-xs font-bold uppercase tracking-wider text-[var(--color-text-muted)]">
            เป้าหมายการแก้ปัญหา (Goals)
          </h2>
          <span className="text-xs font-mono text-[var(--color-text-muted)]">
            {completedCount}/{goalStatuses.length}
          </span>
        </div>

        <ul className="space-y-2">
          {goalStatuses.map(({ goal, completed }) => (
            <li
              key={goal.id}
              className={`flex items-start gap-2.5 p-2.5 rounded-lg border text-xs transition-colors ${
                completed
                  ? 'bg-emerald-500/10 border-emerald-500/30'
                  : 'bg-[var(--color-surface-2)] border-[var(--color-border)]'
              }`}
            >
              <span
                className={`mt-0.5 font-mono font-bold select-none ${
                  completed ? 'text-emerald-400' : 'text-[var(--color-text-muted)]'
                }`}
                aria-hidden="true"
              >
                {completed ? '✓' : '○'}
              </span>
              <span
                className={`leading-relaxed ${
                  completed ? 'text-[var(--color-text)] font-medium' : 'text-[var(--color-text-muted)]'
                }`}
              >
                {goal.text}
              </span>
            </li>
          ))}
        </ul>
      </div>

      {/* Runbook Section */}
      <div className="space-y-2">
        <h2 className="font-heading text-xs font-bold uppercase tracking-wider text-[var(--color-text-muted)]">
          Runbook แนวทางตรวจสอบ
        </h2>
        <ol className="list-decimal list-inside space-y-1.5 text-xs p-3 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface-2)]/60 text-[var(--color-text-muted)] leading-relaxed font-body">
          {lab.runbook.map((step, i) => (
            <li key={i}>{step}</li>
          ))}
        </ol>
      </div>

      {/* Hints Section */}
      <div className="space-y-2.5 pt-1">
        <div className="flex items-center justify-between">
          <h2 className="font-heading text-xs font-bold uppercase tracking-wider text-[var(--color-text-muted)]">
            คำใบ้ (Hints)
          </h2>
          {hintsRevealed < lab.hints.length && (
            <button
              type="button"
              onClick={onRevealHint}
              className="px-2.5 py-1 rounded-md border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-accent)] hover:border-[var(--color-accent)]/50 text-xs font-medium transition-colors"
            >
              ขอคำใบ้ ({hintsRevealed}/{lab.hints.length})
            </button>
          )}
        </div>

        {hintsRevealed > 0 ? (
          <div className="space-y-2">
            {lab.hints.slice(0, hintsRevealed).map((hint, idx) => (
              <div
                key={idx}
                className="p-2.5 rounded-lg border border-amber-500/30 bg-amber-500/10 text-xs text-[var(--color-text)] leading-relaxed"
              >
                <span className="font-semibold text-amber-400">
                  คำใบ้ {idx + 1}:{' '}
                </span>
                {hint}
              </div>
            ))}
          </div>
        ) : (
          <p className="font-body text-xs text-[var(--color-text-muted)]">
            พยายามแก้ตาม Runbook ก่อน หากติดขัดสามารถกดปุ่มขอคำใบ้ทีละขั้นได้
          </p>
        )}
      </div>
    </div>
  );
}
