'use client';

import React, { useEffect, useState, Suspense } from 'react';
import Link from 'next/link';
import { useSearchParams } from 'next/navigation';
import { 
  Clock, 
  CheckCircle2, 
  XCircle, 
  RotateCcw, 
  ArrowRight, 
  ArrowLeft, 
  AlertTriangle,
} from 'lucide-react';
import { CodeBlock } from '@/components/CodeBlock';
import { useQuizStore } from '@/stores/useQuizStore';
import { Topic } from '@/types';
import { api } from '@/lib/api';
import { fireCelebrationConfetti, fireFireworksConfetti } from '@/lib/confetti';

function QuizContent() {
  const searchParams = useSearchParams();
  const initialTopicSlug = searchParams?.get('topic_slug') || '';

  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string>(initialTopicSlug);
  const [difficulty, setDifficulty] = useState<string>('all');
  const [totalQuestions, setTotalQuestions] = useState<number>(5);
  const [reviewFilter, setReviewFilter] = useState<'all' | 'incorrect' | 'correct'>('all');

  const {
    sessionId,
    topicTitle,
    questions,
    currentIndex,
    selectedAnswers,
    timeSpentSeconds,
    isSubmitting,
    result,
    error,
    startQuiz,
    selectChoice,
    nextQuestion,
    prevQuestion,
    goToQuestion,
    tickTimer,
    submitQuiz,
    resetQuiz,
  } = useQuizStore();

  useEffect(() => {
    api.getTopics().then(setTopics).catch(() => {});
  }, []);

  // Trigger celebration confetti on high score
  useEffect(() => {
    if (result) {
      if (result.percentage === 100) {
        fireFireworksConfetti();
      } else if (result.percentage >= 70) {
        fireCelebrationConfetti();
      }
    }
  }, [result]);

  // Keyboard navigation during Quiz: 1, 2, 3, 4 to choose, Enter to next
  useEffect(() => {
    if (!sessionId || result) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      if (['INPUT', 'TEXTAREA'].includes((e.target as HTMLElement)?.tagName)) return;

      const currentQ = questions[currentIndex];
      if (!currentQ) return;

      if (['1', '2', '3', '4', '5'].includes(e.key)) {
        const choiceIdx = parseInt(e.key, 10) - 1;
        if (currentQ.choices && currentQ.choices[choiceIdx]) {
          selectChoice(currentQ.id, currentQ.choices[choiceIdx].id);
        }
      } else if (e.key === 'Enter') {
        if (currentIndex < questions.length - 1) {
          nextQuestion();
        }
      } else if (e.key === 'ArrowRight' && currentIndex < questions.length - 1) {
        nextQuestion();
      } else if (e.key === 'ArrowLeft' && currentIndex > 0) {
        prevQuestion();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [sessionId, result, questions, currentIndex, selectChoice, nextQuestion, prevQuestion]);

  // Timer interval when test is active
  useEffect(() => {
    if (sessionId && !result) {
      const timer = setInterval(() => {
        tickTimer();
      }, 1000);
      return () => clearInterval(timer);
    }
  }, [sessionId, result, tickTimer]);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const handleStart = () => {
    startQuiz(selectedTopic || undefined, difficulty, totalQuestions);
  };

  return (
    <main className="flex-1 mx-auto w-full max-w-3xl p-4 sm:p-6 lg:p-10">
      {/* State 1: Configuration Screen */}
      {!sessionId && !result && (
        <div className="space-y-6">
          <div className="pb-5 border-b border-[var(--color-border)]">
            <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
              แบบทดสอบความรู้
            </h1>
            <p className="font-body text-sm text-[var(--color-text-muted)] mt-1">
              ทดสอบความเข้าใจกับโจทย์สถานการณ์จริง วิเคราะห์ปัญหา พร้อมเฉลยละเอียด
            </p>
          </div>

          <div className="p-6 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] space-y-6">
            {/* Select Topic */}
            <div>
              <label className="block text-xs font-semibold text-[var(--color-text-muted)] uppercase tracking-wider mb-2">
                หมวดหมู่ที่ต้องการทดสอบ
              </label>
              <select
                value={selectedTopic}
                onChange={(e) => setSelectedTopic(e.target.value)}
                className="w-full rounded-md bg-[var(--color-surface-2)] border border-[var(--color-border)] px-3.5 py-2.5 text-sm text-[var(--color-text)] focus:border-[var(--color-accent)] focus:outline-none"
              >
                <option value="">รวมทุกหมวดหมู่วิชาชีพ</option>
                {topics.map((t) => (
                  <option key={t.slug} value={t.slug}>
                    {t.title}
                  </option>
                ))}
              </select>
            </div>

            {/* Select Difficulty */}
            <div>
              <label className="block text-xs font-semibold text-[var(--color-text-muted)] uppercase tracking-wider mb-2">
                ระดับความยาก
              </label>
              <div className="grid grid-cols-4 gap-2">
                {[
                  { value: 'all', label: 'ทั้งหมด' },
                  { value: 'easy', label: 'Easy' },
                  { value: 'medium', label: 'Medium' },
                  { value: 'hard', label: 'Hard' },
                ].map((d) => (
                  <button
                    key={d.value}
                    type="button"
                    onClick={() => setDifficulty(d.value)}
                    className={`py-2 text-xs font-semibold rounded-md border transition-colors ${
                      difficulty === d.value
                        ? 'bg-[var(--color-surface-2)] text-[var(--color-accent)] border-[var(--color-accent)]'
                        : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border-[var(--color-border)] hover:bg-[var(--color-surface-2)] hover:text-[var(--color-text)]'
                    }`}
                  >
                    {d.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Number of Questions */}
            <div>
              <div className="flex justify-between items-center mb-2">
                <label className="text-xs font-semibold text-[var(--color-text-muted)] uppercase tracking-wider">
                  จำนวนข้อสอบ ({totalQuestions} ข้อ)
                </label>
              </div>
              <input
                type="range"
                min="3"
                max="15"
                step="1"
                value={totalQuestions}
                onChange={(e) => setTotalQuestions(Number(e.target.value))}
                className="w-full accent-[var(--color-accent)] cursor-pointer"
              />
              <div className="flex justify-between text-[11px] text-[var(--color-text-muted)] mt-1">
                <span>3 ข้อ</span>
                <span>5 ข้อ</span>
                <span>10 ข้อ</span>
                <span>15 ข้อ</span>
              </div>
            </div>

            {error && (
              <div className="p-3 rounded-md bg-rose-500/10 border border-rose-500/30 text-rose-300 text-xs flex items-center gap-2">
                <AlertTriangle className="h-4 w-4 shrink-0" />
                <span>{error}</span>
              </div>
            )}

            <button
              onClick={handleStart}
              disabled={isSubmitting}
              className="w-full py-2.5 px-4 rounded-md bg-[var(--color-accent)] hover:bg-[var(--color-accent-hover)] text-slate-950 font-medium text-sm transition-colors disabled:opacity-50"
            >
              {isSubmitting ? 'กำลังเตรียมข้อสอบ...' : 'เริ่มทำแบบทดสอบ'}
            </button>
          </div>
        </div>
      )}

      {/* State 2: Active Test Runner */}
      {sessionId && !result && questions.length > 0 && (
        <div className="space-y-6">
          {/* Top Bar: Progress & Timer */}
          <div className="flex items-center justify-between pb-3 border-b border-[var(--color-border)]">
            <div>
              <span className="text-xs text-[var(--color-accent)] font-medium">
                {topicTitle}
              </span>
              <div className="font-heading text-sm font-semibold text-[var(--color-text)]">
                ข้อที่ {currentIndex + 1} จาก {questions.length}
              </div>
            </div>

            <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-[var(--color-surface)] border border-[var(--color-border)] text-xs font-mono text-[var(--color-text)]">
              <Clock className="h-3.5 w-3.5 text-[var(--color-text-muted)]" />
              <span>{formatTime(timeSpentSeconds)}</span>
            </div>
          </div>

          {/* Progress Bar */}
          <div className="w-full h-1 bg-[var(--color-surface-2)] rounded-full overflow-hidden">
            <div
              className="h-full bg-[var(--color-accent)] transition-all duration-300"
              style={{ width: `${((currentIndex + 1) / questions.length) * 100}%` }}
            />
          </div>

          {/* Current Question Card */}
          {(() => {
            const currentQ = questions[currentIndex];
            if (!currentQ) return null;

            return (
              <div className="p-5 sm:p-6 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] space-y-5">
                {/* Difficulty & Tags */}
                <div className="flex items-center gap-2 flex-wrap text-xs">
                  <span className="uppercase text-[11px] font-medium px-2 py-0.5 rounded bg-[var(--color-surface-2)] text-[var(--color-text-muted)] border border-[var(--color-border)]">
                    {currentQ.difficulty}
                  </span>
                  {currentQ.tags && currentQ.tags.map((tag) => (
                    <span key={tag} className="text-[11px] font-mono text-[var(--color-text-muted)]">
                      #{tag}
                    </span>
                  ))}
                </div>

                {/* Question Text */}
                <h2 className="font-heading text-base sm:text-lg font-semibold text-[var(--color-text)] leading-snug">
                  {currentQ.question_text}
                </h2>

                {/* Scenario text (Code / Terminal output) */}
                {currentQ.scenario_text && (
                  <CodeBlock language="terminal / log" code={currentQ.scenario_text} />
                )}

                {/* Choices list */}
                <div className="space-y-2 pt-1">
                  {currentQ.choices.map((choice, cIdx) => {
                    const isSelected = selectedAnswers[currentQ.id] === choice.id;
                    const choiceLabels = ['A', 'B', 'C', 'D', 'E'];

                    return (
                      <button
                        key={choice.id}
                        onClick={() => selectChoice(currentQ.id, choice.id)}
                        className={`w-full flex items-start gap-3 p-3 rounded-md border text-left transition-colors ${
                          isSelected
                            ? 'border-2 border-[var(--color-accent)] bg-[rgba(34,211,238,0.08)] text-[var(--color-text)] font-medium'
                            : 'border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text)] hover:bg-[var(--color-surface)]'
                        }`}
                      >
                        <span
                          className={`flex h-5 w-5 shrink-0 items-center justify-center rounded text-xs font-semibold ${
                            isSelected
                              ? 'bg-[var(--color-accent)] text-slate-950'
                              : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border border-[var(--color-border)]'
                          }`}
                        >
                          {choiceLabels[cIdx] || cIdx + 1}
                        </span>
                        <span className="font-body text-xs sm:text-sm leading-relaxed pt-0.5">
                          {choice.choice_text}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>
            );
          })()}

          {/* Bottom Actions */}
          <div className="flex items-center justify-between pt-2">
            <button
              onClick={prevQuestion}
              disabled={currentIndex === 0}
              className="flex items-center gap-1.5 px-3 py-2 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text-muted)] hover:text-[var(--color-text)] text-xs font-medium transition-colors disabled:opacity-40"
            >
              <ArrowLeft className="h-3.5 w-3.5" />
              <span>ข้อย้อนหลัง</span>
            </button>

            {currentIndex < questions.length - 1 ? (
              <button
                onClick={nextQuestion}
                className="flex items-center gap-1.5 px-4 py-2 rounded-md bg-[var(--color-surface-2)] hover:bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text)] text-xs font-medium transition-colors"
              >
                <span>ข้อถัดไป</span>
                <ArrowRight className="h-3.5 w-3.5" />
              </button>
            ) : (
              <button
                onClick={submitQuiz}
                disabled={isSubmitting}
                className="flex items-center gap-1.5 px-5 py-2 rounded-md bg-[var(--color-accent)] hover:bg-[var(--color-accent-hover)] text-slate-950 text-xs font-medium transition-colors"
              >
                <span>ส่งคำตอบตรวจผล</span>
                <CheckCircle2 className="h-3.5 w-3.5" />
              </button>
            )}
          </div>

          {/* Question Quick Jump Grid */}
          <div className="pt-4 border-t border-[var(--color-border)]">
            <div className="text-xs text-[var(--color-text-muted)] mb-2">ทางลัดข้อสอบ:</div>
            <div className="flex flex-wrap gap-1.5">
              {questions.map((q, idx) => {
                const isAnswered = !!selectedAnswers[q.id];
                const isCurrent = idx === currentIndex;
                return (
                  <button
                    key={q.id}
                    onClick={() => goToQuestion(idx)}
                    className={`h-7 w-7 rounded text-xs font-semibold transition-colors ${
                      isCurrent
                        ? 'bg-[var(--color-accent)] text-slate-950 font-bold'
                        : isAnswered
                        ? 'bg-[var(--color-surface-2)] text-[var(--color-text)] border border-[var(--color-border)]'
                        : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border border-[var(--color-border)] hover:text-[var(--color-text)]'
                    }`}
                  >
                    {idx + 1}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* State 3: Result & Scorecard */}
      {result && (
        <div className="space-y-8">
          {/* Scorecard Hero */}
          <div className="p-6 sm:p-8 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-center">
            <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)] mb-2">
              ผลการทดสอบ
            </h1>

            <div className="my-5">
              <span className="font-heading text-4xl sm:text-5xl font-bold text-[var(--color-accent)]">
                {result.score}/{result.total_questions}
              </span>
              <div className="text-xs text-[var(--color-text-muted)] mt-1">
                คิดเป็น {result.percentage}% (ใช้เวลา {formatTime(result.time_spent_seconds)})
              </div>
            </div>

            <p className="font-body text-xs sm:text-sm text-[var(--color-text-muted)] max-w-md mx-auto mb-6">
              {result.percentage >= 80
                ? 'ยอดเยี่ยมมาก! คุณมีความเข้าใจในระบบและวิธีคิดแบบ Support อย่างถ่องแท้'
                : result.percentage >= 50
                ? 'ทำได้ดี! ทบทวนข้อที่พลาดและอ่านคำอธิบาย Root Cause ด้านล่างเพื่อพัฒนาต่อ'
                : 'ทบทวนคำอธิบายเฉลยและเปิดอ่านบทเรียนเพิ่มเติมเพื่อเสริมความเข้าใจ'}
            </p>

            <button
              onClick={resetQuiz}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-md bg-[var(--color-accent)] hover:bg-[var(--color-accent-hover)] text-slate-950 font-medium text-sm transition-colors"
            >
              <RotateCcw className="h-4 w-4" />
              <span>ทำแบบทดสอบใหม่อีกครั้ง</span>
            </button>
          </div>

          {/* Detailed Review Breakdown */}
          <div className="space-y-5">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <h2 className="font-heading text-lg font-semibold text-[var(--color-text)]">
                เฉลยและคำอธิบายละเอียด
              </h2>

              {/* Review Filter Tabs */}
              <div className="flex items-center gap-1.5 text-xs">
                <button
                  onClick={() => setReviewFilter('all')}
                  className={`px-3 py-1 rounded-md border transition-colors ${
                    reviewFilter === 'all'
                      ? 'bg-[var(--color-surface-2)] text-[var(--color-accent)] border-[var(--color-accent)] font-semibold'
                      : 'border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
                  }`}
                >
                  ทั้งหมด ({result.evaluated_questions.length})
                </button>
                <button
                  onClick={() => setReviewFilter('incorrect')}
                  className={`px-3 py-1 rounded-md border transition-colors ${
                    reviewFilter === 'incorrect'
                      ? 'bg-rose-500/10 text-rose-400 border-rose-500/40 font-semibold'
                      : 'border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-rose-400'
                  }`}
                >
                  เฉพาะข้อที่ตอบผิด ({result.evaluated_questions.filter((q) => !q.is_correct).length})
                </button>
                <button
                  onClick={() => setReviewFilter('correct')}
                  className={`px-3 py-1 rounded-md border transition-colors ${
                    reviewFilter === 'correct'
                      ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/40 font-semibold'
                      : 'border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-emerald-400'
                  }`}
                >
                  เฉพาะข้อที่ตอบถูก ({result.evaluated_questions.filter((q) => q.is_correct).length})
                </button>
              </div>
            </div>

            {result.evaluated_questions
              .filter((q) => {
                if (reviewFilter === 'incorrect') return !q.is_correct;
                if (reviewFilter === 'correct') return q.is_correct;
                return true;
              })
              .map((q, idx) => (
              <div
                key={q.question_id}
                className={`p-5 rounded-md border transition-colors ${
                  q.is_correct
                    ? 'border-emerald-500/40 bg-emerald-500/5'
                    : 'border-rose-500/40 bg-rose-500/5'
                }`}
              >
                {/* Status Indicator */}
                <div className="flex items-center gap-2 mb-2 text-xs">
                  {q.is_correct ? (
                    <span className="inline-flex items-center gap-1 font-semibold text-emerald-400">
                      <CheckCircle2 className="h-3.5 w-3.5" />
                      <span>ตอบถูกต้อง</span>
                    </span>
                  ) : (
                    <span className="inline-flex items-center gap-1 font-semibold text-rose-400">
                      <XCircle className="h-3.5 w-3.5" />
                      <span>ตอบผิด</span>
                    </span>
                  )}
                  <span className="text-[var(--color-text-muted)]">· ข้อ {idx + 1}</span>
                </div>

                <h3 className="font-heading text-sm sm:text-base font-semibold text-[var(--color-text)] mb-3">
                  {q.question_text}
                </h3>

                {/* Scenario text if present */}
                {q.scenario_text && (
                  <CodeBlock language="incident log" code={q.scenario_text} />
                )}

                {/* Choices comparison */}
                <div className="space-y-1.5 my-3">
                  {q.all_choices.map((c) => {
                    const isCorrect = c.is_correct;
                    const isUserSelected = q.selected_choice?.id === c.id;

                    let choiceClass = 'border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text-muted)]';
                    if (isCorrect) {
                      choiceClass = 'border-emerald-500/60 bg-emerald-500/10 text-emerald-300 font-medium';
                    } else if (isUserSelected && !isCorrect) {
                      choiceClass = 'border-rose-500/60 bg-rose-500/10 text-rose-300 line-through';
                    }

                    return (
                      <div
                        key={c.id}
                        className={`flex items-start gap-2.5 p-2.5 rounded-md border text-xs sm:text-sm ${choiceClass}`}
                      >
                        <div className="pt-0.5 shrink-0">
                          {isCorrect && <CheckCircle2 className="h-3.5 w-3.5 text-emerald-400" />}
                          {isUserSelected && !isCorrect && <XCircle className="h-3.5 w-3.5 text-rose-400" />}
                          {!isCorrect && !isUserSelected && <span className="h-1.5 w-1.5 rounded-full bg-[var(--color-border)] inline-block ml-1" />}
                        </div>
                        <span>{c.choice_text}</span>
                      </div>
                    );
                  })}
                </div>

                {/* Root Cause / Explanation Box */}
                <div className="mt-3 p-3.5 rounded-md border border-[var(--color-border)] bg-[var(--color-surface)] text-xs text-[var(--color-text-muted)] leading-relaxed">
                  <div className="font-semibold text-[var(--color-text)] mb-1">
                    คำอธิบายเฉลย:
                  </div>
                  <div className="whitespace-pre-line text-[var(--color-text)]">
                    {q.explanation}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </main>
  );
}

export default function QuizPage() {
  return (
    <Suspense
      fallback={
        <div className="flex-1 flex items-center justify-center p-12 text-[var(--color-text-muted)]">
          กำลังโหลดแบบทดสอบ...
        </div>
      }
    >
      <QuizContent />
    </Suspense>
  );
}
