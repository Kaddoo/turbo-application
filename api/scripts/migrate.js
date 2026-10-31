import fs from 'node:fs';
import path from 'node:path';
import pg from 'pg';
import { config } from '../src/config.js';

const c = new pg.Client({ connectionString: config.databaseUrl });
await c.connect();
await c.query('CREATE TABLE IF NOT EXISTS _migrations (name text PRIMARY KEY, applied_at timestamptz DEFAULT now())');
const dir = new URL('../migrations/', import.meta.url).pathname;
for (const f of fs.readdirSync(dir).filter((x) => x.endsWith('.sql')).sort()) {
  if ((await c.query('SELECT 1 FROM _migrations WHERE name=$1', [f])).rowCount) continue;
  await c.query('BEGIN');
  try { await c.query(fs.readFileSync(path.join(dir, f), 'utf8')); await c.query('INSERT INTO _migrations(name) VALUES ($1)', [f]); await c.query('COMMIT'); console.log('applied', f); }
  catch (e) { await c.query('ROLLBACK'); console.error('failed', f, e.message); process.exit(1); }
}
await c.end();
