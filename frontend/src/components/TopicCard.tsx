import React from 'react';
import Link from 'next/link';
import { Topic } from '@/types';

const topicColorMap: Record<string, string> = {
  linux: 'bg-amber-400',
  network: 'bg-cyan-400',
  sql: 'bg-emerald-400',
  'web-api': 'bg-violet-400',
  docker: 'bg-sky-400',
  troubleshooting: 'bg-rose-400',
  datacenter: 'bg-orange-400',
  tools: 'bg-teal-400',
};

interface TopicCardProps {
  topic: Topic;
}

export const TopicCard: React.FC<TopicCardProps> = ({ topic }) => {
  const dotColor = topicColorMap[topic.slug] || 'bg-cyan-400';

  return (
    <Link
      href={`/learn/${topic.slug}`}
      className="group p-5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] hover:bg-[var(--color-surface-2)] transition-colors flex flex-col justify-between"
    >
      <div>
        <div className="flex items-center gap-2 mb-2">
          <span className={`h-2 w-2 rounded-full shrink-0 ${dotColor}`} />
          <h3 className="font-heading font-semibold text-base text-[var(--color-text)] group-hover:text-[var(--color-accent)] transition-colors leading-snug">
            {topic.title}
          </h3>
        </div>
        <p className="font-body text-xs sm:text-sm text-[var(--color-text-muted)] line-clamp-2 leading-relaxed mb-4">
          {topic.description}
        </p>
      </div>

      <div className="flex items-center gap-3 text-xs text-[var(--color-text-muted)] pt-3 border-t border-[var(--color-border)]">
        <span>{topic.lessons_count || 0} บทเรียน</span>
        <span>·</span>
        <span>{topic.questions_count || 0} ข้อสอบ</span>
      </div>
    </Link>
  );
};
