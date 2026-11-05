import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class ProgressService {
  constructor(private readonly db: DatabaseService) {}

  async getAll() {
    const res = await this.db.query(`
      SELECT lesson_id, completed_at
      FROM lesson_progress
      ORDER BY completed_at DESC;
    `);
    return {
      completed_lesson_ids: res.rows.map((r) => r.lesson_id),
      total_completed: res.rowCount || 0,
    };
  }

  async markComplete(lessonId: string) {
    const progressSql = `
      INSERT INTO lesson_progress (lesson_id)
      VALUES ($1)
      ON CONFLICT (lesson_id) DO UPDATE SET completed_at = CURRENT_TIMESTAMP
      RETURNING *;
    `;
    const res = await this.db.query(progressSql, [lessonId]);

    // Log study activity for streak calculation
    await this.db.query(
      `INSERT INTO study_activity (activity_type, item_id) VALUES ('lesson', $1);`,
      [lessonId]
    );

    return {
      success: true,
      lesson_id: lessonId,
      completed: true,
      completed_at: res.rows[0]?.completed_at || new Date().toISOString(),
    };
  }

  async unmarkComplete(lessonId: string) {
    await this.db.query(
      `DELETE FROM lesson_progress WHERE lesson_id = $1;`,
      [lessonId]
    );

    return {
      success: true,
      lesson_id: lessonId,
      completed: false,
    };
  }
}
