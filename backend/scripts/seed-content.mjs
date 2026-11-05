import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import pg from 'pg';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../../');
const contentDir = path.join(rootDir, 'content');

// Simple .env parser
const env = {};
const envPath = path.join(rootDir, '.env');
if (fs.existsSync(envPath)) {
  fs.readFileSync(envPath, 'utf8').split('\n').forEach(line => {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('#')) {
      const [key, ...values] = trimmed.split('=');
      env[key.trim()] = values.join('=').trim();
    }
  });
}

const config = {
  host: process.env.DB_HOST || env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || env.DB_PORT || '5432', 10),
  user: process.env.DB_USER || env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || env.DB_PASSWORD || 'postgres',
  database: process.env.DB_NAME || env.DB_NAME || 'support_knowledge_db',
};

function parseFrontmatter(fileContent) {
  const match = fileContent.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]*)$/);
  if (!match) {
    return { data: {}, content: fileContent };
  }
  const yamlBlock = match[1];
  const markdownBody = match[2];
  const data = {};
  yamlBlock.split('\n').forEach(line => {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('#')) {
      const idx = trimmed.indexOf(':');
      if (idx !== -1) {
        const key = trimmed.slice(0, idx).trim();
        const value = trimmed.slice(idx + 1).trim();
        data[key] = isNaN(value) ? value : Number(value);
      }
    }
  });
  return { data, content: markdownBody };
}

async function runSeed() {
  const client = new pg.Client(config);
  await client.connect();
  console.log(`Connected to ${config.database}. Starting transaction-safe content seed...`);

  try {
    await client.query('BEGIN');

    if (!fs.existsSync(contentDir)) {
      console.log(`Content directory not found at ${contentDir}. Skipping file-based seed.`);
      await client.query('COMMIT');
      return;
    }

    const topicFolders = fs.readdirSync(contentDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name);

    let totalTopics = 0;
    let totalLessons = 0;
    let totalQuestions = 0;
    let totalFlashcards = 0;

    for (const folder of topicFolders) {
      const folderPath = path.join(contentDir, folder);
      const topicJsonPath = path.join(folderPath, '_topic.json');

      if (!fs.existsSync(topicJsonPath)) {
        console.warn(`No _topic.json found in ${folderPath}. Skipping.`);
        continue;
      }

      const topicMeta = JSON.parse(fs.readFileSync(topicJsonPath, 'utf8'));

      // 1. Upsert Topic (Dynamic lookup, no hardcoded serial numbers)
      const topicSql = `
        INSERT INTO topics (slug, title, description, icon, color, display_order)
        VALUES ($1, $2, $3, $4, $5, $6)
        ON CONFLICT (slug) DO UPDATE 
        SET title = EXCLUDED.title,
            description = EXCLUDED.description,
            icon = EXCLUDED.icon,
            color = EXCLUDED.color,
            display_order = EXCLUDED.display_order,
            updated_at = CURRENT_TIMESTAMP
        RETURNING id;
      `;
      const topicRes = await client.query(topicSql, [
        topicMeta.slug || folder,
        topicMeta.title,
        topicMeta.description || '',
        topicMeta.icon || 'Terminal',
        topicMeta.color || 'from-cyan-500 to-blue-600',
        topicMeta.display_order || 0,
      ]);
      const topicId = topicRes.rows[0].id;
      totalTopics++;

      // 2. Scan and Upsert Lessons (*.md)
      const lessonFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
      const lessonMap = new Map(); // slug -> id

      for (const lFile of lessonFiles) {
        const rawContent = fs.readFileSync(path.join(folderPath, lFile), 'utf8');
        const { data, content } = parseFrontmatter(rawContent);

        const lessonSlug = data.slug || lFile.replace(/\.md$/, '');
        const lessonTitle = data.title || lessonSlug;
        const summary = data.summary || '';
        const readTime = data.read_time_minutes || 5;
        const difficulty = data.difficulty || 'beginner';
        const displayOrder = data.display_order || 0;

        const lessonSql = `
          INSERT INTO lessons (topic_id, slug, title, summary, content_md, read_time_minutes, difficulty, display_order)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
          ON CONFLICT (topic_id, slug) DO UPDATE
          SET title = EXCLUDED.title,
              summary = EXCLUDED.summary,
              content_md = EXCLUDED.content_md,
              read_time_minutes = EXCLUDED.read_time_minutes,
              difficulty = EXCLUDED.difficulty,
              display_order = EXCLUDED.display_order,
              updated_at = CURRENT_TIMESTAMP
          RETURNING id;
        `;
        const lessonRes = await client.query(lessonSql, [
          topicId,
          lessonSlug,
          lessonTitle,
          summary,
          content,
          readTime,
          difficulty,
          displayOrder,
        ]);
        lessonMap.set(lessonSlug, lessonRes.rows[0].id);
        totalLessons++;
      }

      // 3. Scan and Upsert Questions (*.questions.json)
      const questionFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.questions.json'));
      for (const qFile of questionFiles) {
        const qList = JSON.parse(fs.readFileSync(path.join(folderPath, qFile), 'utf8'));
        for (const q of qList) {
          const lessonId = q.lesson_slug ? lessonMap.get(q.lesson_slug) || null : null;
          const seedKey = q.seed_key || `${topicMeta.slug}:${q.lesson_slug || 'gen'}:${q.question_text.slice(0, 20)}`;

          const qSql = `
            INSERT INTO questions (seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            ON CONFLICT (seed_key) DO UPDATE
            SET lesson_id = EXCLUDED.lesson_id,
                question_text = EXCLUDED.question_text,
                scenario_text = EXCLUDED.scenario_text,
                difficulty = EXCLUDED.difficulty,
                question_type = EXCLUDED.question_type,
                explanation = EXCLUDED.explanation,
                tags = EXCLUDED.tags,
                updated_at = CURRENT_TIMESTAMP
            RETURNING id;
          `;
          const qRes = await client.query(qSql, [
            seedKey,
            topicId,
            lessonId,
            q.question_text,
            q.scenario_text || null,
            q.difficulty || 'medium',
            q.question_type || 'multiple_choice',
            q.explanation || '',
            q.tags || [],
          ]);
          const questionId = qRes.rows[0].id;
          totalQuestions++;

          // Choices: Wipe & re-insert cleanly for idempotent integrity
          await client.query('DELETE FROM choices WHERE question_id = $1', [questionId]);
          if (Array.isArray(q.choices)) {
            for (let i = 0; i < q.choices.length; i++) {
              const c = q.choices[i];
              await client.query(
                `INSERT INTO choices (question_id, choice_text, is_correct, explanation, display_order)
                 VALUES ($1, $2, $3, $4, $5);`,
                [questionId, c.choice_text, !!c.is_correct, c.explanation || null, i + 1]
              );
            }
          }
        }
      }

      // 4. Scan and Upsert Flashcards (*.flashcards.json)
      const flashcardFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.flashcards.json'));
      for (const fcFile of flashcardFiles) {
        const fcList = JSON.parse(fs.readFileSync(path.join(folderPath, fcFile), 'utf8'));
        for (const fc of fcList) {
          const lessonId = fc.lesson_slug ? lessonMap.get(fc.lesson_slug) || null : null;
          const seedKey = fc.seed_key || `${topicMeta.slug}:fc:${fc.front_text.slice(0, 25)}`;

          const fcSql = `
            INSERT INTO flashcards (seed_key, topic_id, lesson_id, front_text, back_text, hint, display_order)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            ON CONFLICT (seed_key) DO UPDATE
            SET lesson_id = EXCLUDED.lesson_id,
                front_text = EXCLUDED.front_text,
                back_text = EXCLUDED.back_text,
                hint = EXCLUDED.hint,
                display_order = EXCLUDED.display_order,
                updated_at = CURRENT_TIMESTAMP;
          `;
          await client.query(fcSql, [
            seedKey,
            topicId,
            lessonId,
            fc.front_text,
            fc.back_text,
            fc.hint || null,
            fc.display_order || 0,
          ]);
          totalFlashcards++;
        }
      }
    }

    await client.query('COMMIT');
    console.log(`\n🎉 Seed completed successfully in single transaction!`);
    console.log(`- Topics Processed:    ${totalTopics}`);
    console.log(`- Lessons Upserted:    ${totalLessons}`);
    console.log(`- Questions Upserted:  ${totalQuestions}`);
    console.log(`- Flashcards Upserted: ${totalFlashcards}\n`);
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('❌ Seeding failed. Transaction rolled back:', err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

runSeed();
