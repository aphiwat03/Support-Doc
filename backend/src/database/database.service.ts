import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import pg, { Pool, PoolClient, QueryResult, QueryResultRow } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(DatabaseService.name);
  private pool!: Pool;

  constructor(private readonly configService: ConfigService) {}

  async onModuleInit() {
    const host = this.configService.get<string>('DB_HOST', 'localhost');
    const port = Number(this.configService.get<number>('DB_PORT', 5432));
    const user = this.configService.get<string>('DB_USER', 'postgres');
    const password = this.configService.get<string>('DB_PASSWORD', 'postgres');
    const database = this.configService.get<string>('DB_NAME', 'support_knowledge_db');

    this.pool = new pg.Pool({
      host,
      port,
      user,
      password,
      database,
      max: 10,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 5000,
    });

    try {
      const client = await this.pool.connect();
      const res = await client.query('SELECT current_database(), version()');
      this.logger.log(`PostgreSQL Connected: ${res.rows[0].current_database}`);
      client.release();
    } catch (err: any) {
      this.logger.warn(`PostgreSQL Connection Warning: ${err.message}. Ensure PostgreSQL container is running.`);
    }
  }

  async onModuleDestroy() {
    if (this.pool) {
      await this.pool.end();
      this.logger.log('PostgreSQL Connection Pool closed.');
    }
  }

  async query<T extends QueryResultRow = any>(sql: string, params: any[] = []): Promise<QueryResult<T>> {
    const start = Date.now();
    try {
      const result = await this.pool.query<T>(sql, params);
      const duration = Date.now() - start;
      this.logger.debug(`Executed query in ${duration}ms: ${sql.slice(0, 80).replace(/\s+/g, ' ')}...`);
      return result;
    } catch (err: any) {
      this.logger.error(`Query Error: ${err.message} | SQL: ${sql}`);
      throw err;
    }
  }

  async getClient(): Promise<PoolClient> {
    return this.pool.connect();
  }
}
