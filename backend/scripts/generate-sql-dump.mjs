import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../../');
const dbDir = path.join(rootDir, 'db');

function cleanPgDump(sql, isDataOnly = false) {
  let cleaned = sql
    .split(/\r?\n/)
    .filter(line => !line.startsWith('\\restrict') && !line.startsWith('\\unrestrict'))
    .join('\n')
    .replace(
      "SELECT pg_catalog.set_config('search_path', '', false);",
      "SELECT pg_catalog.set_config('search_path', 'public', false);"
    );

  if (isDataOnly) {
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

const dumpPath = path.join(dbDir, 'dump.sql');
const dataOnlyPath = path.join(dbDir, 'data_only_seed.sql');
const initSeedPath = path.join(dbDir, 'init', '02-seed.sql');

if (fs.existsSync(dumpPath)) {
  const rawDump = fs.readFileSync(dumpPath, 'utf8');
  fs.writeFileSync(dumpPath, cleanPgDump(rawDump, false), 'utf8');
  console.log('Cleaned db/dump.sql (Full Schema + Data Dump)');
}

if (fs.existsSync(dataOnlyPath)) {
  const rawSeed = fs.readFileSync(dataOnlyPath, 'utf8');
  fs.writeFileSync(initSeedPath, cleanPgDump(rawSeed, true), 'utf8');
  fs.unlinkSync(dataOnlyPath);
  console.log('Cleaned and updated db/init/02-seed.sql (Data-only Seed with TRUNCATE)');
}
