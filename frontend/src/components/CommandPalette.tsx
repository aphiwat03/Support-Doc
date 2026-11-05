'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Command } from 'cmdk';
import { Search, BookOpen, Layers, HelpCircle, X, ArrowRight } from 'lucide-react';
import { api } from '@/lib/api';
import { Lesson } from '@/types';

interface CommandPaletteProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export const CommandPalette: React.FC<CommandPaletteProps> = ({
  open,
  onOpenChange,
}) => {
  const router = useRouter();
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [search, setSearch] = useState('');

  // Load lessons once when opened or initially
  useEffect(() => {
    if (open && lessons.length === 0) {
      api.getLessons()
        .then(setLessons)
        .catch((err) => console.warn('Failed to fetch lessons for search:', err));
    }
  }, [open, lessons.length]);

  // Global Ctrl+K / Cmd+K key listener
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        onOpenChange(!open);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [open, onOpenChange]);

  const handleSelectLesson = (topicSlug: string, lessonSlug: string) => {
    onOpenChange(false);
    setSearch('');
    router.push(`/learn/${topicSlug}/${lessonSlug}`);
  };

  const handleSelectNav = (path: string) => {
    onOpenChange(false);
    setSearch('');
    router.push(path);
  };

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-16 sm:pt-24 p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-150">
      <div 
        className="w-full max-w-xl bg-[var(--color-surface)] border border-[var(--color-border)] rounded-xl shadow-2xl overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        <Command
          label="ค้นหาบทเรียนและเมนู"
          className="flex flex-col w-full"
        >
          {/* Search Input Bar */}
          <div className="flex items-center px-4 border-b border-[var(--color-border)] bg-[var(--color-surface-2)]">
            <Search className="h-4 w-4 text-[var(--color-text-muted)] shrink-0 mr-3" />
            <Command.Input
              value={search}
              onValueChange={setSearch}
              placeholder="ค้นหาบทเรียน, คำสั่ง, หรือหัวข้อ... (พิมพ์เพื่อกรอง)"
              className="w-full py-3.5 bg-transparent text-sm text-[var(--color-text)] placeholder:text-[var(--color-text-muted)] focus:outline-none"
              autoFocus
            />
            {search && (
              <button
                onClick={() => setSearch('')}
                className="p-1 text-[var(--color-text-muted)] hover:text-[var(--color-text)]"
              >
                <X className="h-3.5 w-3.5" />
              </button>
            )}
            <kbd className="hidden sm:inline-block ml-2 px-1.5 py-0.5 text-[10px] font-mono text-[var(--color-text-muted)] bg-[var(--color-surface)] border border-[var(--color-border)] rounded">
              ESC
            </kbd>
          </div>

          {/* Search Results List */}
          <Command.List className="max-h-80 overflow-y-auto p-2 space-y-1">
            <Command.Empty className="py-8 text-center text-sm text-[var(--color-text-muted)]">
              ไม่พบผลลัพธ์ที่ตรงกับ "{search}"
            </Command.Empty>

            {/* Quick Navigation Group */}
            {!search && (
              <Command.Group heading="เมนูด่วน" className="px-2 py-1.5 text-[11px] font-semibold text-[var(--color-text-muted)] uppercase tracking-wider">
                <Command.Item
                  onSelect={() => handleSelectNav('/learn')}
                  className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-[var(--color-text)] cursor-pointer hover:bg-[var(--color-surface-2)] aria-selected:bg-[var(--color-surface-2)] aria-selected:text-[var(--color-accent)] transition-colors"
                >
                  <div className="flex items-center gap-2.5">
                    <BookOpen className="h-4 w-4 text-cyan-400" />
                    <span>หน้ารวมบทเรียนทั้งหมด</span>
                  </div>
                  <ArrowRight className="h-3.5 w-3.5 opacity-50" />
                </Command.Item>
                <Command.Item
                  onSelect={() => handleSelectNav('/quiz')}
                  className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-[var(--color-text)] cursor-pointer hover:bg-[var(--color-surface-2)] aria-selected:bg-[var(--color-surface-2)] aria-selected:text-[var(--color-accent)] transition-colors"
                >
                  <div className="flex items-center gap-2.5">
                    <HelpCircle className="h-4 w-4 text-emerald-400" />
                    <span>คลังข้อสอบและจำลองสอบ</span>
                  </div>
                  <ArrowRight className="h-3.5 w-3.5 opacity-50" />
                </Command.Item>
                <Command.Item
                  onSelect={() => handleSelectNav('/flashcards')}
                  className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-[var(--color-text)] cursor-pointer hover:bg-[var(--color-surface-2)] aria-selected:bg-[var(--color-surface-2)] aria-selected:text-[var(--color-accent)] transition-colors"
                >
                  <div className="flex items-center gap-2.5">
                    <Layers className="h-4 w-4 text-amber-400" />
                    <span>ทบทวนคำสั่งด้วยแฟลชการ์ด</span>
                  </div>
                  <ArrowRight className="h-3.5 w-3.5 opacity-50" />
                </Command.Item>
              </Command.Group>
            )}

            {/* Lessons Group */}
            <Command.Group heading="บทเรียน (Lessons)" className="px-2 py-1.5 text-[11px] font-semibold text-[var(--color-text-muted)] uppercase tracking-wider">
              {lessons.map((lesson) => (
                <Command.Item
                  key={lesson.id}
                  value={`${lesson.title} ${lesson.summary || ''} ${lesson.topic_title || ''}`}
                  onSelect={() => handleSelectLesson(lesson.topic_slug || 'linux', lesson.slug)}
                  className="flex flex-col px-3 py-2 rounded-lg text-sm cursor-pointer hover:bg-[var(--color-surface-2)] aria-selected:bg-[var(--color-surface-2)] aria-selected:text-[var(--color-accent)] transition-colors"
                >
                  <div className="flex items-center justify-between">
                    <span className="font-medium text-[var(--color-text)]">
                      {lesson.title}
                    </span>
                    <span className="text-[10px] px-1.5 py-0.5 rounded bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text-muted)] shrink-0 ml-2">
                      {lesson.topic_title || lesson.topic_slug}
                    </span>
                  </div>
                  {lesson.summary && (
                    <p className="text-xs text-[var(--color-text-muted)] line-clamp-1 mt-0.5">
                      {lesson.summary}
                    </p>
                  )}
                </Command.Item>
              ))}
            </Command.Group>
          </Command.List>

          {/* Footer Bar */}
          <div className="flex items-center justify-between px-4 py-2 border-t border-[var(--color-border)] bg-[var(--color-surface-2)] text-[11px] text-[var(--color-text-muted)]">
            <span>ใช้ลูกศรขึ้น-ลงเพื่อเลือก, Enter เพื่อเปิด</span>
            <button
              onClick={() => onOpenChange(false)}
              className="hover:text-[var(--color-text)] underline text-[10px]"
            >
              ปิดหน้าต่าง
            </button>
          </div>
        </Command>
      </div>
    </div>
  );
};
