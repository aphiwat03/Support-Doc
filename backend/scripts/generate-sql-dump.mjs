import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../../');
const contentDir = path.join(rootDir, 'content');
const dbDir = path.join(rootDir, 'db');
const dbInitDir = path.join(dbDir, 'init');

function escapeSql(str) {
  if (str === null || str === undefined) return 'NULL';
  return `'` + String(str).replace(/'/g, `''`) + `'`;
}

function escapeArray(arr) {
  if (!arr || !Array.isArray(arr) || arr.length === 0) return 'ARRAY[]::text[]';
  return `ARRAY[` + arr.map(x => escapeSql(x)).join(', ') + `]::text[]`;
}

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

function generateSql() {
  console.log('Generating complete SQL seed and dump from content files...');

  const topicFolders = fs.readdirSync(contentDir, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);

  const sqlStatements = [];

  sqlStatements.push(`-- ====================================================================`);
  sqlStatements.push(`-- Complete Seed Data for Support Knowledge Review Application`);
  sqlStatements.push(`-- Generated automatically from content directory`);
  sqlStatements.push(`-- Topics, Lessons, Questions, Choices, and Flashcards`);
  sqlStatements.push(`-- ====================================================================`);
  sqlStatements.push(``);
  sqlStatements.push(`BEGIN;`);
  sqlStatements.push(``);

  let totalTopics = 0;
  let totalLessons = 0;
  let totalQuestions = 0;
  let totalChoices = 0;
  let totalFlashcards = 0;

  for (const folder of topicFolders) {
    const folderPath = path.join(contentDir, folder);
    const topicJsonPath = path.join(folderPath, '_topic.json');

    if (!fs.existsSync(topicJsonPath)) {
      continue;
    }

    const topicMeta = JSON.parse(fs.readFileSync(topicJsonPath, 'utf8'));
    const topicSlug = topicMeta.slug || folder;

    sqlStatements.push(`-- --------------------------------------------------------------------`);
    sqlStatements.push(`-- TOPIC: ${topicMeta.title} (${topicSlug})`);
    sqlStatements.push(`-- --------------------------------------------------------------------`);
    sqlStatements.push(`INSERT INTO topics (slug, title, description, icon, color, display_order)`);
    sqlStatements.push(`VALUES (${escapeSql(topicSlug)}, ${escapeSql(topicMeta.title)}, ${escapeSql(topicMeta.description || '')}, ${escapeSql(topicMeta.icon || 'Terminal')}, ${escapeSql(topicMeta.color || 'from-cyan-500 to-blue-600')}, ${Number(topicMeta.display_order || 0)})`);
    sqlStatements.push(`ON CONFLICT (slug) DO UPDATE SET`);
    sqlStatements.push(`  title = EXCLUDED.title,`);
    sqlStatements.push(`  description = EXCLUDED.description,`);
    sqlStatements.push(`  icon = EXCLUDED.icon,`);
    sqlStatements.push(`  color = EXCLUDED.color,`);
    sqlStatements.push(`  display_order = EXCLUDED.display_order,`);
    sqlStatements.push(`  updated_at = CURRENT_TIMESTAMP;`);
    sqlStatements.push(``);
    totalTopics++;

    // Lessons
    const lessonFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.md')).sort();
    for (const lFile of lessonFiles) {
      const rawContent = fs.readFileSync(path.join(folderPath, lFile), 'utf8');
      const { data, content } = parseFrontmatter(rawContent);

      const lessonSlug = data.slug || lFile.replace(/\.md$/, '');
      const lessonTitle = data.title || lessonSlug;
      const summary = data.summary || '';
      const readTime = Number(data.read_time_minutes || 5);
      const difficulty = data.difficulty || 'beginner';
      const displayOrder = Number(data.display_order || 0);

      sqlStatements.push(`INSERT INTO lessons (topic_id, slug, title, summary, content_md, read_time_minutes, difficulty, display_order)`);
      sqlStatements.push(`VALUES ((SELECT id FROM topics WHERE slug = ${escapeSql(topicSlug)}), ${escapeSql(lessonSlug)}, ${escapeSql(lessonTitle)}, ${escapeSql(summary)}, ${escapeSql(content)}, ${readTime}, ${escapeSql(difficulty)}, ${displayOrder})`);
      sqlStatements.push(`ON CONFLICT (topic_id, slug) DO UPDATE SET`);
      sqlStatements.push(`  title = EXCLUDED.title,`);
      sqlStatements.push(`  summary = EXCLUDED.summary,`);
      sqlStatements.push(`  content_md = EXCLUDED.content_md,`);
      sqlStatements.push(`  read_time_minutes = EXCLUDED.read_time_minutes,`);
      sqlStatements.push(`  difficulty = EXCLUDED.difficulty,`);
      sqlStatements.push(`  display_order = EXCLUDED.display_order,`);
      sqlStatements.push(`  updated_at = CURRENT_TIMESTAMP;`);
      sqlStatements.push(``);
      totalLessons++;
    }

    // Questions & Choices
    const questionFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.questions.json')).sort();
    for (const qFile of questionFiles) {
      const qList = JSON.parse(fs.readFileSync(path.join(folderPath, qFile), 'utf8'));
      for (let qIdx = 0; qIdx < qList.length; qIdx++) {
        const q = qList[qIdx];
        const seedKey = q.seed_key || `${topicSlug}:${q.lesson_slug || 'gen'}:${qIdx + 1}:${q.question_text.slice(0, 20)}`;
        const lessonRefSql = q.lesson_slug
          ? `(SELECT id FROM lessons WHERE slug = ${escapeSql(q.lesson_slug)} AND topic_id = (SELECT id FROM topics WHERE slug = ${escapeSql(topicSlug)}))`
          : `NULL`;

        sqlStatements.push(`INSERT INTO questions (seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags)`);
        sqlStatements.push(`VALUES (${escapeSql(seedKey)}, (SELECT id FROM topics WHERE slug = ${escapeSql(topicSlug)}), ${lessonRefSql}, ${escapeSql(q.question_text)}, ${escapeSql(q.scenario_text || null)}, ${escapeSql(q.difficulty || 'medium')}, ${escapeSql(q.question_type || 'multiple_choice')}, ${escapeSql(q.explanation || '')}, ${escapeArray(q.tags || [])})`);
        sqlStatements.push(`ON CONFLICT (seed_key) DO UPDATE SET`);
        sqlStatements.push(`  topic_id = EXCLUDED.topic_id,`);
        sqlStatements.push(`  lesson_id = EXCLUDED.lesson_id,`);
        sqlStatements.push(`  question_text = EXCLUDED.question_text,`);
        sqlStatements.push(`  scenario_text = EXCLUDED.scenario_text,`);
        sqlStatements.push(`  difficulty = EXCLUDED.difficulty,`);
        sqlStatements.push(`  question_type = EXCLUDED.question_type,`);
        sqlStatements.push(`  explanation = EXCLUDED.explanation,`);
        sqlStatements.push(`  tags = EXCLUDED.tags,`);
        sqlStatements.push(`  updated_at = CURRENT_TIMESTAMP;`);
        sqlStatements.push(``);
        totalQuestions++;

        // Delete old choices for this question if any, then insert new choices
        sqlStatements.push(`DELETE FROM choices WHERE question_id = (SELECT id FROM questions WHERE seed_key = ${escapeSql(seedKey)});`);

        if (Array.isArray(q.choices)) {
          for (let i = 0; i < q.choices.length; i++) {
            const c = q.choices[i];
            sqlStatements.push(`INSERT INTO choices (question_id, choice_text, is_correct, explanation, display_order)`);
            sqlStatements.push(`VALUES ((SELECT id FROM questions WHERE seed_key = ${escapeSql(seedKey)}), ${escapeSql(c.choice_text)}, ${c.is_correct ? 'TRUE' : 'FALSE'}, ${escapeSql(c.explanation || null)}, ${i + 1});`);
            totalChoices++;
          }
        }
        sqlStatements.push(``);
      }
    }

    // Flashcards
    const flashcardFiles = fs.readdirSync(folderPath).filter(f => f.endsWith('.flashcards.json')).sort();
    for (const fcFile of flashcardFiles) {
      const fcList = JSON.parse(fs.readFileSync(path.join(folderPath, fcFile), 'utf8'));
      for (let fcIdx = 0; fcIdx < fcList.length; fcIdx++) {
        const fc = fcList[fcIdx];
        const seedKey = fc.seed_key || `${topicSlug}:fc:${fcIdx + 1}:${fc.front_text.slice(0, 25)}`;
        const lessonRefSql = fc.lesson_slug
          ? `(SELECT id FROM lessons WHERE slug = ${escapeSql(fc.lesson_slug)} AND topic_id = (SELECT id FROM topics WHERE slug = ${escapeSql(topicSlug)}))`
          : `NULL`;

        sqlStatements.push(`INSERT INTO flashcards (seed_key, topic_id, lesson_id, front_text, back_text, hint, display_order)`);
        sqlStatements.push(`VALUES (${escapeSql(seedKey)}, (SELECT id FROM topics WHERE slug = ${escapeSql(topicSlug)}), ${lessonRefSql}, ${escapeSql(fc.front_text)}, ${escapeSql(fc.back_text)}, ${escapeSql(fc.hint || null)}, ${Number(fc.display_order || 0)})`);
        sqlStatements.push(`ON CONFLICT (seed_key) DO UPDATE SET`);
        sqlStatements.push(`  topic_id = EXCLUDED.topic_id,`);
        sqlStatements.push(`  lesson_id = EXCLUDED.lesson_id,`);
        sqlStatements.push(`  front_text = EXCLUDED.front_text,`);
        sqlStatements.push(`  back_text = EXCLUDED.back_text,`);
        sqlStatements.push(`  hint = EXCLUDED.hint,`);
        sqlStatements.push(`  display_order = EXCLUDED.display_order,`);
        sqlStatements.push(`  updated_at = CURRENT_TIMESTAMP;`);
        sqlStatements.push(``);
        totalFlashcards++;
      }
    }
  }

  sqlStatements.push(`COMMIT;`);
  sqlStatements.push(``);

  const seedSqlContent = sqlStatements.join('\n');

  // 1. Write to db/init/02-seed.sql (for automatic Docker Compose startup)
  const seedFilePath = path.join(dbInitDir, '02-seed.sql');
  fs.writeFileSync(seedFilePath, seedSqlContent, 'utf8');
  console.log(`Updated ${seedFilePath} with complete content!`);

  // 2. Write standalone full dump db/dump.sql (Schema + Seed)
  const schemaSql1 = fs.readFileSync(path.join(dbInitDir, '01-init.sql'), 'utf8');
  const schemaSql3 = fs.readFileSync(path.join(dbInitDir, '03-progress-streak.sql'), 'utf8');

  const fullDump = [
    '-- ====================================================================',
    '-- FULL DATABASE DUMP: Support Knowledge Review Application',
    '-- Contains DDL Schema + All Topics, Lessons, Questions, and Flashcards',
    '-- Generated at: ' + new Date().toISOString(),
    '-- ====================================================================',
    '',
    schemaSql1,
    '',
    schemaSql3,
    '',
    seedSqlContent,
  ].join('\n');

  const dumpFilePath = path.join(dbDir, 'dump.sql');
  fs.writeFileSync(dumpFilePath, fullDump, 'utf8');
  console.log(`Generated standalone full dump at ${dumpFilePath}!`);

  console.log('\n=========================================');
  console.log('SQL Generation Summary:');
  console.log(`- Topics:     ${totalTopics}`);
  console.log(`- Lessons:    ${totalLessons}`);
  console.log(`- Questions:  ${totalQuestions}`);
  console.log(`- Choices:    ${totalChoices}`);
  console.log(`- Flashcards: ${totalFlashcards}`);
  console.log('=========================================\n');
}

generateSql();
