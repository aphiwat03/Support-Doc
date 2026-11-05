import React from 'react';
import Link from 'next/link';
import { Lesson } from '@/types';

interface LessonRowProps {
  lesson: Lesson;
  topicSlug: string;
}

const difficultyDotColor: Record<string, { dot: string; label: string }> = {
  beginner: { dot: 'bg-emerald-400', label: 'Beginner' },
  intermediate: { dot: 'bg-amber-400', label: 'Intermediate' },
  advanced: { dot: 'bg-rose-400', label: 'Advanced' },
};

export const LessonRow: React.FC<LessonRowProps> = ({ lesson, topicSlug }) => {
  const diff = difficultyDotColor[lesson.difficulty] || { dot: 'bg-emerald-400', label: lesson.difficulty };

  return (
    <Link
      href={`/learn/${topicSlug}/${lesson.slug}`}
      className="group block py-3.5 px-3 -mx-3 rounded-md hover:bg-[var(--color-surface)] transition-colors border-b border-[var(--color-border)] last:border-b-0"
    >
      <div className="flex flex-col sm:flex-row sm:items-baseline sm:justify-between gap-1 sm:gap-4">
        {/* Title */}
        <h3 className="font-heading font-semibold text-base text-[var(--color-text)] group-hover:text-[var(--color-accent)] transition-colors leading-snug">
          {lesson.title}
        </h3>

        {/* Metadata (Right side) */}
        <div className="flex items-center gap-2 text-xs text-[var(--color-text-muted)] shrink-0 pt-0.5">
          <span>{lesson.read_time_minutes} นาที</span>
          <span>·</span>
          <span className="inline-flex items-center gap-1.5">
            <span className={`h-1.5 w-1.5 rounded-full ${diff.dot}`} />
            <span>{diff.label}</span>
          </span>
        </div>
      </div>

      {/* Summary */}
      {lesson.summary && (
        <p className="font-body text-xs sm:text-sm text-[var(--color-text-muted)] line-clamp-2 mt-1 leading-relaxed">
          {lesson.summary}
        </p>
      )}
    </Link>
  );
};
