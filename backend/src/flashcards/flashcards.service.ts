import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class FlashcardsService {
  constructor(private readonly db: DatabaseService) {}

  async findAll(topicSlug?: string, topicId?: number) {
    let sql = `
      SELECT 
        f.id,
        f.topic_id,
        t.slug AS topic_slug,
        t.title AS topic_title,
        f.lesson_id,
        l.title AS lesson_title,
        f.front_text,
        f.back_text,
        f.hint,
        f.display_order,
        f.created_at
      FROM flashcards f
      JOIN topics t ON f.topic_id = t.id
      LEFT JOIN lessons l ON f.lesson_id = l.id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (topicSlug) {
      params.push(topicSlug);
      sql += ` AND t.slug = $${params.length}`;
    } else if (topicId) {
      params.push(topicId);
      sql += ` AND f.topic_id = $${params.length}`;
    }

    sql += ` ORDER BY f.display_order ASC, f.created_at ASC;`;

    const res = await this.db.query(sql, params);
    return res.rows;
  }
}
