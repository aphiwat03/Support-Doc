import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class LessonsService {
  constructor(private readonly db: DatabaseService) {}

  async findAll(topicSlug?: string, topicId?: number) {
    let sql = `
      SELECT 
        l.id,
        l.topic_id,
        t.slug AS topic_slug,
        t.title AS topic_title,
        l.slug,
        l.title,
        l.summary,
        l.read_time_minutes,
        l.difficulty,
        l.display_order,
        l.created_at
      FROM lessons l
      JOIN topics t ON l.topic_id = t.id
      WHERE l.is_active = TRUE
    `;
    const params: any[] = [];

    if (topicSlug) {
      params.push(topicSlug);
      sql += ` AND t.slug = $${params.length}`;
    } else if (topicId) {
      params.push(topicId);
      sql += ` AND l.topic_id = $${params.length}`;
    }

    sql += ` ORDER BY t.display_order ASC, l.display_order ASC;`;

    const res = await this.db.query(sql, params);
    return res.rows;
  }

  async findById(id: string) {
    const sql = `
      SELECT 
        l.*,
        t.slug AS topic_slug,
        t.title AS topic_title
      FROM lessons l
      JOIN topics t ON l.topic_id = t.id
      WHERE l.id = $1 AND l.is_active = TRUE;
    `;
    const res = await this.db.query(sql, [id]);
    if (res.rowCount === 0) {
      throw new NotFoundException(`Lesson with id '${id}' not found`);
    }
    return res.rows[0];
  }

  async findByTopicAndSlug(topicSlug: string, lessonSlug: string) {
    const sql = `
      SELECT 
        l.*,
        t.slug AS topic_slug,
        t.title AS topic_title
      FROM lessons l
      JOIN topics t ON l.topic_id = t.id
      WHERE t.slug = $1 AND l.slug = $2 AND l.is_active = TRUE;
    `;
    const res = await this.db.query(sql, [topicSlug, lessonSlug]);
    if (res.rowCount === 0) {
      throw new NotFoundException(`Lesson '${lessonSlug}' in topic '${topicSlug}' not found`);
    }
    const currentLesson = res.rows[0];

    // Find all sibling lessons in the same topic for Sidebar & Next/Prev navigation
    const siblingsSql = `
      SELECT id, slug, title, display_order, read_time_minutes
      FROM lessons
      WHERE topic_id = $1 AND is_active = TRUE
      ORDER BY display_order ASC;
    `;
    const siblingsRes = await this.db.query(siblingsSql, [currentLesson.topic_id]);
    const siblings = siblingsRes.rows;

    const currentIndex = siblings.findIndex((s: any) => s.id === currentLesson.id);
    const prev = currentIndex > 0 ? siblings[currentIndex - 1] : null;
    const next = currentIndex < siblings.length - 1 ? siblings[currentIndex + 1] : null;

    return {
      ...currentLesson,
      topic_lessons: siblings,
      prev_lesson: prev,
      next_lesson: next,
    };
  }
}
