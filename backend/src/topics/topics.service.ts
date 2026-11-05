import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class TopicsService {
  constructor(private readonly db: DatabaseService) {}

  async findAll() {
    const sql = `
      SELECT 
        t.id,
        t.slug,
        t.title,
        t.description,
        t.icon,
        t.color,
        t.display_order,
        COUNT(DISTINCT l.id)::int AS lessons_count,
        COUNT(DISTINCT q.id)::int AS questions_count,
        COUNT(DISTINCT f.id)::int AS flashcards_count
      FROM topics t
      LEFT JOIN lessons l ON t.id = l.topic_id AND l.is_active = TRUE
      LEFT JOIN questions q ON t.id = q.topic_id AND q.is_active = TRUE
      LEFT JOIN flashcards f ON t.id = f.topic_id
      WHERE t.is_active = TRUE
      GROUP BY t.id
      ORDER BY t.display_order ASC;
    `;
    const res = await this.db.query(sql);
    return res.rows;
  }

  async findBySlug(slug: string) {
    const topicSql = `
      SELECT id, slug, title, description, icon, color, display_order, created_at
      FROM topics
      WHERE slug = $1 AND is_active = TRUE;
    `;
    const topicRes = await this.db.query(topicSql, [slug]);
    if (topicRes.rowCount === 0) {
      throw new NotFoundException(`Topic with slug '${slug}' not found`);
    }

    const topic = topicRes.rows[0];

    // Fetch lessons under this topic
    const lessonsSql = `
      SELECT id, slug, title, summary, read_time_minutes, difficulty, display_order
      FROM lessons
      WHERE topic_id = $1 AND is_active = TRUE
      ORDER BY display_order ASC;
    `;
    const lessonsRes = await this.db.query(lessonsSql, [topic.id]);

    return {
      ...topic,
      lessons: lessonsRes.rows,
    };
  }
}
