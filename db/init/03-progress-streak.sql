-- ====================================================================
-- Migration: Add lesson_progress and study_activity for Streak & Progress
-- ====================================================================

CREATE TABLE IF NOT EXISTS lesson_progress (
    lesson_id UUID PRIMARY KEY REFERENCES lessons(id) ON DELETE CASCADE,
    completed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS study_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_type VARCHAR(20) NOT NULL 
        CONSTRAINT ck_activity_type CHECK (activity_type IN ('lesson', 'quiz', 'flashcard')),
    item_id UUID,
    activity_date DATE NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_lesson_progress_completed ON lesson_progress(completed_at);
CREATE INDEX IF NOT EXISTS idx_study_activity_date ON study_activity(activity_date);
