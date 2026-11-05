'use client';

import React, { useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Terminal, Menu, X } from 'lucide-react';
import { useAppStore } from '@/stores/useAppStore';
import { api } from '@/lib/api';

export const Navbar = () => {
  const pathname = usePathname();
  const { 
    isSidebarOpen, 
    toggleSidebar, 
    setBookmarkIds, 
    setCompletedLessonIds, 
    streakDays, 
    studiedToday, 
    setStreakInfo 
  } = useAppStore();

  useEffect(() => {
    // 1. Initial bookmarks
    api.getBookmarks()
      .then((bookmarks) => {
        if (Array.isArray(bookmarks)) {
          setBookmarkIds(bookmarks.map((b) => b.item_id));
        }
      })
      .catch((err) => {
        console.warn('Initial bookmarks fetch deferred:', err);
      });

    // 2. Initial progress
    api.getProgress()
      .then((progress) => {
        if (progress?.completed_lesson_ids) {
          setCompletedLessonIds(progress.completed_lesson_ids);
        }
      })
      .catch((err) => {
        console.warn('Initial progress fetch deferred:', err);
      });

    // 3. Initial streak
    api.getStreakSummary()
      .then((summary) => {
        if (summary) {
          setStreakInfo(summary.current_streak, summary.studied_today);
        }
      })
      .catch((err) => {
        console.warn('Initial streak fetch deferred:', err);
      });
  }, [setBookmarkIds, setCompletedLessonIds, setStreakInfo]);

  // Re-synchronize Streak & Progress whenever navigating routes
  useEffect(() => {
    api.getStreakSummary()
      .then((summary) => {
        if (summary) {
          setStreakInfo(summary.current_streak, summary.studied_today);
        }
      })
      .catch(() => {});
  }, [pathname, setStreakInfo]);

  const navLinks = [
    { href: '/learn', label: 'บทเรียน' },
    { href: '/labs', label: 'แล็บ' },
    { href: '/quiz', label: 'แบบทดสอบ' },
    { href: '/flashcards', label: 'แฟลชการ์ด' },
    { href: '/bookmarks', label: 'บุ๊กมาร์ก' },
    { href: '/streak', label: 'สถิติ Streak' },
  ];

  return (
    <header className="sticky top-0 z-40 w-full h-14 border-b border-[var(--color-border)] bg-[var(--color-bg)]">
      <div className="mx-auto flex h-full max-w-7xl items-center justify-between px-4 sm:px-6">
        {/* Brand Logo */}
        <div className="flex items-center gap-3">
          <button
            onClick={toggleSidebar}
            aria-label={isSidebarOpen ? 'ปิดเมนูนำทาง' : 'เปิดเมนูนำทาง'}
            className="lg:hidden p-1.5 -ml-1 text-[var(--color-text-muted)] hover:text-[var(--color-text)] rounded-md transition-colors"
          >
            {isSidebarOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          </button>

          <Link href="/" className="flex items-center gap-2 group">
            <div className="flex h-7 w-7 items-center justify-center rounded-md bg-[var(--color-surface-2)] text-[var(--color-accent)] border border-[var(--color-border)]">
              <Terminal className="h-4 w-4" />
            </div>
            <span className="font-heading text-base font-semibold text-[var(--color-text)]">
              Support<span className="text-[var(--color-accent)]">Hub</span>
            </span>
          </Link>
        </div>

        {/* Desktop Navigation Links + Search */}
        <div className="flex items-center gap-2 sm:gap-3 h-full">
          <nav aria-label="เมนูหลัก" className="flex items-center gap-1 sm:gap-2 h-full">
            {navLinks.map((item) => {
              const isActive =
                pathname === item.href ||
                (item.href !== '/' && pathname.startsWith(item.href));

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center h-full px-3 text-sm font-medium transition-colors border-b-2 ${
                    isActive
                      ? 'text-[var(--color-accent)] border-[var(--color-accent)]'
                      : 'text-[var(--color-text-muted)] hover:text-[var(--color-text)] border-transparent'
                  }`}
                >
                  {item.label}
                </Link>
              );
            })}
          </nav>

          {/* Streak Flame Badge */}
          <Link
            href="/streak"
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded-full border text-xs font-semibold transition-all ${
              studiedToday
                ? 'bg-gradient-to-r from-amber-500/20 to-orange-500/20 text-orange-400 border-orange-500/30 hover:border-orange-500/50 shadow-sm shadow-orange-500/10'
                : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border-[var(--color-border)] hover:text-amber-400'
            }`}
            title={`เรียนต่อเนื่อง ${streakDays} วัน (คลิกดูหน้า Streak & สถิติ)`}
          >
            <span className={`text-sm ${studiedToday ? 'animate-bounce' : 'opacity-70'}`}>🔥</span>
            <span>{streakDays} วัน</span>
          </Link>
        </div>
      </div>
    </header>
  );
};
