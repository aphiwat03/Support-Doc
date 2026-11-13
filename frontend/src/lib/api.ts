import { Topic, Lesson, Question, Flashcard, QuizSession, QuizResult } from '@/types';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000';

async function fetchJson<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const url = `${API_BASE_URL}/api${endpoint.startsWith('/') ? endpoint : `/${endpoint}`}`;
  try {
    const res = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!res.ok) {
      const errorBody = await res.json().catch(() => ({}));
      throw new Error(errorBody.message || `API error: ${res.status} ${res.statusText}`);
    }

    return await res.json();
  } catch (err: any) {
    console.error(`Fetch error at ${endpoint}:`, err);
    throw err;
  }
}

export const api = {
  // Topics
  getTopics: () => fetchJson<Topic[]>('/topics'),
  getTopicBySlug: (slug: string) => fetchJson<Topic & { lessons: Lesson[] }>(`/topics/${slug}`),

  // Lessons
  getLessons: (topicSlug?: string) => fetchJson<Lesson[]>(`/lessons${topicSlug ? `?topic_slug=${topicSlug}` : ''}`),
  getLessonById: (id: string) => fetchJson<Lesson>(`/lessons/${id}`),
  getLessonBySlug: (topicSlug: string, lessonSlug: string) =>
    fetchJson<Lesson>(`/lessons/by-slug/${topicSlug}/${lessonSlug}`),

  // Questions
  getQuestions: (params?: { topic_slug?: string; difficulty?: string; search?: string }) => {
    const query = new URLSearchParams();
    if (params?.topic_slug) query.set('topic_slug', params.topic_slug);
    if (params?.difficulty) query.set('difficulty', params.difficulty);
    if (params?.search) query.set('search', params.search);
    return fetchJson<Question[]>(`/questions?${query.toString()}`);
  },
  getRandomQuestions: (params?: { topic_slug?: string; difficulty?: string; limit?: number }) => {
    const query = new URLSearchParams();
    if (params?.topic_slug) query.set('topic_slug', params.topic_slug);
    if (params?.difficulty) query.set('difficulty', params.difficulty);
    if (params?.limit) query.set('limit', params.limit.toString());
    return fetchJson<Question[]>(`/questions/random?${query.toString()}`);
  },

  // Quiz Engine
  startQuiz: (body: { topic_slug?: string; difficulty?: string; total_questions?: number }) =>
    fetchJson<QuizSession>('/quiz/start', {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  submitQuiz: (sessionId: string, body: { answers: Array<{ question_id: string; selected_choice_id?: string }>; time_spent_seconds?: number }) =>
    fetchJson<QuizResult>(`/quiz/${sessionId}/submit`, {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  getQuizResult: (sessionId: string) => fetchJson<QuizResult>(`/quiz/${sessionId}`),

  // Flashcards
  getFlashcards: (topicSlug?: string) => fetchJson<Flashcard[]>(`/flashcards${topicSlug ? `?topic_slug=${topicSlug}` : ''}`),

  // Progress Tracking
  getProgress: () =>
    fetchJson<{ completed_lesson_ids: string[]; total_completed: number }>('/progress'),
  markLessonComplete: (lessonId: string) =>
    fetchJson<{ success: boolean; lesson_id: string; completed: boolean }>(`/progress/${lessonId}`, {
      method: 'POST',
    }),
  unmarkLessonComplete: (lessonId: string) =>
    fetchJson<{ success: boolean; lesson_id: string; completed: boolean }>(`/progress/${lessonId}`, {
      method: 'DELETE',
    }),

  // Streak & Study Activity
  getStreakSummary: () =>
    fetchJson<{
      current_streak: number;
      longest_streak: number;
      studied_today: boolean;
      total_study_days: number;
    }>('/streak/summary'),
  getStreakActivity: (days: number = 30) =>
    fetchJson<
      Array<{
        date: string;
        count: number;
        lessons: number;
        quizzes: number;
        flashcards: number;
      }>
    >(`/streak/activity?days=${days}`),
  getTopicProgress: () =>
    fetchJson<
      Array<{
        id: number;
        slug: string;
        title: string;
        icon: string;
        color: string;
        total_lessons: number;
        completed_lessons: number;
        percentage: number;
      }>
    >('/streak/progress'),
  recordStudyActivity: (body: { activity_type: 'lesson' | 'quiz' | 'flashcard'; item_id?: string }) =>
    fetchJson('/streak/activity', {
      method: 'POST',
      body: JSON.stringify(body),
    }),
};
