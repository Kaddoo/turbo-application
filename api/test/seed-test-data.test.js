// scripts/seed-test-data.js: creates the TEST set, can be re-run, and --cleanup removes every trace. Needs a migrated database (it writes TEST rows).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { pool } from '../src/db.js';
after(() => pool.end());

const run = (...args) => execFileSync('node', ['scripts/seed-test-data.js', ...args], { env: { ...process.env, NODE_ENV: 'development' }, encoding: 'utf8' });
const count = async (sql) => (await pool.query(sql)).rows[0].n;
// Counted per TEST user: other tests in this suite write rows with a TEST- reference of their own.
const mine = `(SELECT id FROM users WHERE phone IN ('+233209990001','+233209990002','+233209990003'))`;
const testRows = async () => ({
  users: await count(`SELECT count(*)::int n FROM users WHERE id IN ${mine}`),
  rides: await count(`SELECT count(*)::int n FROM rides WHERE student_id IN ${mine}`),
  topups: await count(`SELECT count(*)::int n FROM topups WHERE student_id IN ${mine}`),
  incidents: await count(`SELECT count(*)::int n FROM incidents WHERE reporter_id IN ${mine}`),
  tickets: await count(`SELECT count(*)::int n FROM support_tickets WHERE user_id IN ${mine}`),
});

test('creates the set, re-running resets it, and --cleanup removes everything', async () => {
  run('--cleanup');
  assert.deepEqual(await testRows(), { users: 0, rides: 0, topups: 0, incidents: 0, tickets: 0 });
  run();
  const first = await testRows();
  assert.deepEqual(first, { users: 3, rides: 2, topups: 1, incidents: 1, tickets: 1 });
  assert.equal(await count(`SELECT count(*)::int n FROM rides WHERE student_id IN ${mine} AND status='completed'`), 1);
  assert.equal(await count(`SELECT count(*)::int n FROM rides WHERE student_id IN ${mine} AND status='searching'`), 1);
  assert.equal(await count(`SELECT count(*)::int n FROM topups WHERE student_id IN ${mine} AND flagged AND resolved_at IS NULL`), 1);
  assert.equal(await count(`SELECT count(*)::int n FROM incidents WHERE reporter_id IN ${mine} AND type='safety_report'`), 1, 'a safety report, never an SOS that would page someone');
  run();                                                            // safe to run again
  assert.deepEqual(await testRows(), first);
  run('--cleanup');
  assert.deepEqual(await testRows(), { users: 0, rides: 0, topups: 0, incidents: 0, tickets: 0 });
  assert.equal(await count(`SELECT count(*)::int n FROM support_messages WHERE author_id IN ${mine}`), 0);
});

test('it refuses to run in production', () => {
  assert.throws(() => execFileSync('node', ['scripts/seed-test-data.js'], { env: { ...process.env, NODE_ENV: 'production' }, stdio: 'pipe' }), /Command failed/);
});

test('the demo staff seed refuses a host that is not localhost', () => {
  assert.throws(() => execFileSync('node', ['scripts/seed.js'], { env: { ...process.env, NODE_ENV: 'development', PUBLIC_URL: 'https://api.turbogh.app' }, stdio: 'pipe' }), /Command failed/);
});
