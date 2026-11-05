import { create } from 'zustand';
import { Question, QuizResult } from '@/types';
import { api } from '@/lib/api';
import { useAppStore } from './useAppStore';

interface QuizState {
  sessionId: string | null;
  topicTitle: string;
  questions: Question[];
  currentIndex: number;
  selectedAnswers: Record<string, string>; // question_id -> choice_id
  timeSpentSeconds: number;
  isSubmitting: boolean;
  result: QuizResult | null;
  error: string | null;

  // Actions
  startQuiz: (topicSlug?: string, difficulty?: string, totalQuestions?: number) => Promise<void>;
  selectChoice: (questionId: string, choiceId: string) => void;
  nextQuestion: () => void;
  prevQuestion: () => void;
  goToQuestion: (index: number) => void;
  tickTimer: () => void;
  submitQuiz: () => Promise<void>;
  resetQuiz: () => void;
}

export const useQuizStore = create<QuizState>((set, get) => ({
  sessionId: null,
  topicTitle: '',
  questions: [],
  currentIndex: 0,
  selectedAnswers: {},
  timeSpentSeconds: 0,
  isSubmitting: false,
  result: null,
  error: null,

  startQuiz: async (topicSlug, difficulty = 'all', totalQuestions = 5) => {
    set({ isSubmitting: true, error: null, result: null, selectedAnswers: {}, currentIndex: 0, timeSpentSeconds: 0 });
    try {
      const session = await api.startQuiz({
        topic_slug: topicSlug,
        difficulty,
        total_questions: totalQuestions,
      });
      set({
        sessionId: session.session_id,
        topicTitle: session.topic_title || 'แบบทดสอบรวมทุกหมวด',
        questions: session.questions,
        isSubmitting: false,
      });
    } catch (err: any) {
      set({ error: err.message || 'ไม่สามารถเริ่มทำข้อสอบได้ กรุณาตรวจสอบ Backend API', isSubmitting: false });
    }
  },

  selectChoice: (questionId: string, choiceId: string) => {
    set((state) => ({
      selectedAnswers: {
        ...state.selectedAnswers,
        [questionId]: choiceId,
      },
    }));
  },

  nextQuestion: () => {
    const { currentIndex, questions } = get();
    if (currentIndex < questions.length - 1) {
      set({ currentIndex: currentIndex + 1 });
    }
  },

  prevQuestion: () => {
    const { currentIndex } = get();
    if (currentIndex > 0) {
      set({ currentIndex: currentIndex - 1 });
    }
  },

  goToQuestion: (index: number) => {
    set({ currentIndex: index });
  },

  tickTimer: () => {
    set((state) => ({ timeSpentSeconds: state.timeSpentSeconds + 1 }));
  },

  submitQuiz: async () => {
    const { sessionId, questions, selectedAnswers, timeSpentSeconds } = get();
    if (!sessionId) return;

    set({ isSubmitting: true, error: null });
    try {
      const answersPayload = questions.map((q) => ({
        question_id: q.id,
        selected_choice_id: selectedAnswers[q.id] || undefined,
      }));

      const result = await api.submitQuiz(sessionId, {
        answers: answersPayload,
        time_spent_seconds: timeSpentSeconds,
      });

      set({ result, isSubmitting: false });

      // Refresh real-time Streak badge in Navbar
      api.getStreakSummary().then((s) => {
        if (s) useAppStore.getState().setStreakInfo(s.current_streak, s.studied_today);
      }).catch(() => {});
    } catch (err: any) {
      set({ error: err.message || 'ส่งคำตอบล้มเหลว', isSubmitting: false });
    }
  },

  resetQuiz: () => {
    set({
      sessionId: null,
      questions: [],
      currentIndex: 0,
      selectedAnswers: {},
      timeSpentSeconds: 0,
      result: null,
      error: null,
    });
  },
}));
