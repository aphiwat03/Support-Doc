'use client';

import React, { useEffect, useState } from 'react';
import { getAllLabs } from '@/lib/labs/loader';
import { LabTopic } from '@/lib/labs/types';
import { useLabStore } from '@/stores/useLabStore';
import LabRow from '@/components/labs/LabRow';

const FILTER_TABS: Array<{ id: 'all' | LabTopic; label: string }> = [
  { id: 'all', label: 'ทั้งหมด' },
  { id: 'linux', label: 'Linux' },
  { id: 'network', label: 'Network' },
];

export default function LabsListPage() {
  const allLabs = getAllLabs();
  const { progress, hydrate } = useLabStore();
  const [selectedTopic, setSelectedTopic] = useState<'all' | LabTopic>('all');

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  const filteredLabs =
    selectedTopic === 'all'
      ? allLabs
      : allLabs.filter((l) => l.topic === selectedTopic);

  const completedCount = allLabs.filter((l) => progress[l.slug]?.completed).length;

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-8 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 pb-6 border-b border-[var(--color-border)]">
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 text-xs font-mono font-semibold rounded-md border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-accent)]">
              Interactive Terminal Sandbox
            </span>
          </div>
          <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
            แล็บจำลองสถานการณ์ (Support Labs)
          </h1>
          <p className="font-body text-sm text-[var(--color-text-muted)] leading-relaxed">
            ฝึกวิเคราะห์และแก้ปัญหาจากใบแจ้งเหตุ (Incident Ticket) บนเทอร์มินัลจำลองที่ปลอดภัย 100%
          </p>
        </div>

        <div className="px-4 py-2.5 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface)] text-right shrink-0">
          <div className="text-xs text-[var(--color-text-muted)]">
            ความคืบหน้าแล็บ
          </div>
          <div className="text-lg font-bold font-mono text-[var(--color-text)]">
            {completedCount} / {allLabs.length}{' '}
            <span className="text-xs font-normal text-[var(--color-text-muted)]">
              เคส
            </span>
          </div>
        </div>
      </div>

      {/* Topic Filter */}
      <div className="flex flex-wrap items-center gap-2">
        {FILTER_TABS.map((tab) => {
          const active = selectedTopic === tab.id;
          return (
            <button
              key={tab.id}
              type="button"
              onClick={() => setSelectedTopic(tab.id)}
              className={`px-3.5 py-1.5 rounded-lg text-xs font-semibold border transition-all ${
                active
                  ? 'bg-[var(--color-accent)] text-slate-950 border-[var(--color-accent)] shadow-sm shadow-cyan-500/20'
                  : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface-2)] border-[var(--color-border)]'
              }`}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Labs List */}
      <div className="space-y-3">
        {filteredLabs.map((lab) => (
          <LabRow
            key={lab.slug}
            lab={lab}
            progress={progress[lab.slug]}
          />
        ))}
      </div>
    </div>
  );
}
