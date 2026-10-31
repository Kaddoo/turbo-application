// Simulates the 5000-concurrent target: students polling every ~5 s, drivers pinging every ~5 s.
// Creates synthetic users (phones +233990xxxxxx) directly in the DB, signs tokens locally, hits the API with autocannon.
// Usage: STUDENTS=5000 DRIVERS=500 DURATION=30 BASE_URL=https://api.example.com npm run loadtest
// Run it from a DIFFERENT machine than the server for honest numbers. No limit overrides needed: signed-in traffic is limited per account (about 12 requests/min each here, limit 300), never per IP,
// so a single test machine standing in for a whole campus NAT passes.
import autocannon from 'autocannon';
import pg from 'pg';
import crypto from 'node:crypto';
import { config } from '../src/config.js';
import { signAccess } from '../src/lib/auth.js';

const N = Number(process.env.STUDENTS || 5000), D = Number(process.env.DRIVERS || 500), T = Number(process.env.DURATION || 30);
const BASE = process.env.BASE_URL || 'http://localhost:3000';
const db = new pg.Client({ connectionString: config.databaseUrl }); await db.connect();

console.log(`seeding ${N} students, ${D} drivers...`);
await db.query(`DELETE FROM rides WHERE student_id IN (SELECT id FROM users WHERE phone LIKE '+233990%')`);
await db.query(`DELETE FROM driver_presence WHERE driver_id IN (SELECT id FROM users WHERE phone LIKE '+233991%')`);
await db.query(`INSERT INTO users (role,phone,first_name,full_name,terms_version,privacy_version) SELECT 'student', '+233990' || lpad(g::text,6,'0'), 'L', 'Load Student', '1.0', '1.0' FROM generate_series(1,$1) g ON CONFLICT DO NOTHING`, [N]);
await db.query(`INSERT INTO users (role,phone,first_name,full_name,terms_version,privacy_version) SELECT 'driver', '+233991' || lpad(g::text,6,'0'), 'D', 'Load Driver', '1.0', '1.0' FROM generate_series(1,$1) g ON CONFLICT DO NOTHING`, [D]);
await db.query(`INSERT INTO students (user_id, verification_status) SELECT id,'approved' FROM users WHERE phone LIKE '+233990%' ON CONFLICT DO NOTHING`);
await db.query(`INSERT INTO wallets (student_id, balance_pesewas) SELECT id, 100000 FROM users WHERE phone LIKE '+233990%' ON CONFLICT DO NOTHING`);
await db.query(`INSERT INTO drivers (user_id,on_duty) SELECT id,true FROM users WHERE phone LIKE '+233991%' ON CONFLICT DO NOTHING`);
// one in-progress ride per driver so tracking has real rows to read
await db.query(`INSERT INTO rides (student_id,driver_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,started_at)
  SELECT s.id, d.id, 'in_progress', 5.72,0.075,5.69,-0.03,15000,1800,5000, now() FROM
   (SELECT id, row_number() OVER (ORDER BY phone) rn FROM users WHERE phone LIKE '+233990%') s JOIN
   (SELECT id, row_number() OVER (ORDER BY phone) rn FROM users WHERE phone LIKE '+233991%') d USING (rn)`);
await db.query(`UPDATE users SET terms_version='1.0', privacy_version='1.0' WHERE phone LIKE '+233990%' OR phone LIKE '+233991%'`);
const students = (await db.query(`SELECT u.id, r.id AS ride FROM users u LEFT JOIN rides r ON r.student_id=u.id WHERE u.phone LIKE '+233990%' ORDER BY u.phone`)).rows
  .map((s) => ({ token: signAccess(s.id, 'student', { tv: '1.0|1.0' }), ride: s.ride }));
const drivers = (await db.query(`SELECT id FROM users WHERE phone LIKE '+233991%'`)).rows.map((d) => signAccess(d.id, 'driver', { tv: '1.0|1.0' }));
await db.end();

const run = (title, opts) => new Promise((resolve) => {
  const i = autocannon({ url: BASE, duration: T, timeout: 10, ...opts, title }, (e, r) => resolve(r));
  autocannon.track(i, { renderProgressBar: false, renderLatencyTable: false, renderResultsTable: false });
});
let si = 0, di = 0;
const students_ = run('students', {
  connections: N, overallRate: Math.round(N / 5),            // each student polls once per 5 s
  requests: [{ setupRequest: (req) => {
    const s = students[si++ % students.length];
    return { ...req, method: 'GET', path: s.ride ? `/rides/${s.ride}/tracking` : '/wallet', headers: { authorization: 'Bearer ' + s.token } };
  } }],
});
const drivers_ = run('drivers', {
  connections: D, overallRate: Math.round(D / 5),
  requests: [{ setupRequest: (req) => ({ ...req, method: 'PUT', path: '/driver/location',
    headers: { authorization: 'Bearer ' + drivers[di++ % drivers.length], 'content-type': 'application/json' },
    body: JSON.stringify({ points: [{ point: { lat: 5.7 + Math.random() / 50, lng: 0.07 + Math.random() / 50 }, recordedAt: new Date().toISOString() }] }) }) }],
});
const [a, b] = await Promise.all([students_, drivers_]);
const row = (n, r) => `${n.padEnd(9)} rps=${String(Math.round(r.requests.average)).padStart(5)}  p50=${r.latency.p50}ms  p97.5=${r.latency.p97_5}ms  p99=${r.latency.p99}ms  max=${r.latency.max}ms  2xx=${r['2xx']}  non2xx=${r.non2xx}  errors=${r.errors}  timeouts=${r.timeouts}`;
console.log('\n' + row('students', a) + '\n' + row('drivers', b));
console.log(`\ntarget: ${N} concurrent clients @ 1 request / 5 s = ${Math.round((N + D) / 5)} rps sustained. PASS if non2xx=0, errors=0, p99 < 500 ms.`);
