'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { LessonRow } from '@/components/LessonRow';
import { Topic, Lesson } from '@/types';
import { api } from '@/lib/api';

const topicColorMap: Record<string, string> = {
  linux: 'bg-amber-400',
  network: 'bg-cyan-400',
  sql: 'bg-emerald-400',
  'web-api': 'bg-violet-400',
  docker: 'bg-sky-400',
  troubleshooting: 'bg-rose-400',
  datacenter: 'bg-orange-400',
};

export default function LearnIndexPage() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([api.getTopics(), api.getLessons()])
      .then(([topicsData, lessonsData]) => {
        setTopics(topicsData);
        setLessons(lessonsData);
      })
      .catch((err) => {
        console.error('Failed to load learn data:', err);
      })
      .finally(() => setLoading(false));
  }, []);

  return (
    <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem]">
      {/* Page Header */}
      <div className="mb-8 pb-4 border-b border-[var(--color-border)]">
        <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
          บทเรียน
        </h1>
        <p className="font-body text-sm text-[var(--color-text-muted)] mt-1">
          อ่านสรุปเนื้อหา คำสั่งสำคัญ และกรณีศึกษาจากงานจริงสำหรับ Application Support และ NOC Tier 1
        </p>
      </div>

      {loading ? (
        <div className="py-12 text-sm text-[var(--color-text-muted)]">
          กำลังโหลดสารบัญบทเรียน...
        </div>
      ) : (
        <div className="space-y-10">
          {topics.map((topic) => {
            const topicLessons = lessons
              .filter((l) => l.topic_id === topic.id || l.topic_slug === topic.slug)
              .sort((a, b) => a.display_order - b.display_order);

            const dotColor = topicColorMap[topic.slug] || 'bg-cyan-400';

            return (
              <section key={topic.id} aria-labelledby={`topic-heading-${topic.slug}`}>
                {/* Topic Header */}
                <div className="mb-3">
                  <div className="flex items-center gap-2">
                    <span className={`h-2 w-2 rounded-full shrink-0 ${dotColor}`} />
                    <h2
                      id={`topic-heading-${topic.slug}`}
                      className="font-heading text-lg sm:text-xl font-semibold text-[var(--color-text)]"
                    >
                      <Link
                        href={`/learn/${topic.slug}`}
                        className="hover:text-[var(--color-accent)] transition-colors"
                      >
                        {topic.title}
                      </Link>
                    </h2>
                  </div>
                  {topic.description && (
                    <p className="font-body text-xs sm:text-sm text-[var(--color-text-muted)] mt-0.5 pl-4">
                      {topic.description}
                    </p>
                  )}
                </div>

                {/* Lessons Rows */}
                <div className="border-t border-[var(--color-border)]">
                  {topicLessons.length > 0 ? (
                    topicLessons.map((lesson) => (
                      <LessonRow
                        key={lesson.id}
                        lesson={lesson}
                        topicSlug={topic.slug}
                      />
                    ))
                  ) : (
                    <div className="py-4 text-xs text-[var(--color-text-muted)] pl-4 italic">
                      กำลังจัดทำบทเรียนสำหรับหมวดนี้
                    </div>
                  )}
                </div>
              </section>
            );
          })}
        </div>
      )}
    </main>
  );
}
