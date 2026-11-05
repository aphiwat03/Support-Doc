import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class QuestionsService {
  constructor(private readonly db: DatabaseService) {}

  async findAll(params: {
    topicSlug?: string;
    topicId?: number;
    difficulty?: string;
    lessonId?: string;
    search?: string;
    includeAnswers?: boolean;
  }) {
    let sql = `
      SELECT 
        q.id,
        q.topic_id,
        t.slug AS topic_slug,
        t.title AS topic_title,
        q.lesson_id,
        l.title AS lesson_title,
        q.question_text,
        q.scenario_text,
        q.difficulty,
        q.question_type,
        q.tags,
        q.explanation,
        q.created_at
      FROM questions q
      JOIN topics t ON q.topic_id = t.id
      LEFT JOIN lessons l ON q.lesson_id = l.id
      WHERE q.is_active = TRUE
    `;
    const queryParams: any[] = [];

    if (params.topicSlug) {
      queryParams.push(params.topicSlug);
      sql += ` AND t.slug = $${queryParams.length}`;
    }
    if (params.topicId) {
      queryParams.push(params.topicId);
      sql += ` AND q.topic_id = $${queryParams.length}`;
    }
    if (params.difficulty && params.difficulty !== 'all') {
      queryParams.push(params.difficulty);
      sql += ` AND q.difficulty = $${queryParams.length}`;
    }
    if (params.lessonId) {
      queryParams.push(params.lessonId);
      sql += ` AND q.lesson_id = $${queryParams.length}`;
    }
    if (params.search) {
      queryParams.push(`%${params.search}%`);
      sql += ` AND (q.question_text ILIKE $${queryParams.length} OR q.scenario_text ILIKE $${queryParams.length})`;
    }

    sql += ` ORDER BY q.created_at ASC;`;

    const res = await this.db.query(sql, queryParams);
    const questions = res.rows;

    // Attach choices for each question
    if (questions.length > 0) {
      const questionIds = questions.map((q: any) => q.id);
      const choicesSql = `
        SELECT id, question_id, choice_text, display_order ${params.includeAnswers ? ', is_correct, explanation' : ''}
        FROM choices
        WHERE question_id = ANY($1::uuid[])
        ORDER BY display_order ASC;
      `;
      const choicesRes = await this.db.query(choicesSql, [questionIds]);
      const choicesMap = new Map<string, any[]>();
      for (const choice of choicesRes.rows) {
        if (!choicesMap.has(choice.question_id)) {
          choicesMap.set(choice.question_id, []);
        }
        choicesMap.get(choice.question_id)!.push(choice);
      }

      for (const q of questions) {
        q.choices = choicesMap.get(q.id) || [];
      }
    }

    return questions;
  }

  async findRandom(params: {
    topicSlug?: string;
    topicId?: number;
    difficulty?: string;
    limit?: number;
  }) {
    const limit = params.limit ? Math.min(Math.max(params.limit, 1), 50) : 10;
    let sql = `
      SELECT 
        q.id,
        q.topic_id,
        t.slug AS topic_slug,
        t.title AS topic_title,
        q.question_text,
        q.scenario_text,
        q.difficulty,
        q.question_type,
        q.tags
      FROM questions q
      JOIN topics t ON q.topic_id = t.id
      WHERE q.is_active = TRUE
    `;
    const queryParams: any[] = [];

    if (params.topicSlug) {
      queryParams.push(params.topicSlug);
      sql += ` AND t.slug = $${queryParams.length}`;
    }
    if (params.topicId) {
      queryParams.push(params.topicId);
      sql += ` AND q.topic_id = $${queryParams.length}`;
    }
    if (params.difficulty && params.difficulty !== 'all') {
      queryParams.push(params.difficulty);
      sql += ` AND q.difficulty = $${queryParams.length}`;
    }

    queryParams.push(limit);
    sql += ` ORDER BY RANDOM() LIMIT $${queryParams.length};`;

    const res = await this.db.query(sql, queryParams);
    const questions = res.rows;

    if (questions.length > 0) {
      const questionIds = questions.map((q: any) => q.id);
      const choicesSql = `
        SELECT id, question_id, choice_text, display_order
        FROM choices
        WHERE question_id = ANY($1::uuid[])
        ORDER BY display_order ASC;
      `;
      const choicesRes = await this.db.query(choicesSql, [questionIds]);
      const choicesMap = new Map<string, any[]>();
      for (const choice of choicesRes.rows) {
        if (!choicesMap.has(choice.question_id)) {
          choicesMap.set(choice.question_id, []);
        }
        choicesMap.get(choice.question_id)!.push(choice);
      }

      for (const q of questions) {
        q.choices = choicesMap.get(q.id) || [];
      }
    }

    return questions;
  }

  async findById(id: string, includeAnswers: boolean = false) {
    const sql = `
      SELECT 
        q.*,
        t.slug AS topic_slug,
        t.title AS topic_title,
        l.title AS lesson_title
      FROM questions q
      JOIN topics t ON q.topic_id = t.id
      LEFT JOIN lessons l ON q.lesson_id = l.id
      WHERE q.id = $1 AND q.is_active = TRUE;
    `;
    const res = await this.db.query(sql, [id]);
    if (res.rowCount === 0) {
      throw new NotFoundException(`Question with id '${id}' not found`);
    }

    const question = res.rows[0];
    const choicesSql = `
      SELECT id, question_id, choice_text, display_order ${includeAnswers ? ', is_correct, explanation' : ''}
      FROM choices
      WHERE question_id = $1
      ORDER BY display_order ASC;
    `;
    const choicesRes = await this.db.query(choicesSql, [id]);
    question.choices = choicesRes.rows;

    return question;
  }
}
