import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';
import { StartQuizDto } from './dto/start-quiz.dto.js';
import { SubmitQuizDto } from './dto/submit-quiz.dto.js';

@Injectable()
export class QuizService {
  constructor(private readonly db: DatabaseService) {}

  async startQuiz(dto: StartQuizDto) {
    let topicId = dto.topic_id;
    let topicTitle = 'รวมทุกหมวดหมู่วิชาชีพ Support';

    if (dto.topic_slug) {
      const topicRes = await this.db.query('SELECT id, title FROM topics WHERE slug = $1 AND is_active = TRUE', [dto.topic_slug]);
      if (topicRes.rowCount === 0) {
        throw new NotFoundException(`Topic '${dto.topic_slug}' not found`);
      }
      topicId = topicRes.rows[0].id;
      topicTitle = topicRes.rows[0].title;
    } else if (topicId) {
      const topicRes = await this.db.query('SELECT id, title FROM topics WHERE id = $1 AND is_active = TRUE', [topicId]);
      if ((topicRes.rowCount ?? 0) > 0) {
        topicTitle = topicRes.rows[0].title;
      }
    }

    const limit = dto.total_questions || 10;
    const difficulty = dto.difficulty || 'all';

    // Query questions using Raw SQL
    let questionsSql = `
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
    const params: any[] = [];

    if (topicId) {
      params.push(topicId);
      questionsSql += ` AND q.topic_id = $${params.length}`;
    }
    if (difficulty !== 'all') {
      params.push(difficulty);
      questionsSql += ` AND q.difficulty = $${params.length}`;
    }

    params.push(limit);
    questionsSql += ` ORDER BY RANDOM() LIMIT $${params.length};`;

    const questionsRes = await this.db.query(questionsSql, params);
    const questions = questionsRes.rows;

    if (questions.length === 0) {
      throw new BadRequestException('ไม่พบข้อสอบในเงื่อนไขที่ระบุ');
    }

    // Attach choices for each question (hide is_correct)
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

    // Create quiz session in database
    const sessionSql = `
      INSERT INTO quiz_sessions (topic_id, difficulty, total_questions)
      VALUES ($1, $2, $3)
      RETURNING id, created_at;
    `;
    const sessionRes = await this.db.query(sessionSql, [topicId || null, difficulty, questions.length]);
    const session = sessionRes.rows[0];

    return {
      session_id: session.id,
      topic_id: topicId,
      topic_title: topicTitle,
      difficulty,
      total_questions: questions.length,
      created_at: session.created_at,
      questions,
    };
  }

  async submitQuiz(sessionId: string, dto: SubmitQuizDto) {
    const sessionRes = await this.db.query('SELECT * FROM quiz_sessions WHERE id = $1', [sessionId]);
    if (sessionRes.rowCount === 0) {
      throw new NotFoundException(`Quiz session '${sessionId}' not found`);
    }

    const session = sessionRes.rows[0];
    if (session.is_completed) {
      throw new BadRequestException('ชุดข้อสอบนี้ได้รับการตรวจและบันทึกผลเรียบร้อยแล้ว');
    }

    const client = await this.db.getClient();
    try {
      await client.query('BEGIN');

      let score = 0;
      const evaluatedQuestions: any[] = [];

      for (const ans of dto.answers) {
        // Query correct choice for this question
        const qSql = `
          SELECT 
            q.id,
            q.question_text,
            q.scenario_text,
            q.difficulty,
            q.explanation,
            q.tags,
            t.slug AS topic_slug,
            t.title AS topic_title
          FROM questions q
          JOIN topics t ON q.topic_id = t.id
          WHERE q.id = $1;
        `;
        const qRes = await client.query(qSql, [ans.question_id]);
        if (qRes.rowCount === 0) continue;
        const question = qRes.rows[0];

        // Fetch all choices for this question
        const choicesRes = await client.query(
          'SELECT id, choice_text, is_correct, explanation, display_order FROM choices WHERE question_id = $1 ORDER BY display_order ASC',
          [ans.question_id]
        );
        const choices = choicesRes.rows;

        const correctChoice = choices.find((c: any) => c.is_correct === true);
        const selectedChoice = choices.find((c: any) => c.id === ans.selected_choice_id);

        const isCorrect = selectedChoice ? selectedChoice.is_correct === true : false;
        if (isCorrect) {
          score += 1;
        }

        // Record answer
        await client.query(
          `INSERT INTO quiz_session_answers (session_id, question_id, selected_choice_id, is_correct)
           VALUES ($1, $2, $3, $4);`,
          [sessionId, ans.question_id, ans.selected_choice_id || null, isCorrect]
        );

        evaluatedQuestions.push({
          question_id: question.id,
          question_text: question.question_text,
          scenario_text: question.scenario_text,
          difficulty: question.difficulty,
          topic_title: question.topic_title,
          explanation: question.explanation,
          tags: question.tags,
          is_correct: isCorrect,
          selected_choice: selectedChoice || null,
          correct_choice: correctChoice || null,
          all_choices: choices,
        });
      }

      const totalQuestions = session.total_questions || dto.answers.length;
      const percentage = totalQuestions > 0 ? Number(((score / totalQuestions) * 100).toFixed(2)) : 0;
      const timeSpent = dto.time_spent_seconds || 0;

      // Update session
      await client.query(
        `UPDATE quiz_sessions 
         SET score = $1, percentage = $2, time_spent_seconds = $3, is_completed = TRUE, completed_at = CURRENT_TIMESTAMP
         WHERE id = $4;`,
        [score, percentage, timeSpent, sessionId]
      );

      // Log to study_activity for streak
      await client.query(
        `INSERT INTO study_activity (activity_type, item_id) VALUES ('quiz', $1);`,
        [sessionId]
      );

      await client.query('COMMIT');

      return {
        session_id: sessionId,
        score,
        total_questions: totalQuestions,
        percentage,
        time_spent_seconds: timeSpent,
        is_completed: true,
        evaluated_questions: evaluatedQuestions,
      };
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  }

  async getSessionResult(sessionId: string) {
    const sessionRes = await this.db.query(
      `SELECT s.*, t.title AS topic_title, t.slug AS topic_slug 
       FROM quiz_sessions s
       LEFT JOIN topics t ON s.topic_id = t.id
       WHERE s.id = $1`,
      [sessionId]
    );
    if (sessionRes.rowCount === 0) {
      throw new NotFoundException(`Quiz session '${sessionId}' not found`);
    }

    const session = sessionRes.rows[0];

    // Fetch answered questions
    const answersSql = `
      SELECT 
        sa.is_correct,
        q.id AS question_id,
        q.question_text,
        q.scenario_text,
        q.difficulty,
        q.explanation,
        q.tags,
        sc.id AS selected_choice_id,
        sc.choice_text AS selected_choice_text,
        cc.id AS correct_choice_id,
        cc.choice_text AS correct_choice_text
      FROM quiz_session_answers sa
      JOIN questions q ON sa.question_id = q.id
      LEFT JOIN choices sc ON sa.selected_choice_id = sc.id
      LEFT JOIN choices cc ON q.id = cc.question_id AND cc.is_correct = TRUE
      WHERE sa.session_id = $1
      ORDER BY sa.created_at ASC;
    `;
    const answersRes = await this.db.query(answersSql, [sessionId]);

    return {
      ...session,
      answers: answersRes.rows,
    };
  }
}
