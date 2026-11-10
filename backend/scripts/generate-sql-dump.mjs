import fs from 'fs';
import path from 'path';
import { execFileSync } from 'child_process';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../../');
const dbDir = path.join(rootDir, 'db');
const dumpsDir = path.join(dbDir, 'dumps');

if (!fs.existsSync(dumpsDir)) {
  fs.mkdirSync(dumpsDir, { recursive: true });
}

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

const dbUser = process.env.DB_USER || env.DB_USER || 'postgres';
const dbName = process.env.DB_NAME || env.DB_NAME || 'support_knowledge_db';
const containerName = process.env.DB_CONTAINER || 'support_postgres';

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
-- Clean existing rows before inserting full dump data
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

console.log(`Exporting live PostgreSQL database "${dbName}" from container "${containerName}"...`);

const rawFull = execFileSync(
  'docker',
  [
    'exec',
    containerName,
    'pg_dump',
    '-U',
    dbUser,
    '-d',
    dbName,
    '--clean',
    '--if-exists',
    '--no-owner',
    '--no-privileges',
    '--inserts',
  ],
  { encoding: 'utf8', maxBuffer: 50 * 1024 * 1024 }
);

const rawData = execFileSync(
  'docker',
  [
    'exec',
    containerName,
    'pg_dump',
    '-U',
    dbUser,
    '-d',
    dbName,
    '--data-only',
    '--no-owner',
    '--no-privileges',
    '--inserts',
  ],
  { encoding: 'utf8', maxBuffer: 50 * 1024 * 1024 }
);

fs.writeFileSync(fullDumpPath, cleanPgDump(rawFull, false), 'utf8');
console.log(`✅ Dumped full schema + data -> db/dumps/support_knowledge_db_full.sql`);

fs.writeFileSync(dataOnlyPath, cleanPgDump(rawData, true), 'utf8');
console.log(`✅ Dumped data-only -> db/dumps/support_knowledge_db_data.sql`);
