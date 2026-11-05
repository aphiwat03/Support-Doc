export interface Topic {
  id: number;
  slug: string;
  title: string;
  description: string;
  icon: string;
  color: string;
  display_order: number;
  lessons_count?: number;
  questions_count?: number;
  flashcards_count?: number;
}

export interface Lesson {
  id: string;
  topic_id: number;
  topic_slug?: string;
  topic_title?: string;
  slug: string;
  title: string;
  summary: string;
  content_md?: string;
  read_time_minutes: number;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  display_order: number;
  created_at?: string;
  prev_lesson?: { id: string; slug: string; title: string } | null;
  next_lesson?: { id: string; slug: string; title: string } | null;
  topic_lessons?: Array<{ id: string; slug: string; title: string; read_time_minutes: number }>;
}

export interface Choice {
  id: string;
  question_id: string;
  choice_text: string;
  is_correct?: boolean;
  explanation?: string;
  display_order: number;
}

export interface Question {
  id: string;
  topic_id: number;
  topic_slug?: string;
  topic_title?: string;
  lesson_id?: string;
  lesson_title?: string;
  question_text: string;
  scenario_text?: string;
  difficulty: 'easy' | 'medium' | 'hard';
  question_type: 'multiple_choice' | 'scenario' | 'true_false';
  explanation?: string;
  tags?: string[];
  choices: Choice[];
}

export interface Flashcard {
  id: string;
  topic_id: number;
  topic_slug?: string;
  topic_title?: string;
  lesson_id?: string;
  lesson_title?: string;
  front_text: string;
  back_text: string;
  hint?: string;
  display_order: number;
}

export interface QuizSession {
  session_id: string;
  topic_id?: number;
  topic_title?: string;
  difficulty: string;
  total_questions: number;
  questions: Question[];
}

export interface EvaluatedQuestion {
  question_id: string;
  question_text: string;
  scenario_text?: string;
  difficulty: string;
  topic_title: string;
  explanation: string;
  tags?: string[];
  is_correct: boolean;
  selected_choice?: Choice | null;
  correct_choice?: Choice | null;
  all_choices: Choice[];
}

export interface QuizResult {
  session_id: string;
  score: number;
  total_questions: number;
  percentage: number;
  time_spent_seconds: number;
  is_completed: boolean;
  evaluated_questions: EvaluatedQuestion[];
}

export interface Bookmark {
  id: string;
  item_type: 'question' | 'lesson' | 'flashcard';
  item_id: string;
  notes?: string;
  created_at: string;
  item_details?: any;
}
