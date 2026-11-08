import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../../');
const dbDir = path.join(rootDir, 'db');
const dumpsDir = path.join(dbDir, 'dumps');

if (!fs.existsSync(dumpsDir)) {
  fs.mkdirSync(dumpsDir, { recursive: true });
}

function cleanPgDump(sql, isDataOnly = false) {
  let cleaned = sql
    .split(/\r?\n/)
    .filter(line => !line.startsWith('\\restrict') && !line.startsWith('\\unrestrict'))
    .join('\n')
    .replace(
      "SELECT pg_catalog.set_config('search_path', '', false);",
      "SELECT pg_catalog.set_config('search_path', 'public', false);"
    );

  if (isDataOnly && !cleaned.includes('TRUNCATE TABLE')) {
    const truncateStmt = `
-- Clean existing rows before inserting full dump seed
TRUNCATE TABLE
  public.study_activity,
  public.lesson_progress,
  public.bookmarks,
  public.quiz_session_answers,
  public.quiz_sessions,
  public.flashcards,
  public.choices,
  public.questions,
  public.lessons,
  public.topics
RESTART IDENTITY CASCADE;
`;
    cleaned = cleaned.replace(
      "SET row_security = off;",
      "SET row_security = off;\n" + truncateStmt
    );
  }

  return cleaned;
}

const fullDumpPath = path.join(dumpsDir, 'support_knowledge_db_full.sql');
const dataOnlyPath = path.join(dumpsDir, 'support_knowledge_db_data.sql');
const initSeedPath = path.join(dbDir, 'init', '02-seed.sql');

if (fs.existsSync(fullDumpPath)) {
  const rawDump = fs.readFileSync(fullDumpPath, 'utf8');
  fs.writeFileSync(fullDumpPath, cleanPgDump(rawDump, false), 'utf8');
  console.log('Verified db/dumps/support_knowledge_db_full.sql');
}

if (fs.existsSync(dataOnlyPath)) {
  const rawSeed = fs.readFileSync(dataOnlyPath, 'utf8');
  const cleanedSeed = cleanPgDump(rawSeed, true);
  fs.writeFileSync(dataOnlyPath, cleanedSeed, 'utf8');
  fs.writeFileSync(initSeedPath, cleanedSeed, 'utf8');
  console.log('Verified db/dumps/support_knowledge_db_data.sql and db/init/02-seed.sql');
}
