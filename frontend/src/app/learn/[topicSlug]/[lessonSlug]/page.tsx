'use client';

import React, { useEffect, useState, useMemo } from 'react';
import Link from 'next/link';
import { useParams, useRouter } from 'next/navigation';
import { 
  ArrowLeft, 
  ArrowRight, 
  ArrowUp,
  Bookmark, 
  HelpCircle, 
  Layers,
  Check
} from 'lucide-react';
import { MarkdownContent } from '@/components/MarkdownContent';
import { OnThisPage, extractHeadings } from '@/components/OnThisPage';
import RelatedLabs from '@/components/labs/RelatedLabs';
import { Lesson } from '@/types';
import { api } from '@/lib/api';
import { useAppStore } from '@/stores/useAppStore';
import { toast } from 'sonner';
import { fireCelebrationConfetti } from '@/lib/confetti';

const difficultyMap: Record<string, { dot: string; label: string }> = {
  beginner: { dot: 'bg-emerald-400', label: 'Beginner' },
  intermediate: { dot: 'bg-amber-400', label: 'Intermediate' },
  advanced: { dot: 'bg-rose-400', label: 'Advanced' },
};

function ReadingProgressBar() {
  const barRef = React.useRef<HTMLDivElement>(null);

  useEffect(() => {
    let ticking = false;

    const updateBar = () => {
      const scrollTop = window.scrollY;
      const docHeight = document.documentElement.scrollHeight - window.innerHeight;
      const progress = docHeight > 0 ? Math.min(100, Math.max(0, (scrollTop / docHeight) * 100)) : 0;
      if (barRef.current) {
        barRef.current.style.width = `${progress}%`;
      }
      ticking = false;
    };

    const handleScroll = () => {
      if (!ticking) {
        window.requestAnimationFrame(updateBar);
        ticking = true;
      }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    updateBar();
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div 
      aria-hidden="true"
      className="fixed top-14 left-0 right-0 h-[2.5px] z-30 bg-transparent pointer-events-none"
    >
      <div 
        ref={barRef}
        className="h-full bg-gradient-to-r from-cyan-400 via-sky-400 to-indigo-500 shadow-[0_0_8px_rgba(56,189,248,0.5)] transition-[width] duration-75 ease-out"
        style={{ width: '0%' }}
      />
    </div>
  );
}

export default function LessonDetailPage() {
  const router = useRouter();
  const params = useParams();
  const topicSlug = params?.topicSlug as string;
  const lessonSlug = params?.lessonSlug as string;

  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [loading, setLoading] = useState(true);
  const [showBackToTop, setShowBackToTop] = useState(false);

  const { 
    bookmarkIds, 
    toggleBookmarkId, 
    completedLessonIds, 
    toggleCompletedLessonId, 
    setStreakInfo 
  } = useAppStore();
  const isBookmarked = lesson ? bookmarkIds.has(lesson.id) : false;
  const isCompleted = lesson ? completedLessonIds.has(lesson.id) : false;

  useEffect(() => {
    if (!topicSlug || !lessonSlug) return;
    setLoading(true);
    api.getLessonBySlug(topicSlug, lessonSlug)
      .then((data) => {
        setLesson(data);
        // Save to localStorage for Resume Reading on Homepage
        try {
          localStorage.setItem('support_last_visited_lesson', JSON.stringify({
            topicSlug,
            lessonSlug,
            title: data.title,
            topicTitle: data.topic_title || topicSlug,
            visitedAt: Date.now(),
          }));
        } catch {}
      })
      .catch((err) => {
        console.error('Failed to load lesson:', err);
      })
      .finally(() => setLoading(false));
  }, [topicSlug, lessonSlug]);

  // Floating Back-to-Top Button visibility (only triggers state update on threshold crossing)
  useEffect(() => {
    let currentShown = false;
    const handleScroll = () => {
      const shouldShow = window.scrollY > 400;
      if (shouldShow !== currentShown) {
        currentShown = shouldShow;
        setShowBackToTop(shouldShow);
      }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  // Keyboard Navigation: ArrowLeft (prev) and ArrowRight (next)
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Don't trigger if user is in an input / textarea
      if (['INPUT', 'TEXTAREA'].includes((e.target as HTMLElement)?.tagName)) return;

      if (e.key === 'ArrowLeft' && lesson?.prev_lesson) {
        router.push(`/learn/${topicSlug}/${lesson.prev_lesson.slug}`);
      } else if (e.key === 'ArrowRight' && lesson?.next_lesson) {
        router.push(`/learn/${topicSlug}/${lesson.next_lesson.slug}`);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [lesson, topicSlug, router]);

  const headings = useMemo(() => {
    return lesson?.content_md ? extractHeadings(lesson.content_md) : [];
  }, [lesson?.content_md]);

  const handleBookmark = async () => {
    if (!lesson) return;
    const isCurrentlyBookmarked = bookmarkIds.has(lesson.id);

    // Optimistic UI toggle
    toggleBookmarkId(lesson.id);

    if (isCurrentlyBookmarked) {
      toast.info('นำออกจากบุ๊กมาร์กแล้ว');
    } else {
      toast.success('บันทึกบุ๊กมาร์กเรียบร้อย');
    }

    try {
      if (isCurrentlyBookmarked) {
        await api.deleteBookmarkByItem('lesson', lesson.id);
      } else {
        await api.addBookmark({
          item_type: 'lesson',
          item_id: lesson.id,
          notes: `บุ๊กมาร์กบทเรียน: ${lesson.title}`,
        });
      }
    } catch (err) {
      console.error('Bookmark toggle error:', err);
      // Rollback on error
      toggleBookmarkId(lesson.id);
      toast.error('ไม่สามารถบันทึกได้ โปรดลองอีกครั้ง');
    }
  };

  const handleToggleComplete = async () => {
    if (!lesson) return;
    const currentlyCompleted = completedLessonIds.has(lesson.id);

    // Optimistic toggle
    toggleCompletedLessonId(lesson.id);

    if (currentlyCompleted) {
      toast.info('ยกเลิกสถานะอ่านเสร็จแล้ว');
    } else {
      fireCelebrationConfetti();
      toast.success('🎉 ยินดีด้วย! อ่านจบบทนี้แล้ว (Streak +1)');
    }

    try {
      if (currentlyCompleted) {
        await api.unmarkLessonComplete(lesson.id);
      } else {
        await api.markLessonComplete(lesson.id);
        api.getStreakSummary().then((s) => {
          if (s) setStreakInfo(s.current_streak, s.studied_today);
        });
      }
    } catch (err) {
      console.error('Progress toggle error:', err);
      toggleCompletedLessonId(lesson.id);
      toast.error('บันทึกความคืบหน้าไม่สำเร็จ');
    }
  };

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  if (loading) {
    return (
      <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem] space-y-6 animate-pulse">
        {/* Breadcrumb skeleton */}
        <div className="flex items-center gap-2">
          <div className="h-3 w-16 bg-[var(--color-surface-2)] rounded" />
          <div className="h-3 w-3 bg-[var(--color-surface-2)] rounded" />
          <div className="h-3 w-28 bg-[var(--color-surface-2)] rounded" />
        </div>

        {/* Title skeleton */}
        <div className="space-y-3">
          <div className="h-8 w-3/4 bg-[var(--color-surface-2)] rounded-lg" />
          <div className="h-4 w-36 bg-[var(--color-surface-2)] rounded" />
        </div>

        {/* Lead box skeleton */}
        <div className="h-20 w-full bg-[var(--color-surface-2)]/60 rounded-lg border border-[var(--color-border)]" />

        {/* Content body lines */}
        <div className="space-y-3 pt-4">
          <div className="h-4 w-full bg-[var(--color-surface-2)] rounded" />
          <div className="h-4 w-5/6 bg-[var(--color-surface-2)] rounded" />
          <div className="h-4 w-4/6 bg-[var(--color-surface-2)] rounded" />
        </div>
      </main>
    );
  }

  if (!lesson) {
    return (
      <main className="flex-1 min-w-0 p-4 sm:p-6 lg:p-10 max-w-[48rem]">
        <h1 className="font-heading text-xl font-bold text-[var(--color-text)] mb-2">
          ไม่พบเนื้อหาบทเรียนนี้
        </h1>
        <Link href={`/learn/${topicSlug}`} className="text-[var(--color-accent)] text-sm hover:underline">
          กลับไปหน้ารวมบทเรียน
        </Link>
      </main>
    );
  }

  const diff = difficultyMap[lesson.difficulty] || { dot: 'bg-emerald-400', label: lesson.difficulty };

  return (
    <div className="flex-1 min-w-0 flex items-start justify-between gap-6 lg:gap-10 p-4 sm:p-6 lg:p-10 pb-20 relative">
      {/* Top Reading Progress Bar (Fixed below header, isolated DOM-driven) */}
      <ReadingProgressBar />

      {/* Floating Back to Top Button */}
      {showBackToTop && (
        <button
          onClick={scrollToTop}
          aria-label="เลื่อนขึ้นด้านบนสุด"
          title="เลื่อนขึ้นบนสุด"
          className="fixed bottom-6 right-6 z-40 p-2.5 rounded-full bg-[var(--color-surface-2)] border border-[var(--color-border)] text-[var(--color-text)] shadow-lg hover:border-[var(--color-accent)] hover:text-[var(--color-accent)] transition-all animate-in fade-in slide-in-from-bottom-2 duration-200"
        >
          <ArrowUp className="h-4 w-4" />
        </button>
      )}

      {/* Center Article Content */}
      <article className="flex-1 min-w-0 max-w-[44rem] mx-auto xl:mx-0">
        {/* Breadcrumb Navigation */}
        <nav aria-label="Breadcrumb" className="flex items-center gap-2 text-xs text-[var(--color-text-muted)] mb-5 flex-wrap">
          <Link href="/learn" className="hover:text-[var(--color-accent)] transition-colors">
            บทเรียน
          </Link>
          <span>/</span>
          <Link href={`/learn/${topicSlug}`} className="hover:text-[var(--color-accent)] transition-colors">
            {lesson.topic_title || topicSlug}
          </Link>
          <span>/</span>
          <span className="text-[var(--color-text)] font-medium truncate max-w-xs">{lesson.title}</span>
        </nav>

        {/* Title Header Row with Bookmark Button */}
        <div className="flex items-start justify-between gap-4 mb-3">
          <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)] leading-[1.35]">
            {lesson.title}
          </h1>

          <button
            onClick={handleBookmark}
            aria-label={isBookmarked ? 'ลบบุ๊กมาร์ก' : 'บันทึกบทเรียนนี้'}
            title={isBookmarked ? 'บันทึกแล้ว' : 'บันทึกบทเรียนนี้'}
            className={`p-2 rounded-md border shrink-0 transition-colors ${
              isBookmarked
                ? 'bg-amber-400/10 text-amber-400 border-amber-400/30'
                : 'border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)]'
            }`}
          >
            <Bookmark className={`h-4 w-4 ${isBookmarked ? 'fill-amber-400' : ''}`} />
          </button>
        </div>

        {/* Metadata Row */}
        <div className="flex items-center gap-2 text-xs text-[var(--color-text-muted)] mb-5">
          <span>{lesson.read_time_minutes} นาที</span>
          <span>·</span>
          <span className="inline-flex items-center gap-1.5">
            <span className={`h-1.5 w-1.5 rounded-full ${diff.dot}`} />
            <span>{diff.label}</span>
          </span>
        </div>

        {/* Lead Summary Paragraph */}
        {lesson.summary && (
          <p className="font-body text-base text-[var(--color-text)] leading-[1.75] mb-6 pb-6 border-b border-[var(--color-border)] [text-wrap:pretty]">
            {lesson.summary}
          </p>
        )}

        {/* Main Markdown Body */}
        <div className="mb-8">
          <MarkdownContent content={lesson.content_md || 'ยังไม่มีเนื้อหาในบทเรียนนี้'} />
        </div>

        {/* Mark Complete Action Card */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 p-4 my-6 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)]">
          <div className="flex items-center gap-3">
            <div className={`p-2 rounded-full shrink-0 transition-colors ${isCompleted ? 'bg-emerald-500/20 text-emerald-400' : 'bg-[var(--color-surface-2)] text-[var(--color-text-muted)]'}`}>
              <Check className="h-5 w-5" />
            </div>
            <div>
              <div className="font-heading text-sm font-semibold text-[var(--color-text)]">
                {isCompleted ? 'อ่านบทเรียนนี้จบแล้ว' : 'อ่านบทเรียนนี้จบหรือยัง?'}
              </div>
              <div className="text-xs text-[var(--color-text-muted)]">
                {isCompleted ? 'ระบบบันทึกความคืบหน้าและ Streak ประจำวันของคุณแล้ว' : 'กดทำเครื่องหมายเพื่อสะสมสถิติ Streak และนับเปอร์เซ็นต์ความคืบหน้า'}
              </div>
            </div>
          </div>
          <button
            onClick={handleToggleComplete}
            className={`px-4 py-2 rounded-md text-xs font-semibold shrink-0 transition-all ${
              isCompleted
                ? 'bg-[var(--color-surface-2)] border border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-rose-400 hover:border-rose-400/40'
                : 'bg-emerald-500 text-slate-950 hover:bg-emerald-400 shadow-sm shadow-emerald-500/20'
            }`}
          >
            {isCompleted ? 'ยกเลิกสถานะอ่านเสร็จ' : 'ทำเครื่องหมายว่าอ่านแล้ว'}
          </button>
        </div>

        {/* Related Interactive Labs */}
        <RelatedLabs lessonSlug={lessonSlug} />

        {/* Review Box: ทบทวนบทนี้ */}
        <div className="my-8 p-4 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-xs">
          <div className="font-heading font-semibold text-sm text-[var(--color-text)] mb-2">
            ทบทวนบทนี้
          </div>
          <p className="font-body text-[var(--color-text-muted)] mb-3 leading-relaxed">
            ฝึกทำโจทย์สถานการณ์จริงหรือพลิกทบทวนแฟลชการ์ดสำหรับเนื้อหาในหมวด {lesson.topic_title}
          </p>
          <div className="flex flex-wrap items-center gap-3">
            <Link
              href={`/quiz?topic_slug=${topicSlug}`}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-md bg-[var(--color-accent)] text-slate-950 font-medium hover:bg-[var(--color-accent-hover)] transition-colors"
            >
              <HelpCircle className="h-3.5 w-3.5" />
              <span>ทำแบบทดสอบ (Quiz)</span>
            </Link>
            <Link
              href="/flashcards"
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text)] hover:bg-[var(--color-surface)] transition-colors"
            >
              <Layers className="h-3.5 w-3.5 text-amber-400" />
              <span>ทบทวนแฟลชการ์ด</span>
            </Link>
          </div>
        </div>

        {/* Previous / Next Lesson Navigation */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-6 border-t border-[var(--color-border)]">
          {lesson.prev_lesson ? (
            <Link
              href={`/learn/${topicSlug}/${lesson.prev_lesson.slug}`}
              className="group p-3.5 rounded-md border border-[var(--color-border)] hover:bg-[var(--color-surface)] transition-colors text-left"
            >
              <div className="flex items-center gap-1 text-xs text-[var(--color-text-muted)] group-hover:text-[var(--color-accent)] mb-1">
                <ArrowLeft className="h-3.5 w-3.5" />
                <span>บทก่อนหน้า</span>
              </div>
              <div className="font-heading text-sm font-semibold text-[var(--color-text)] leading-snug break-words">
                {lesson.prev_lesson.title}
              </div>
            </Link>
          ) : (
            <div />
          )}

          {lesson.next_lesson && (
            <Link
              href={`/learn/${topicSlug}/${lesson.next_lesson.slug}`}
              className="group p-3.5 rounded-md border border-[var(--color-border)] hover:bg-[var(--color-surface)] transition-colors text-right sm:col-start-2"
            >
              <div className="flex items-center justify-end gap-1 text-xs text-[var(--color-text-muted)] group-hover:text-[var(--color-accent)] mb-1">
                <span>บทถัดไป</span>
                <ArrowRight className="h-3.5 w-3.5" />
              </div>
              <div className="font-heading text-sm font-semibold text-[var(--color-text)] leading-snug break-words">
                {lesson.next_lesson.title}
              </div>
            </Link>
          )}
        </div>
      </article>

      {/* On This Page (Right TOC for Desktop) */}
      <OnThisPage headings={headings} />
    </div>
  );
}
