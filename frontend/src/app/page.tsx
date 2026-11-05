'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { ArrowRight, HelpCircle, BookOpen } from 'lucide-react';
import { TopicCard } from '@/components/TopicCard';
import { Topic } from '@/types';
import { api } from '@/lib/api';

interface LastVisitedLesson {
  topicSlug: string;
  lessonSlug: string;
  title: string;
  topicTitle: string;
  visitedAt: number;
}

const initialTopics: Topic[] = [
  {
    id: 1,
    slug: 'linux',
    title: 'Linux Administration',
    description: 'คำสั่งพื้นฐาน, สิทธิ์ไฟล์ chmod/chown, Service systemctl, Process และการวิเคราะห์ Log',
    icon: 'Terminal',
    color: 'amber',
    display_order: 1,
    lessons_count: 9,
    questions_count: 57,
    flashcards_count: 97,
  },
  {
    id: 2,
    slug: 'network',
    title: 'Network Troubleshooting',
    description: 'TCP/IP, Subnetting, DNS, Routing, Port, Firewall และเครื่องมือตรวจสอบ Layer 3-7',
    icon: 'Network',
    color: 'cyan',
    display_order: 2,
    lessons_count: 2,
    questions_count: 2,
    flashcards_count: 2,
  },
  {
    id: 3,
    slug: 'sql',
    title: 'SQL & Database Essentials',
    description: 'PostgreSQL Query, JOIN, Aggregations, Index, Performance และการตรวจสอบปัญหา DB',
    icon: 'Database',
    color: 'emerald',
    display_order: 3,
    lessons_count: 2,
    questions_count: 2,
    flashcards_count: 2,
  },
  {
    id: 4,
    slug: 'web-api',
    title: 'Web & HTTP/API',
    description: 'HTTP Status Codes, Headers, REST API, curl, SSL/TLS Handshake และ Web Server',
    icon: 'Globe',
    color: 'violet',
    display_order: 4,
    lessons_count: 0,
    questions_count: 0,
    flashcards_count: 0,
  },
  {
    id: 5,
    slug: 'docker',
    title: 'Docker & Containers',
    description: 'Docker Command, Container Lifecycle, Log, Networking และการแก้ปัญหา Container ล่ม',
    icon: 'Container',
    color: 'sky',
    display_order: 5,
    lessons_count: 0,
    questions_count: 0,
    flashcards_count: 0,
  },
  {
    id: 6,
    slug: 'troubleshooting',
    title: 'Incident & Troubleshooting',
    description: 'ขั้นตอนวิเคราะห์ Root Cause, วิธีการไล่ปัญหาอย่างเป็นระบบ (Methodology) และ ITIL',
    icon: 'Wrench',
    color: 'rose',
    display_order: 6,
    lessons_count: 2,
    questions_count: 0,
    flashcards_count: 0,
  },
  {
    id: 7,
    slug: 'datacenter',
    title: 'Data Center & Hardware Ops',
    description: 'สายสัญญาณ Fiber/Copper, ฮาร์ดแวร์เซิร์ฟเวอร์, iDRAC/iLO, SAN Zoning, ระบบไฟ UPS/ATS, Hot/Cold Aisle และเทคนิคสัมภาษณ์ DC',
    icon: 'Server',
    color: 'orange',
    display_order: 7,
    lessons_count: 5,
    questions_count: 15,
    flashcards_count: 20,
  },
];

export default function HomePage() {
  const [topics, setTopics] = useState<Topic[]>(initialTopics);
  const [lastVisited, setLastVisited] = useState<LastVisitedLesson | null>(null);

  useEffect(() => {
    let isMounted = true;
    api.getTopics()
      .then((data) => {
        if (isMounted && Array.isArray(data) && data.length > 0) {
          setTopics(data);
        }
      })
      .catch(() => {});

    try {
      const saved = localStorage.getItem('support_last_visited_lesson');
      if (saved) {
        setLastVisited(JSON.parse(saved));
      }
    } catch {}

    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <main className="flex-1 mx-auto w-full max-w-5xl p-4 sm:p-6 lg:p-10">
      {/* Resume Reading Card */}
      {lastVisited && (
        <div className="mb-6 p-4 sm:p-5 rounded-xl border border-[var(--color-accent)]/30 bg-[var(--color-surface)]/90 backdrop-blur-sm shadow-lg flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 animate-in fade-in slide-in-from-top-2 duration-300">
          <div className="flex items-center gap-3.5">
            <div className="p-2.5 rounded-lg bg-[var(--color-accent)]/10 text-[var(--color-accent)] shrink-0">
              <BookOpen className="h-5 w-5" />
            </div>
            <div>
              <div className="text-[11px] font-semibold text-[var(--color-accent)] uppercase tracking-wider">
                เรียนต่อจากครั้งก่อน
              </div>
              <div className="font-heading text-base font-semibold text-[var(--color-text)] mt-0.5">
                {lastVisited.title}
              </div>
              <div className="text-xs text-[var(--color-text-muted)]">
                หมวดหมู่: {lastVisited.topicTitle}
              </div>
            </div>
          </div>
          <Link
            href={`/learn/${lastVisited.topicSlug}/${lastVisited.lessonSlug}`}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-md bg-[var(--color-accent)] text-slate-950 font-semibold text-xs hover:bg-[var(--color-accent-hover)] transition-all shrink-0 shadow-sm"
          >
            <span>อ่านต่อเลย</span>
            <ArrowRight className="h-3.5 w-3.5" />
          </Link>
        </div>
      )}

      {/* Hero Section */}
      <section className="mb-12 pt-4 pb-8 border-b border-[var(--color-border)]">
        <h1 className="font-heading text-3xl sm:text-4xl font-bold text-[var(--color-text)] mb-3 leading-[1.35]">
          SupportHub
        </h1>
        <p className="font-body text-base sm:text-lg text-[var(--color-text-muted)] max-w-2xl mb-6 leading-[1.75]">
          คลังความรู้ สรุปคำสั่งสำคัญ และแนวทางวิเคราะห์ปัญหาหน้างานสำหรับ Application Support และ NOC Tier 1
        </p>

        <div className="flex flex-wrap items-center gap-3">
          <Link
            href="/learn"
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-md bg-[var(--color-accent)] text-slate-950 font-medium text-sm hover:bg-[var(--color-accent-hover)] transition-colors"
          >
            <span>เริ่มอ่านบทเรียน</span>
            <ArrowRight className="h-4 w-4" />
          </Link>
          <Link
            href="/quiz"
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text)] font-medium text-sm hover:bg-[var(--color-surface-2)] transition-colors"
          >
            <HelpCircle className="h-4 w-4 text-[var(--color-accent)]" />
            <span>สุ่มข้อสอบด่วน</span>
          </Link>
        </div>
      </section>

      {/* Core Topics Grid */}
      <section>
        <div className="mb-5">
          <h2 className="font-heading text-lg sm:text-xl font-semibold text-[var(--color-text)]">
            หมวดหมู่วิชาชีพ
          </h2>
          <p className="font-body text-xs sm:text-sm text-[var(--color-text-muted)] mt-0.5">
            เลือกหมวดหมู่ที่ต้องการศึกษาหรือทบทวนความรู้
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {topics.map((topic) => (
            <TopicCard key={topic.id} topic={topic} />
          ))}
        </div>
      </section>
    </main>
  );
}
