import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import pg from 'pg';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rootDir = path.resolve(__dirname, '../../');
const envPath = path.join(rootDir, '.env');

// Simple .env parser without external dependencies
const env = {};
if (fs.existsSync(envPath)) {
  const content = fs.readFileSync(envPath, 'utf8');
  content.split('\n').forEach(line => {
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

console.log(`Connecting to PostgreSQL at ${config.host}:${config.port}/${config.database}...`);

async function run() {
  // First, connect to default 'postgres' database to ensure the target database exists
  const adminClient = new pg.Client({
    ...config,
    database: 'postgres',
  });

  try {
    await adminClient.connect();
    const checkDb = await adminClient.query(
      `SELECT 1 FROM pg_database WHERE datname = $1`,
      [config.database]
    );
    if (checkDb.rowCount === 0) {
      console.log(`Database "${config.database}" does not exist. Creating...`);
      await adminClient.query(`CREATE DATABASE "${config.database}"`);
      console.log(`Database "${config.database}" created.`);
    }
    await adminClient.end();
  } catch (err) {
    console.warn(`Note: Could not check/create database via admin client (${err.message}). Trying direct connection...`);
    try { await adminClient.end(); } catch (_) {}
  }

  // Connect to target database
  const client = new pg.Client(config);
  try {
    await client.connect();
    console.log(`Connected successfully to database "${config.database}".`);

    // 1. Run Schema (01-init.sql)
    const schemaFile = path.join(rootDir, 'db/init/01-init.sql');
    console.log(`Executing schema: ${schemaFile}...`);
    const schemaSql = fs.readFileSync(schemaFile, 'utf8');
    await client.query(schemaSql);
    console.log(`Schema created successfully.`);

    // 2. Run Seed (02-seed.sql)
    const seedFile = path.join(rootDir, 'db/init/02-seed.sql');
    if (fs.existsSync(seedFile)) {
      console.log(`Executing seed data: ${seedFile}...`);
      const seedSql = fs.readFileSync(seedFile, 'utf8');
      await client.query(seedSql);
      console.log(`Seed data loaded successfully.`);
    }

    // Verify record counts
    const topicCount = await client.query('SELECT COUNT(*) FROM topics');
    const lessonCount = await client.query('SELECT COUNT(*) FROM lessons');
    const questionCount = await client.query('SELECT COUNT(*) FROM questions');
    const choiceCount = await client.query('SELECT COUNT(*) FROM choices');
    const flashcardCount = await client.query('SELECT COUNT(*) FROM flashcards');

    console.log('\n=========================================');
    console.log('Database Initialization Summary (Raw SQL):');
    console.log(`- Topics:     ${topicCount.rows[0].count}`);
    console.log(`- Lessons:    ${lessonCount.rows[0].count}`);
    console.log(`- Questions:  ${questionCount.rows[0].count}`);
    console.log(`- Choices:    ${choiceCount.rows[0].count}`);
    console.log(`- Flashcards: ${flashcardCount.rows[0].count}`);
    console.log('=========================================\n');
  } catch (err) {
    console.error('Database initialization failed:', err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

run();
