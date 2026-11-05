import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class StreakService {
  constructor(private readonly db: DatabaseService) {}

  async getSummary() {
    const streakSql = `
      WITH days AS (
        SELECT DISTINCT activity_date AS d FROM study_activity
      ),
      grp AS (
        SELECT d, d - (ROW_NUMBER() OVER (ORDER BY d))::int AS g FROM days
      ),
      streaks AS (
        SELECT MIN(d) AS start_date, MAX(d) AS end_date, COUNT(*) AS len
        FROM grp GROUP BY g
      )
      SELECT
        COALESCE((SELECT len FROM streaks
                  WHERE end_date >= (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date - 1
                  ORDER BY end_date DESC LIMIT 1), 0)::int AS current_streak,
        COALESCE((SELECT MAX(len) FROM streaks), 0)::int AS longest_streak,
        EXISTS (
          SELECT 1 FROM study_activity 
          WHERE activity_date = (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date
        ) AS studied_today,
        (SELECT COUNT(DISTINCT activity_date) FROM study_activity)::int AS total_study_days;
    `;

    try {
      const res = await this.db.query(streakSql);
      const row = res.rows[0] || {};
      return {
        current_streak: row.current_streak || 0,
        longest_streak: row.longest_streak || 0,
        studied_today: !!row.studied_today,
        total_study_days: row.total_study_days || 0,
      };
    } catch (err: any) {
      // Return safe defaults if DB table is empty or offline
      return {
        current_streak: 0,
        longest_streak: 0,
        studied_today: false,
        total_study_days: 0,
      };
    }
  }

  async getActivity(days: number = 30) {
    const clampedDays = Math.min(Math.max(days, 7), 365);
    const sql = `
      SELECT 
        activity_date::text AS date,
        COUNT(*)::int AS count,
        COUNT(CASE WHEN activity_type = 'lesson' THEN 1 END)::int AS lessons,
        COUNT(CASE WHEN activity_type = 'quiz' THEN 1 END)::int AS quizzes,
        COUNT(CASE WHEN activity_type = 'flashcard' THEN 1 END)::int AS flashcards
      FROM study_activity
      WHERE activity_date >= (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date - ($1 || ' days')::interval
      GROUP BY activity_date
      ORDER BY activity_date ASC;
    `;

    try {
      const res = await this.db.query(sql, [clampedDays]);
      return res.rows;
    } catch (err) {
      return [];
    }
  }

  async getTopicProgress() {
    const sql = `
      SELECT 
        t.id, t.slug, t.title, t.icon, t.color,
        COUNT(l.id)::int AS total_lessons,
        COUNT(lp.lesson_id)::int AS completed_lessons,
        COALESCE(ROUND((COUNT(lp.lesson_id)::numeric / NULLIF(COUNT(l.id), 0)) * 100, 1)::float, 0) AS percentage
      FROM topics t
      LEFT JOIN lessons l ON t.id = l.topic_id
      LEFT JOIN lesson_progress lp ON l.id = lp.lesson_id
      GROUP BY t.id, t.slug, t.title, t.icon, t.color, t.display_order
      ORDER BY t.display_order ASC;
    `;

    try {
      const res = await this.db.query(sql);
      return res.rows;
    } catch (err) {
      return [];
    }
  }

  async recordActivity(activityType: 'lesson' | 'quiz' | 'flashcard', itemId?: string) {
    const sql = `
      INSERT INTO study_activity (activity_type, item_id)
      VALUES ($1, $2)
      RETURNING *;
    `;
    const res = await this.db.query(sql, [activityType, itemId || null]);
    return res.rows[0];
  }
}
