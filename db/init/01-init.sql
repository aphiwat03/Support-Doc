-- ====================================================================
-- Database Schema for Support Knowledge Review Application
-- Raw PostgreSQL DDL (No ORM) - Enhanced with Natural Keys & Integrity
-- ====================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Drop existing tables in reverse dependency order if resetting
DROP TABLE IF EXISTS study_activity CASCADE;
DROP TABLE IF EXISTS lesson_progress CASCADE;
DROP TABLE IF EXISTS bookmarks CASCADE;
DROP TABLE IF EXISTS quiz_session_answers CASCADE;
DROP TABLE IF EXISTS quiz_sessions CASCADE;
DROP TABLE IF EXISTS flashcards CASCADE;
DROP TABLE IF EXISTS choices CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS topics CASCADE;

-- --------------------------------------------------------------------
-- 1. TOPICS (หมวดหมู่หลัก)
-- --------------------------------------------------------------------
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50) DEFAULT 'Terminal',
    color VARCHAR(50) DEFAULT 'from-blue-500 to-indigo-600',
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- 2. LESSONS (บทเรียนเนื้อหาสำหรับอ่านทบทวน)
-- --------------------------------------------------------------------
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id INT NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    slug VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    summary TEXT,
    content_md TEXT NOT NULL,
    read_time_minutes INT DEFAULT 5,
    difficulty VARCHAR(20) DEFAULT 'beginner' 
        CONSTRAINT ck_lessons_difficulty CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_topic_lesson_slug UNIQUE (topic_id, slug)
);

-- --------------------------------------------------------------------
-- 3. QUESTIONS (คลังโจทย์คำถาม - มี seed_key ป้องกันข้อมูลซ้ำ)
-- --------------------------------------------------------------------
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seed_key VARCHAR(120) UNIQUE, -- Natural key สำหรับ idempotent seeding เช่น 'linux:permissions:q01'
    topic_id INT NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
    question_text TEXT NOT NULL,
    scenario_text TEXT, -- สำหรับโจทย์สถานการณ์ปัญหาจริง หรือ Log output
    difficulty VARCHAR(20) NOT NULL DEFAULT 'medium'
        CONSTRAINT ck_questions_difficulty CHECK (difficulty IN ('easy', 'medium', 'hard')),
    question_type VARCHAR(30) NOT NULL DEFAULT 'multiple_choice'
        CONSTRAINT ck_questions_type CHECK (question_type IN ('multiple_choice', 'scenario', 'true_false')),
    explanation TEXT NOT NULL, -- คำอธิบายเฉลยละเอียดและเหตุผลวิเคราะห์สำหรับ Support
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- 4. CHOICES (ตัวเลือกคำตอบ)
-- --------------------------------------------------------------------
CREATE TABLE choices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    choice_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    explanation TEXT, -- คำอธิบายเฉพาะตัวเลือกนี้
    display_order INT DEFAULT 0
);

-- ป้องกันไม่ให้ 1 ข้อสอบมีคำตอบที่ถูกเกิน 1 ข้อ (สำหรับข้อสอบแบบ Single-Choice)
CREATE UNIQUE INDEX uq_choices_one_correct 
    ON choices(question_id) WHERE is_correct;

-- --------------------------------------------------------------------
-- 5. FLASHCARDS (การ์ดทบทวนความรู้ด่วน - มี seed_key ป้องกันข้อมูลซ้ำ)
-- --------------------------------------------------------------------
CREATE TABLE flashcards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seed_key VARCHAR(120) UNIQUE, -- Natural key สำหรับ idempotent seeding เช่น 'linux:fc:ss-listen'
    topic_id INT NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
    front_text TEXT NOT NULL, -- คำถาม / คำสั่ง / ปัญหา
    back_text TEXT NOT NULL,  -- คำตอบ / ไวยากรณ์ / วิธีแก้ไข
    hint TEXT,
    display_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- 6. QUIZ SESSIONS (ประวัติรอบการทำข้อสอบ)
-- --------------------------------------------------------------------
CREATE TABLE quiz_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id INT REFERENCES topics(id) ON DELETE SET NULL,
    difficulty VARCHAR(20) DEFAULT 'all',
    total_questions INT NOT NULL,
    score INT DEFAULT 0,
    percentage NUMERIC(5, 2) DEFAULT 0.00,
    time_spent_seconds INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ
);

-- --------------------------------------------------------------------
-- 7. QUIZ SESSION ANSWERS (บันทึกคำตอบแต่ละข้อในรอบสอบ)
-- --------------------------------------------------------------------
CREATE TABLE quiz_session_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES quiz_sessions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    selected_choice_id UUID REFERENCES choices(id) ON DELETE SET NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- 8. BOOKMARKS (บุ๊กมาร์กสำหรับทบทวน)
-- --------------------------------------------------------------------
CREATE TABLE bookmarks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_type VARCHAR(20) NOT NULL 
        CONSTRAINT ck_bookmarks_type CHECK (item_type IN ('question', 'lesson', 'flashcard')),
    item_id UUID NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_bookmarks_item UNIQUE (item_type, item_id)
);

-- --------------------------------------------------------------------
-- 9. LESSON PROGRESS (ความคืบหน้าการอ่านบทเรียน)
-- --------------------------------------------------------------------
CREATE TABLE lesson_progress (
    lesson_id UUID PRIMARY KEY REFERENCES lessons(id) ON DELETE CASCADE,
    completed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- 10. STUDY ACTIVITY & STREAK (บันทึกกิจกรรมการเรียนรู้รายวัน)
-- --------------------------------------------------------------------
CREATE TABLE study_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_type VARCHAR(20) NOT NULL 
        CONSTRAINT ck_activity_type CHECK (activity_type IN ('lesson', 'quiz', 'flashcard')),
    item_id UUID,
    activity_date DATE NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- INDEXES สำหรับเร่งความเร็ว Query (Performance Tuning)
-- --------------------------------------------------------------------
CREATE INDEX idx_topics_slug ON topics(slug);
CREATE INDEX idx_lessons_topic_order ON lessons(topic_id, display_order);
CREATE INDEX idx_questions_topic_diff ON questions(topic_id, difficulty);
CREATE INDEX idx_questions_lesson ON questions(lesson_id);
CREATE INDEX idx_questions_tags ON questions USING GIN(tags);
CREATE INDEX idx_choices_question ON choices(question_id);
CREATE INDEX idx_flashcards_topic ON flashcards(topic_id);
CREATE INDEX idx_flashcards_lesson ON flashcards(lesson_id);
CREATE INDEX idx_quiz_sessions_topic ON quiz_sessions(topic_id);
CREATE INDEX idx_quiz_answers_session ON quiz_session_answers(session_id);
CREATE INDEX idx_quiz_answers_question ON quiz_session_answers(question_id);
CREATE INDEX idx_lesson_progress_completed ON lesson_progress(completed_at);
CREATE INDEX idx_study_activity_date ON study_activity(activity_date);
