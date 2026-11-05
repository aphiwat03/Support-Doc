'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { 
  Trash2, 
  ArrowRight,
  Bookmark 
} from 'lucide-react';
import { Bookmark as BookmarkType } from '@/types';
import { api } from '@/lib/api';
import { useAppStore } from '@/stores/useAppStore';
import { toast } from 'sonner';

export default function BookmarksPage() {
  const [bookmarks, setBookmarks] = useState<BookmarkType[]>([]);
  const [filterType, setFilterType] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const { toggleBookmarkId, bookmarkIds } = useAppStore();

  const fetchBookmarks = () => {
    setLoading(true);
    api.getBookmarks(filterType || undefined)
      .then(setBookmarks)
      .catch((err) => console.error(err))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    fetchBookmarks();
  }, [filterType]);

  const handleDelete = async (id: string, itemId?: string) => {
    try {
      await api.deleteBookmark(id);
      setBookmarks((prev) => prev.filter((b) => b.id !== id));
      if (itemId && bookmarkIds.has(itemId)) {
        toggleBookmarkId(itemId);
      }
      toast.success('ลบบุ๊กมาร์กเรียบร้อย');
    } catch (err) {
      console.error(err);
      toast.error('ลบไม่สำเร็จ โปรดลองอีกครั้ง');
    }
  };

  return (
    <main className="flex-1 mx-auto w-full max-w-3xl p-4 sm:p-6 lg:p-10">
      <div className="mb-6 pb-4 border-b border-[var(--color-border)]">
        <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
          รายการที่บันทึกไว้ (Bookmarks)
        </h1>
        <p className="font-body text-sm text-[var(--color-text-muted)] mt-1">
          ทบทวนบทเรียน ข้อสอบ และแฟลชการ์ดที่บันทึกไว้
        </p>

        {/* Filter Pills */}
        <div className="flex items-center gap-1.5 mt-4 flex-wrap">
          {[
            { value: '', label: 'ทั้งหมด' },
            { value: 'lesson', label: 'บทเรียน' },
            { value: 'question', label: 'ข้อสอบ' },
            { value: 'flashcard', label: 'แฟลชการ์ด' },
          ].map((f) => (
            <button
              key={f.value}
              onClick={() => setFilterType(f.value)}
              className={`px-3 py-1 rounded-md text-xs font-medium border transition-colors ${
                filterType === f.value
                  ? 'bg-[var(--color-surface-2)] text-[var(--color-accent)] border-[var(--color-accent)] font-semibold'
                  : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border-[var(--color-border)] hover:text-[var(--color-text)]'
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {loading ? (
        <div className="p-12 text-center text-sm text-[var(--color-text-muted)]">
          กำลังโหลดรายการที่บันทึกไว้...
        </div>
      ) : bookmarks.length === 0 ? (
        <div className="p-8 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-center max-w-md mx-auto">
          <Bookmark className="h-8 w-8 text-[var(--color-text-muted)] mx-auto mb-2" />
          <h2 className="font-heading text-base font-semibold text-[var(--color-text)] mb-1">
            ยังไม่มีรายการที่บันทึกไว้
          </h2>
          <p className="font-body text-xs text-[var(--color-text-muted)] mb-4">
            คุณสามารถกดบันทึกในหน้าบทเรียน ข้อสอบ หรือแฟลชการ์ดเพื่อเก็บไว้อ่านซ้ำได้
          </p>
          <Link
            href="/learn"
            className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-md bg-[var(--color-accent)] text-slate-950 font-medium text-xs hover:bg-[var(--color-accent-hover)] transition-colors"
          >
            <span>ไปที่สารบัญบทเรียน</span>
            <ArrowRight className="h-3 w-3" />
          </Link>
        </div>
      ) : (
        <div className="space-y-3">
          {bookmarks.map((b) => (
            <div
              key={b.id}
              className="flex items-start justify-between gap-4 p-4 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] hover:bg-[var(--color-surface-2)] transition-colors"
            >
              <div className="min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-[11px] font-medium uppercase px-1.5 py-0.5 rounded bg-[var(--color-surface-2)] text-[var(--color-text-muted)] border border-[var(--color-border)]">
                    {b.item_type}
                  </span>
                  {b.item_details?.topic_title && (
                    <span className="text-xs text-[var(--color-text-muted)]">
                      {b.item_details.topic_title}
                    </span>
                  )}
                </div>

                <h3 className="font-heading text-sm font-semibold text-[var(--color-text)] leading-snug break-words">
                  {b.item_details?.title ||
                    b.item_details?.question_text ||
                    b.item_details?.front_text ||
                    b.notes ||
                    'รายการบุ๊กมาร์ก'}
                </h3>

                {b.notes && (
                  <p className="font-body text-xs text-[var(--color-text-muted)] mt-1 italic">
                    "{b.notes}"
                  </p>
                )}

                {/* Direct jump link */}
                {b.item_type === 'lesson' && b.item_details?.slug && (
                  <Link
                    href={`/learn/${b.item_details.topic_slug || 'linux'}/${b.item_details.slug}`}
                    className="inline-flex items-center gap-1 text-xs text-[var(--color-accent)] hover:underline mt-2"
                  >
                    <span>เปิดอ่านบทเรียนนี้</span>
                    <ArrowRight className="h-3 w-3" />
                  </Link>
                )}
              </div>

              {/* Delete button */}
              <button
                onClick={() => handleDelete(b.id, b.item_id)}
                className="p-1.5 text-[var(--color-text-muted)] hover:text-rose-400 rounded-md transition-colors shrink-0"
                title="ลบออกจากรายการที่บันทึก"
              >
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          ))}
        </div>
      )}
    </main>
  );
}
