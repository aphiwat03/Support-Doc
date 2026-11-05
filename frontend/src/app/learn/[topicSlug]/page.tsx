'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { HelpCircle } from 'lucide-react';
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

export default function TopicLessonsPage() {
  const params = useParams();
  const topicSlug = params?.topicSlug as string;

  const [topic, setTopic] = useState<(Topic & { lessons: Lesson[] }) | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!topicSlug) return;
    api.getTopicBySlug(topicSlug)
      .then((data) => {
        setTopic(data);
      })
      .catch((err) => {
        console.error('Failed to load topic:', err);
      })
      .finally(() => setLoading(false));
  }, [topicSlug]);

  if (loading) {
    return (
      <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem]">
        <div className="py-12 text-sm text-[var(--color-text-muted)]">
          กำลังโหลดเนื้อหาหมวดหมู่...
        </div>
      </main>
    );
  }

  if (!topic) {
    return (
      <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem]">
        <h1 className="font-heading text-xl font-bold text-[var(--color-text)] mb-2">
          ไม่พบหมวดหมู่ดังกล่าว
        </h1>
        <Link href="/learn" className="text-[var(--color-accent)] text-sm hover:underline">
          กลับไปสารบัญบทเรียนทั้งหมด
        </Link>
      </main>
    );
  }

  const lessons = (topic.lessons || []).sort((a, b) => a.display_order - b.display_order);
  const dotColor = topicColorMap[topic.slug] || 'bg-cyan-400';

  return (
    <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem]">
      {/* Breadcrumb */}
      <nav aria-label="Breadcrumb" className="flex items-center gap-2 text-xs text-[var(--color-text-muted)] mb-4">
        <Link href="/learn" className="hover:text-[var(--color-accent)] transition-colors">
          บทเรียน
        </Link>
        <span>/</span>
        <span className="text-[var(--color-text)] font-medium">{topic.title}</span>
      </nav>

      {/* Topic Header */}
      <div className="mb-8 pb-5 border-b border-[var(--color-border)]">
        <div className="flex items-center gap-2.5 mb-1.5">
          <span className={`h-2.5 w-2.5 rounded-full shrink-0 ${dotColor}`} />
          <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
            {topic.title}
          </h1>
        </div>
        {topic.description && (
          <p className="font-body text-sm text-[var(--color-text-muted)] leading-relaxed pl-5">
            {topic.description}
          </p>
        )}

        <div className="flex items-center gap-4 mt-4 pl-5 text-xs text-[var(--color-text-muted)]">
          <span>{lessons.length} บทเรียน</span>
          <span>·</span>
          <Link
            href={`/quiz?topic_slug=${topic.slug}`}
            className="inline-flex items-center gap-1.5 text-[var(--color-accent)] hover:underline font-medium"
          >
            <HelpCircle className="h-3.5 w-3.5" />
            <span>ทดสอบโจทย์ในหมวดนี้</span>
          </Link>
        </div>
      </div>

      {/* Lessons List Rows */}
      <div className="border-t border-[var(--color-border)]">
        {lessons.length > 0 ? (
          lessons.map((lesson) => (
            <LessonRow
              key={lesson.id}
              lesson={lesson}
              topicSlug={topic.slug}
            />
          ))
        ) : (
          <div className="py-6 text-xs text-[var(--color-text-muted)] italic">
            กำลังจัดทำบทเรียนสำหรับหมวดนี้
          </div>
        )}
      </div>
    </main>
  );
}
