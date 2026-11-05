import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';
import { CreateBookmarkDto } from './dto/create-bookmark.dto.js';

@Injectable()
export class BookmarksService {
  constructor(private readonly db: DatabaseService) {}

  async findAll(itemType?: string) {
    let sql = `
      SELECT b.id, b.item_type, b.item_id, b.notes, b.created_at
      FROM bookmarks b
      WHERE 1=1
    `;
    const params: any[] = [];
    if (itemType) {
      params.push(itemType);
      sql += ` AND b.item_type = $${params.length}`;
    }
    sql += ` ORDER BY b.created_at DESC;`;

    const res = await this.db.query(sql, params);
    const bookmarks = res.rows;

    // Enrich with item information if available
    for (const b of bookmarks) {
      if (b.item_type === 'question') {
        const qRes = await this.db.query(
          `SELECT q.id, q.question_text, q.difficulty, t.title AS topic_title
           FROM questions q
           JOIN topics t ON q.topic_id = t.id
           WHERE q.id = $1`,
          [b.item_id]
        );
        b.item_details = qRes.rows[0] || null;
      } else if (b.item_type === 'lesson') {
        const lRes = await this.db.query(
          `SELECT l.id, l.title, l.slug, t.slug AS topic_slug, t.title AS topic_title
           FROM lessons l
           JOIN topics t ON l.topic_id = t.id
           WHERE l.id = $1`,
          [b.item_id]
        );
        b.item_details = lRes.rows[0] || null;
      } else if (b.item_type === 'flashcard') {
        const fRes = await this.db.query(
          `SELECT f.id, f.front_text, f.back_text, t.title AS topic_title
           FROM flashcards f
           JOIN topics t ON f.topic_id = t.id
           WHERE f.id = $1`,
          [b.item_id]
        );
        b.item_details = fRes.rows[0] || null;
      }
    }

    return bookmarks;
  }

  async create(dto: CreateBookmarkDto) {
    const sql = `
      INSERT INTO bookmarks (item_type, item_id, notes)
      VALUES ($1, $2, $3)
      ON CONFLICT (item_type, item_id) 
      DO UPDATE SET notes = EXCLUDED.notes
      RETURNING *;
    `;
    const res = await this.db.query(sql, [dto.item_type, dto.item_id, dto.notes || null]);
    return res.rows[0];
  }

  async remove(id: string) {
    const res = await this.db.query('DELETE FROM bookmarks WHERE id = $1 RETURNING id;', [id]);
    if (res.rowCount === 0) {
      throw new NotFoundException(`Bookmark with id '${id}' not found`);
    }
    return { success: true, message: 'Bookmark removed successfully', id };
  }

  async removeByItem(itemType: string, itemId: string) {
    const res = await this.db.query(
      'DELETE FROM bookmarks WHERE item_type = $1 AND item_id = $2 RETURNING id;',
      [itemType, itemId]
    );
    if (res.rowCount === 0) {
      throw new NotFoundException(`Bookmark for item '${itemId}' not found`);
    }
    return { success: true, message: 'Bookmark removed successfully', id: res.rows[0].id };
  }
}
