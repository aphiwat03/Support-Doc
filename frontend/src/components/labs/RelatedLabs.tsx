'use client';

import React, { useEffect } from 'react';
import Link from 'next/link';
import { getLabsForLesson } from '@/lib/labs/loader';
import { useLabStore } from '@/stores/useLabStore';

interface RelatedLabsProps {
  lessonSlug: string;
}

function RelatedLabsComponent({ lessonSlug }: RelatedLabsProps) {
  const labs = getLabsForLesson(lessonSlug);
  const { progress, hydrate } = useLabStore();

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  if (labs.length === 0) return null;

  return (
    <section className="mt-8 p-5 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface)] space-y-3">
      <div className="flex items-center justify-between gap-2">
        <div>
          <h3 className="font-heading text-sm font-bold text-[var(--color-text)]">
            แล็บฝึกมือที่เกี่ยวข้อง (Interactive Sandbox)
          </h3>
          <p className="font-body text-xs mt-0.5 text-[var(--color-text-muted)] leading-relaxed">
            ลองนำคำสั่งจากบทเรียนนี้ไปแก้เคสจำลองในเทอร์มินัลจริง
          </p>
        </div>
        <Link
          href="/labs"
          className="text-xs font-medium text-[var(--color-accent)] hover:underline shrink-0"
        >
          ดูแล็บทั้งหมด →
        </Link>
      </div>

      <div className="grid grid-cols-1 gap-2.5 pt-1">
        {labs.map((lab) => {
          const isDone = !!progress[lab.slug]?.completed;
          return (
            <Link
              key={lab.slug}
              href={`/labs/${lab.slug}`}
              className={`flex items-center justify-between gap-3 p-3 rounded-lg border transition-all ${
                isDone
                  ? 'bg-[var(--color-surface-2)] border-emerald-500/30'
                  : 'bg-[var(--color-surface-2)] border-[var(--color-border)] hover:border-[var(--color-accent)]/50'
              }`}
            >
              <div className="min-w-0">
                <div className="flex items-center gap-2">
                  <span className="text-[11px] font-mono font-bold text-[var(--color-accent)]">
                    {lab.ticket.id}
                  </span>
                  <span className="font-heading text-sm font-semibold text-[var(--color-text)] truncate">
                    {lab.title}
                  </span>
                </div>
                <p className="font-body text-xs text-[var(--color-text-muted)] truncate mt-0.5">
                  {lab.ticket.summary}
                </p>
              </div>

              <span
                className={`text-xs font-semibold shrink-0 px-2.5 py-1 rounded-md border ${
                  isDone
                    ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-400'
                    : 'bg-[var(--color-surface)] border-[var(--color-border)] text-[var(--color-text)]'
                }`}
              >
                {isDone ? '✓ ผ่านแล้ว' : 'ฝึกแก้เคส →'}
              </span>
            </Link>
          );
        })}
      </div>
    </section>
  );
}

const RelatedLabs = React.memo(RelatedLabsComponent);
export default RelatedLabs;
