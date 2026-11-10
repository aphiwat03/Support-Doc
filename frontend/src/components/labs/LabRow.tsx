'use client';

import React from 'react';
import Link from 'next/link';
import { Lab } from '@/lib/labs/types';
import { LabProgressRecord } from '@/stores/useLabStore';

interface LabRowProps {
  lab: Lab;
  progress?: LabProgressRecord;
}

const TOPIC_LABELS: Record<Lab['topic'], string> = {
  linux: 'Linux',
  network: 'Network',
  sql: 'SQL',
  'web-api': 'Web & API',
  docker: 'Docker',
  troubleshooting: 'Troubleshooting',
  datacenter: 'Data Center',
};

const DIFFICULTY_LABELS: Record<Lab['difficulty'], string> = {
  beginner: 'เริ่มต้น',
  intermediate: 'ปานกลาง',
  advanced: 'ขั้นสูง',
};

export default function LabRow({ lab, progress }: LabRowProps) {
  const isCompleted = !!progress?.completed;

  return (
    <Link
      href={`/labs/${lab.slug}`}
      className={`flex flex-col sm:flex-row sm:items-center justify-between gap-3 py-4 px-4 rounded-xl border transition-all ${
        isCompleted
          ? 'bg-[var(--color-surface)] border-emerald-500/30 hover:border-emerald-500/50'
          : 'bg-[var(--color-surface)] border-[var(--color-border)] hover:border-[var(--color-accent)]/50 hover:bg-[var(--color-surface)]/80'
      }`}
    >
      <div className="space-y-1.5 min-w-0">
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-xs font-mono font-bold px-2 py-0.5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text-muted)]">
            {lab.ticket.id}
          </span>
          <span className="text-xs font-medium px-2 py-0.5 rounded-md bg-[var(--color-surface-2)] text-[var(--color-accent)] border border-[var(--color-border)]">
            {TOPIC_LABELS[lab.topic]}
          </span>
          <span className="text-xs text-[var(--color-text-muted)]">
            • {DIFFICULTY_LABELS[lab.difficulty]} • ~{lab.estimatedMinutes} นาที
          </span>
        </div>

        <h2 className="font-heading text-base font-semibold text-[var(--color-text)] truncate">
          {lab.title}
        </h2>

        <p className="font-body text-xs text-[var(--color-text-muted)] line-clamp-2 leading-relaxed">
          {lab.ticket.summary}
        </p>
      </div>

      <div className="flex items-center gap-3 shrink-0 self-start sm:self-center">
        {isCompleted ? (
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-1 rounded-full text-xs font-semibold border bg-emerald-500/10 border-emerald-500/30 text-emerald-400">
              ✓ ผ่านแล้ว ({progress.commandsUsed} คำสั่ง)
            </span>
          </div>
        ) : (
          <span className="px-3 py-1.5 rounded-lg text-xs font-semibold border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text)] transition-colors group-hover:text-[var(--color-accent)] group-hover:border-[var(--color-accent)]">
            เข้าทำแล็บ →
          </span>
        )}
      </div>
    </Link>
  );
}
