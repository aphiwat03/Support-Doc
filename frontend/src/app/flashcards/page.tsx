'use client';

import React, { useEffect, useState, useMemo } from 'react';
import Link from 'next/link';
import { 
  RotateCw, 
  ChevronLeft, 
  ChevronRight, 
  Lightbulb,
  Bookmark,
  CheckCircle2,
  XCircle,
  HelpCircle,
  Sparkles,
  Shuffle
} from 'lucide-react';
import { Flashcard, Topic } from '@/types';
import { api } from '@/lib/api';
import { useAppStore } from '@/stores/useAppStore';
import { toast } from 'sonner';
import { fireCelebrationConfetti } from '@/lib/confetti';

type CardRating = 'mastered' | 'review';

export default function FlashcardsPage() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string>('');
  const [flashcards, setFlashcards] = useState<Flashcard[]>([]);
  const [ratings, setRatings] = useState<Record<string, CardRating>>({});
  const [filterMode, setFilterMode] = useState<'all' | 'review' | 'mastered'>('all');
  
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isFlipped, setIsFlipped] = useState(false);
  const [showHint, setShowHint] = useState(false);
  const [loading, setLoading] = useState(true);

  const { bookmarkIds, toggleBookmarkId, setStreakInfo } = useAppStore();

  // Load topics & saved ratings
  useEffect(() => {
    api.getTopics().then(setTopics).catch(() => {});
    try {
      const saved = localStorage.getItem('support_flashcard_ratings');
      if (saved) setRatings(JSON.parse(saved));
    } catch {}
  }, []);

  // Save ratings
  const updateRating = (cardId: string, rating: CardRating) => {
    const updated = { ...ratings, [cardId]: rating };
    setRatings(updated);
    try {
      localStorage.setItem('support_flashcard_ratings', JSON.stringify(updated));
    } catch {}

    // Record study activity & refresh streak in Navbar
    api.recordStudyActivity({ activity_type: 'flashcard', item_id: cardId })
      .then(() => api.getStreakSummary())
      .then((s) => {
        if (s) setStreakInfo(s.current_streak, s.studied_today);
      })
      .catch(() => {});

    if (rating === 'mastered') {
      toast.success('เยี่ยมมาก! จดจำการ์ดนี้เรียบร้อย', { duration: 1500 });
    } else {
      toast.info('บันทึกลงในรายการต้องทบทวน', { duration: 1500 });
    }

    // Auto next after 350ms
    setTimeout(() => {
      handleNext();
    }, 350);
  };

  useEffect(() => {
    setLoading(true);
    setIsFlipped(false);
    setShowHint(false);
    setCurrentIndex(0);
    api.getFlashcards(selectedTopic || undefined)
      .then((data) => {
        setFlashcards(data);
      })
      .catch((err) => {
        console.error('Failed to load flashcards:', err);
      })
      .finally(() => setLoading(false));
  }, [selectedTopic]);

  // Filtered flashcards based on user rating
  const displayedCards = useMemo(() => {
    if (filterMode === 'review') {
      return flashcards.filter((c) => ratings[c.id] === 'review');
    }
    if (filterMode === 'mastered') {
      return flashcards.filter((c) => ratings[c.id] === 'mastered');
    }
    return flashcards;
  }, [flashcards, filterMode, ratings]);

  const currentCard = displayedCards[currentIndex];

  const handleNext = () => {
    if (currentIndex < displayedCards.length - 1) {
      setIsFlipped(false);
      setShowHint(false);
      setCurrentIndex((prev) => prev + 1);
    } else if (displayedCards.length > 0 && currentIndex === displayedCards.length - 1) {
      fireCelebrationConfetti();
      toast.success('🎉 ยอดเยี่ยม! ทบทวนครบทุกใบในชุดนี้แล้ว');
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setIsFlipped(false);
      setShowHint(false);
      setCurrentIndex((prev) => prev - 1);
    }
  };

  const handleShuffle = () => {
    const shuffled = [...flashcards].sort(() => Math.random() - 0.5);
    setFlashcards(shuffled);
    setCurrentIndex(0);
    setIsFlipped(false);
    setShowHint(false);
    toast.info('สุ่มลำดับการ์ดใหม่แล้ว');
  };

  // Keyboard navigation
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (['INPUT', 'TEXTAREA'].includes((e.target as HTMLElement)?.tagName)) return;

      if (e.code === 'Space' || e.key === 'Enter') {
        e.preventDefault();
        setIsFlipped((f) => !f);
      } else if (e.key === 'ArrowRight') {
        handleNext();
      } else if (e.key === 'ArrowLeft') {
        handlePrev();
      } else if (e.key === '1' && currentCard && isFlipped) {
        updateRating(currentCard.id, 'review');
      } else if (e.key === '2' && currentCard && isFlipped) {
        updateRating(currentCard.id, 'mastered');
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [currentIndex, displayedCards.length, currentCard, isFlipped]);

  const handleBookmark = async () => {
    if (!currentCard) return;
    const isCurrentlyBookmarked = bookmarkIds.has(currentCard.id);
    toggleBookmarkId(currentCard.id);

    try {
      if (isCurrentlyBookmarked) {
        await api.deleteBookmarkByItem('flashcard', currentCard.id);
        toast.info('นำออกจากบุ๊กมาร์กแล้ว');
      } else {
        await api.addBookmark({
          item_type: 'flashcard',
          item_id: currentCard.id,
          notes: `ทบทวนการ์ด: ${currentCard.front_text.slice(0, 40)}`,
        });
        toast.success('บันทึกบุ๊กมาร์กเรียบร้อย');
      }
    } catch (err) {
      console.error(err);
      toggleBookmarkId(currentCard.id);
    }
  };

  const masteredCount = flashcards.filter((c) => ratings[c.id] === 'mastered').length;
  const reviewCount = flashcards.filter((c) => ratings[c.id] === 'review').length;

  return (
    <main className="flex-1 mx-auto w-full max-w-3xl p-4 sm:p-6 lg:p-10">
      <div className="mb-6 pb-4 border-b border-[var(--color-border)]">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
              แฟลชการ์ดทบทวนด่วน
            </h1>
            <p className="font-body text-sm text-[var(--color-text-muted)] mt-1">
              ทบทวนคำสั่งสำคัญ พอร์ตเน็ตเวิร์ก และแนวทางแก้ไขปัญหาหน้างาน (Space เพื่อพลิกการ์ด)
            </p>
          </div>

          <button
            onClick={handleShuffle}
            title="สุ่มลำดับการ์ด"
            className="self-start sm:self-auto inline-flex items-center gap-1.5 px-3 py-1.5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-xs text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface-2)] transition-colors"
          >
            <Shuffle className="h-3.5 w-3.5" />
            <span>สลับการ์ด (Shuffle)</span>
          </button>
        </div>

        {/* Topic Filter Pills */}
        <div className="flex items-center gap-1.5 mt-4 flex-wrap">
          <button
            onClick={() => setSelectedTopic('')}
            className={`px-3 py-1 rounded-md text-xs font-medium border transition-colors ${
              selectedTopic === ''
                ? 'bg-[var(--color-surface-2)] text-[var(--color-accent)] border-[var(--color-accent)] font-semibold'
                : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border-[var(--color-border)] hover:text-[var(--color-text)]'
            }`}
          >
            ทั้งหมด ({flashcards.length})
          </button>
          {topics.map((t) => (
            <button
              key={t.slug}
              onClick={() => setSelectedTopic(t.slug)}
              className={`px-3 py-1 rounded-md text-xs font-medium border transition-colors ${
                selectedTopic === t.slug
                  ? 'bg-[var(--color-surface-2)] text-[var(--color-accent)] border-[var(--color-accent)] font-semibold'
                : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border-[var(--color-border)] hover:text-[var(--color-text)]'
              }`}
            >
              {t.title}
            </button>
          ))}
        </div>

        {/* Spaced Repetition Filter Mode */}
        <div className="flex items-center gap-2 mt-3 pt-3 border-t border-[var(--color-border)] text-xs">
          <span className="text-[var(--color-text-muted)]">คัดกรอง:</span>
          <button
            onClick={() => { setFilterMode('all'); setCurrentIndex(0); }}
            className={`px-2.5 py-0.5 rounded-full border text-[11px] transition-colors ${
              filterMode === 'all'
                ? 'bg-[var(--color-surface-2)] border-[var(--color-accent)] text-[var(--color-accent)] font-medium'
                : 'border-transparent text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
            }`}
          >
            ทั้งหมด ({flashcards.length})
          </button>
          <button
            onClick={() => { setFilterMode('review'); setCurrentIndex(0); }}
            className={`px-2.5 py-0.5 rounded-full border text-[11px] transition-colors ${
              filterMode === 'review'
                ? 'bg-rose-500/10 border-rose-500/40 text-rose-400 font-medium'
                : 'border-transparent text-[var(--color-text-muted)] hover:text-rose-400'
            }`}
          >
            ต้องทบทวน ({reviewCount})
          </button>
          <button
            onClick={() => { setFilterMode('mastered'); setCurrentIndex(0); }}
            className={`px-2.5 py-0.5 rounded-full border text-[11px] transition-colors ${
              filterMode === 'mastered'
                ? 'bg-emerald-500/10 border-emerald-500/40 text-emerald-400 font-medium'
                : 'border-transparent text-[var(--color-text-muted)] hover:text-emerald-400'
            }`}
          >
            จำได้แล้ว ({masteredCount})
          </button>
        </div>
      </div>

      {loading ? (
        <div className="p-12 text-center text-sm text-[var(--color-text-muted)]">
          กำลังโหลดแฟลชการ์ด...
        </div>
      ) : displayedCards.length === 0 ? (
        <div className="p-10 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface)] text-center space-y-3">
          <div className="inline-flex p-3 rounded-full bg-[var(--color-surface-2)] text-[var(--color-text-muted)]">
            <Sparkles className="h-6 w-6 text-amber-400" />
          </div>
          <h3 className="font-heading text-base font-semibold text-[var(--color-text)]">
            {filterMode === 'review' ? 'ไม่มีการ์ดที่ต้องทบทวนในหมวดนี้' : 'ยังไม่มีแฟลชการ์ดในเงื่อนไขนี้'}
          </h3>
          <p className="text-xs text-[var(--color-text-muted)] max-w-sm mx-auto">
            {filterMode === 'review' 
              ? 'ยินดีด้วย! คุณจำการ์ดได้ครบแล้ว หรือลองเลือกแท็บ "ทั้งหมด" เพื่อฝึกซ้ำ' 
              : 'ลองเปลี่ยนหมวดหมู่หรือเลือกแท็บทั้งหมดเพื่อเริ่มทบทวน'}
          </p>
          <button
            onClick={() => { setFilterMode('all'); setCurrentIndex(0); }}
            className="px-3.5 py-1.5 rounded-md bg-[var(--color-surface-2)] text-xs text-[var(--color-accent)] font-medium hover:bg-[var(--color-surface)] border border-[var(--color-border)] transition-colors"
          >
            แสดงการ์ดทั้งหมด
          </button>
        </div>
      ) : (
        <div className="space-y-4">
          {/* Card Counter & Topic */}
          <div className="flex items-center justify-between text-xs text-[var(--color-text-muted)]">
            <span className="font-medium text-[var(--color-accent)]">
              {currentCard.topic_title}
            </span>
            <div className="flex items-center gap-2">
              {ratings[currentCard.id] === 'mastered' && (
                <span className="inline-flex items-center gap-1 text-[11px] text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded-full border border-emerald-500/30">
                  <CheckCircle2 className="h-3 w-3" />
                  <span>จำได้แล้ว</span>
                </span>
              )}
              {ratings[currentCard.id] === 'review' && (
                <span className="inline-flex items-center gap-1 text-[11px] text-rose-400 bg-rose-500/10 px-2 py-0.5 rounded-full border border-rose-500/30">
                  <HelpCircle className="h-3 w-3" />
                  <span>ต้องทบทวน</span>
                </span>
              )}
              <span>
                ใบที่ {currentIndex + 1} จาก {displayedCards.length}
              </span>
            </div>
          </div>

          {/* Card Box */}
          <div
            onClick={() => setIsFlipped(!isFlipped)}
            className="cursor-pointer min-h-[260px] sm:min-h-[300px] p-6 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface)] hover:border-[var(--color-accent)]/40 transition-all flex flex-col justify-between shadow-lg relative overflow-hidden group"
          >
            {/* Top row */}
            <div className="flex items-center justify-between text-xs text-[var(--color-text-muted)]">
              <span className="flex items-center gap-1.5 font-medium">
                <RotateCw className="h-3.5 w-3.5 text-[var(--color-accent)] group-hover:rotate-180 transition-transform duration-300" />
                <span>{isFlipped ? 'เฉลย & คำอธิบาย' : 'คำถาม (กด Space พลิก)'}</span>
              </span>

              <button
                onClick={(e) => {
                  e.stopPropagation();
                  handleBookmark();
                }}
                className={`p-1.5 rounded-md border transition-colors ${
                  bookmarkIds.has(currentCard.id)
                    ? 'bg-amber-400/10 text-amber-400 border-amber-400/30'
                    : 'border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
                }`}
                title="Bookmark การ์ดนี้"
              >
                <Bookmark className={`h-3.5 w-3.5 ${bookmarkIds.has(currentCard.id) ? 'fill-amber-400' : ''}`} />
              </button>
            </div>

            {/* Content text */}
            <div className="my-6 text-center">
              {!isFlipped ? (
                <div>
                  <h2 className="font-heading text-lg sm:text-xl font-semibold text-[var(--color-text)] leading-snug">
                    {currentCard.front_text}
                  </h2>
                  <p className="text-xs text-[var(--color-text-muted)] mt-3">
                    (คลิกที่การ์ด หรือกด Spacebar เพื่อดูเฉลย)
                  </p>
                </div>
              ) : (
                <div className="text-left font-mono text-sm sm:text-base text-[var(--color-text)] whitespace-pre-line leading-relaxed bg-[var(--color-surface-2)] p-4 rounded-lg border border-[var(--color-border)] animate-in fade-in duration-150">
                  {currentCard.back_text}
                </div>
              )}
            </div>

            {/* Hint */}
            {currentCard.hint && (
              <div
                onClick={(e) => {
                  e.stopPropagation();
                  setShowHint(!showHint);
                }}
                className="pt-3 border-t border-[var(--color-border)] text-xs"
              >
                <div className="flex items-center gap-1 text-[var(--color-accent)] font-medium">
                  <Lightbulb className="h-3.5 w-3.5" />
                  <span>{showHint ? 'ซ่อนคำใบ้' : 'คลิกเพื่อดูคำใบ้ (Hint)'}</span>
                </div>
                {showHint && (
                  <p className="text-[var(--color-text-muted)] mt-1.5 pl-4 italic">
                    {currentCard.hint}
                  </p>
                )}
              </div>
            )}
          </div>

          {/* Spaced Repetition Self-Rating Buttons (Appears when flipped) */}
          {isFlipped && (
            <div className="p-3 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)] flex flex-col sm:flex-row items-center justify-between gap-3 animate-in fade-in slide-in-from-top-1 duration-200">
              <span className="text-xs text-[var(--color-text-muted)] font-medium">
                ประเมินความจำของคุณ:
              </span>
              <div className="flex items-center gap-2 w-full sm:w-auto">
                <button
                  onClick={() => updateRating(currentCard.id, 'review')}
                  className="flex-1 sm:flex-initial inline-flex items-center justify-center gap-1.5 px-3.5 py-1.5 rounded-md border border-rose-500/40 bg-rose-500/10 text-rose-400 hover:bg-rose-500/20 text-xs font-semibold transition-colors"
                >
                  <XCircle className="h-3.5 w-3.5" />
                  <span>ยังจำไม่ได้ (กด 1)</span>
                </button>
                <button
                  onClick={() => updateRating(currentCard.id, 'mastered')}
                  className="flex-1 sm:flex-initial inline-flex items-center justify-center gap-1.5 px-3.5 py-1.5 rounded-md border border-emerald-500/40 bg-emerald-500/10 text-emerald-400 hover:bg-emerald-500/20 text-xs font-semibold transition-colors"
                >
                  <CheckCircle2 className="h-3.5 w-3.5" />
                  <span>จำได้แม่น (กด 2)</span>
                </button>
              </div>
            </div>
          )}

          {/* Navigation Controls */}
          <div className="flex items-center justify-between pt-2">
            <button
              onClick={handlePrev}
              disabled={currentIndex === 0}
              className="flex items-center gap-1 px-3 py-2 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text-muted)] hover:text-[var(--color-text)] text-xs font-medium transition-colors disabled:opacity-40"
            >
              <ChevronLeft className="h-4 w-4" />
              <span>การ์ดก่อนหน้า (←)</span>
            </button>

            <button
              onClick={() => setIsFlipped(!isFlipped)}
              className="px-3.5 py-2 rounded-md bg-[var(--color-surface-2)] hover:bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text)] text-xs font-medium transition-colors"
            >
              {isFlipped ? 'ดูคำถาม' : 'พลิกดูเฉลย (Space)'}
            </button>

            <button
              onClick={handleNext}
              disabled={currentIndex === displayedCards.length - 1}
              className="flex items-center gap-1 px-3 py-2 rounded-md bg-[var(--color-accent)] hover:bg-[var(--color-accent-hover)] text-slate-950 text-xs font-semibold transition-colors disabled:opacity-40"
            >
              <span>การ์ดถัดไป (→)</span>
              <ChevronRight className="h-4 w-4" />
            </button>
          </div>
        </div>
      )}
    </main>
  );
}
