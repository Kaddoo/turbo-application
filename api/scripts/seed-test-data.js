// TEST data for staging, so staff and the dashboard team have something to click: one completed ride, one searching ride, one top-up waiting for
// a finance decision, one safety report and one support ticket. Everything is marked TEST (names start with "TEST", references with "TEST-") and
// belongs to two TEST students and one TEST driver, so it can be wiped. Safe to re-run: it removes the old TEST rows first, so you always get a fresh set.
//   npm run seed-test            create (or reset) the TEST data
//   npm run seed-test -- --cleanup   remove it all and stop
// Never runs in production. It does not create staff accounts and does not touch real users.
import pg from 'pg';
import crypto from 'node:crypto';
import { config } from '../src/config.js';

if (config.env === 'production') { console.error('Refusing to write TEST data in production.'); process.exit(1); }
const cleanupOnly = process.argv.includes('--cleanup');
const PHONES = { studentA: '+233209990001', studentB: '+233209990002', driver: '+233209990003' };
const c = new pg.Client({ connectionString: config.databaseUrl });
await c.connect();

async function cleanup() {
  const { rows: users } = await c.query(`SELECT id FROM users WHERE phone = ANY($1) AND full_name LIKE 'TEST %'`, [Object.values(PHONES)]);
  const ids = users.map((u) => u.id);
  const del = async (sql, p = [ids]) => (await c.query(sql, p)).rowCount;
  const n = {};
  await c.query('BEGIN');
  try {
    // support messages are append-only by trigger; this tool lifts that for TEST rows only, inside this one transaction
    await c.query('ALTER TABLE support_messages DISABLE TRIGGER support_messages_append_only');
    n.messages = await del(`DELETE FROM support_messages WHERE ticket_id IN (SELECT id FROM support_tickets WHERE user_id = ANY($1))`);
    await c.query('ALTER TABLE support_messages ENABLE TRIGGER support_messages_append_only');
    n.tickets = await del(`DELETE FROM support_tickets WHERE user_id = ANY($1)`);
    n.incidents = await del(`DELETE FROM incidents WHERE reporter_id = ANY($1)`);
    n.topups = await del(`DELETE FROM topups WHERE student_id = ANY($1) AND reference LIKE 'TEST-%'`);
    n.rides = await del(`DELETE FROM rides WHERE (student_id = ANY($1) OR driver_id = ANY($1)) AND coalesce(pickup_label,'') LIKE 'TEST %'`);
    n.wallets = await del(`DELETE FROM wallets WHERE student_id = ANY($1)`);
    n.students = await del(`DELETE FROM students WHERE user_id = ANY($1)`);
    n.drivers = await del(`DELETE FROM drivers WHERE user_id = ANY($1)`);
    n.users = await del(`DELETE FROM users WHERE id = ANY($1)`);
    await c.query('COMMIT');
  } catch (e) { await c.query('ROLLBACK'); throw e; }
  return n;
}

const removed = await cleanup();
console.log('removed TEST rows:', JSON.stringify(removed));
if (cleanupOnly) { await c.end(); process.exit(0); }

await c.query('BEGIN');
try {
  const user = async (role, phone, name) => (await c.query(
    `INSERT INTO users (role,phone,first_name,last_name,full_name,terms_version,privacy_version,terms_accepted_at) VALUES ($1,$2,'TEST',$3,$4,'1.0','1.0',now()) RETURNING id`,
    [role, phone, name.replace(/^TEST /, ''), name])).rows[0].id;
  const a = await user('student', PHONES.studentA, 'TEST Student A');
  const b = await user('student', PHONES.studentB, 'TEST Student B');
  const d = await user('driver', PHONES.driver, 'TEST Driver');
  for (const s of [a, b]) {
    await c.query(`INSERT INTO students (user_id, verification_status) VALUES ($1,'approved')`, [s]);
    await c.query(`INSERT INTO wallets (student_id) VALUES ($1)`, [s]);
  }
  await c.query(`INSERT INTO drivers (user_id) VALUES ($1)`, [d]);

  const ride = async (student, status, label, extra = '') => (await c.query(
    `INSERT INTO rides (student_id,driver_id,status,pickup_lat,pickup_lng,pickup_label,drop_lat,drop_lng,drop_label,distance_m,duration_s,fare_pesewas,requested_at${extra ? ',' + extra.cols : ''})
     VALUES ($1,$2,$3,5.7203,0.0757,$4,5.6935,-0.029,$5,9000,800,3500, now() - interval '1 hour'${extra ? ',' + extra.vals : ''}) RETURNING id`,
    [student, status === 'completed' ? d : null, status, `TEST ${label} pickup`, `TEST ${label} drop-off`])).rows[0].id;
  const done = await ride(a, 'completed', 'Completed ride', { cols: 'assigned_at,arrived_at,started_at,completed_at', vals: `now() - interval '55 minutes', now() - interval '50 minutes', now() - interval '48 minutes', now() - interval '35 minutes'` });
  await c.query(`UPDATE rides SET requested_at = now() WHERE id = $1`, [await ride(b, 'searching', 'Searching ride')]);

  await c.query(`INSERT INTO topups (student_id,status,amount_pesewas,amount_received_pesewas,reference,flagged,validation,flag_reason,completed_at)
     VALUES ($1,'succeeded',5000,4500,$2,true,'amount_mismatch','amount_mismatch', now())`, [a, `TEST-${crypto.randomUUID()}`]);
  // A safety report, not an SOS: an unacknowledged SOS pages the on-call person after two minutes.
  await c.query(`INSERT INTO incidents (type,reporter_id,reporter_role,ride_id,note) VALUES ('safety_report',$1,'student',$2,'TEST safety report. Safe to delete.')`, [a, done]);
  const t = (await c.query(`INSERT INTO support_tickets (user_id,user_role,category,subject,ride_id) VALUES ($1,'student','wrong_charge','TEST: I think I was charged twice',$2) RETURNING id`, [a, done])).rows[0].id;
  await c.query(`INSERT INTO support_messages (ticket_id,author,author_id,body) VALUES ($1,'user',$2,'TEST message. Please look at my last ride.')`, [t, a]);
  await c.query('COMMIT');
} catch (e) { await c.query('ROLLBACK'); throw e; }
await c.end();
console.log('created TEST data: 1 completed ride, 1 searching ride, 1 flagged top-up, 1 safety report, 1 support ticket. Remove with: npm run seed-test -- --cleanup');
