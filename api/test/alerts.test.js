// Operational alerts: the inlet helper (off, on, slow, failing, no leaks), the 5xx rate, and the worker checks against a real database.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import { config } from '../src/config.js';
import { log } from '../src/app.js';
import { pool } from '../src/db.js';
import { alert, alertsEnabled, announceAlerts, trackRequest, checkErrorRate, _setClient, _resetErrorRate } from '../src/lib/alerts.js';
import { alertStuckSearching, alertUnackedSos, alertWalletDrift, _forget } from '../src/domain/alert_jobs.js';

after(async () => { await pool.end(); });

const withKeys = (fn) => async () => {
  const was = [config.inletSecretKey, config.inletProductId];
  config.inletSecretKey = 'sk_live_test'; config.inletProductId = 'prd_test';
  try { await fn(); } finally { [config.inletSecretKey, config.inletProductId] = was; _setClient(null); }
};
const fake = () => { const calls = []; return { calls, sendEvent: async (b) => { calls.push(b); return { id: 'evt_1' }; } }; };
const base = { severity: 'critical', dedupeKey: 'k1', title: 'Something broke', detail: 'details' };

test('alerts are off and silent without keys', async () => {
  assert.equal(alertsEnabled(), false);
  const lines = []; const orig = log.info;
  log.info = (...a) => lines.push(a); try { announceAlerts(log); } finally { log.info = orig; }
  assert.equal(lines.length, 1);
  assert.match(lines[0][1], /alerts disabled/);
  assert.equal(await alert(base), false);          // no client built, nothing sent, nothing thrown
});

test('an alert is a custom_alert in the alert module with severity, title and dedupeKey', withKeys(async () => {
  const f = fake(); _setClient(f);
  assert.equal(await alert({ ...base, payload: { rideId: 'abc', count: 3 } }), true);
  const [b] = f.calls;
  assert.equal(f.calls.length, 1);
  assert.deepEqual([b.module, b.type, b.severity, b.dedupeKey, b.productId], ['alert', 'custom_alert', 'critical', 'k1', 'prd_test']);
  assert.equal(b.payload.title, 'Something broke');
  assert.equal(b.payload.rideId, 'abc');
}));

test('an alert needs a severity, a title and a dedupeKey', withKeys(async () => {
  const f = fake(); _setClient(f);
  assert.equal(await alert({ title: 'x', dedupeKey: 'k' }), false);
  assert.equal(await alert({ severity: 'high', title: 'x' }), false);
  assert.equal(f.calls.length, 0);
}));

test('a failing client never throws, is retried once, and the log never holds the payload', withKeys(async () => {
  let tries = 0;
  _setClient({ sendEvent: async () => { tries++; const e = new Error('boom SECRET-IN-MESSAGE'); e.status = 503; throw e; } });
  const seen = []; const orig = log.warn;
  log.warn = (...a) => seen.push(JSON.stringify(a));
  try { assert.equal(await alert({ ...base, detail: 'SECRET-DETAIL', payload: { rideId: 'SECRET-PAYLOAD' } }), false); } finally { log.warn = orig; }
  assert.equal(tries, 2);
  assert.equal(seen.length, 1);
  for (const s of ['SECRET-DETAIL', 'SECRET-PAYLOAD', 'SECRET-IN-MESSAGE']) assert.ok(!seen[0].includes(s), `log leaked ${s}`);
}));

test('tokens, phone numbers, urls and coordinates are dropped from the payload', withKeys(async () => {
  const f = fake(); _setClient(f);
  await alert({ ...base, payload: { rideId: 'r1', accessToken: 't', otpCode: '123456', phone: '+233201234567', signedUrl: 'https://x', lat: 5.6, lng: 0.1, count: 2 } });
  assert.deepEqual(Object.keys(f.calls[0].payload).sort(), ['count', 'detail', 'rideId', 'title']);
}));

test('a hung inlet is given up on after 3 seconds a try', { timeout: 15000 }, withKeys(async () => {
  const srv = http.createServer(() => {});           // accepts and never answers
  await new Promise((r) => srv.listen(0, '127.0.0.1', r));
  const was = config.inletBaseUrl; config.inletBaseUrl = `http://127.0.0.1:${srv.address().port}`;
  _setClient(null);
  const t = Date.now();
  try { assert.equal(await alert(base), false); } finally { config.inletBaseUrl = was; srv.closeAllConnections?.(); srv.close(); }
  const took = Date.now() - t;
  assert.ok(took >= 5500 && took < 9000, `took ${took} ms`);      // two tries of 3 seconds
}));

test('5xx over 2% of the last 5 minutes alerts once enough requests have been seen', withKeys(async () => {
  const f = fake(); _setClient(f); _resetErrorRate();
  const now = Date.now();
  for (let i = 0; i < 40; i++) trackRequest(200, now);
  for (let i = 0; i < 5; i++) trackRequest(500, now);
  assert.equal(await checkErrorRate({ now }), false);            // 45 requests: too few to judge
  for (let i = 0; i < 10; i++) trackRequest(200, now);
  assert.equal(await checkErrorRate({ now }), true);             // 5 of 55 = 9%
  assert.equal(f.calls.length, 1);
  assert.equal(f.calls[0].dedupeKey, 'api-5xx');
  assert.equal(f.calls[0].severity, 'high');
}));

test('a 1% error rate, and old errors, do not alert', withKeys(async () => {
  const f = fake(); _setClient(f); _resetErrorRate();
  const now = Date.now();
  for (let i = 0; i < 99; i++) trackRequest(200, now);
  trackRequest(500, now);
  for (let i = 0; i < 60; i++) trackRequest(500, now - 7 * 60_000);   // outside the 5 minute window
  assert.equal(await checkErrorRate({ now }), false);
  assert.equal(f.calls.length, 0);
}));

// ---- worker checks against a real database -----------------------------------------------------------------------------------------
const db = { skip: !process.env.DATABASE_URL && 'DATABASE_URL not set' };
const q = (sql, p) => pool.query(sql, p);

async function student() {
  const phone = '+23324' + String(Math.floor(Math.random() * 9e6) + 1e6);
  const { rows: [u] } = await q(`INSERT INTO users (role, phone) VALUES ('student', $1) RETURNING id`, [phone]);
  await q(`INSERT INTO students (user_id) VALUES ($1)`, [u.id]);
  return u.id;
}
const ride = async (studentId, status, minutesAgo) => (await q(
  `INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,requested_at)
   VALUES ($1,$2,5.7,0.07,5.69,-0.03,9000,800,3500, now() - make_interval(mins => $3)) RETURNING id`, [studentId, status, minutesAgo])).rows[0].id;

test('the stuck-ride job alerts once for a ride searching over 3 minutes and not for a healthy one', db, async () => {
  _forget();
  const s = await student(), s2 = await student(), s3 = await student();      // one active ride per student
  const stuck = await ride(s, 'searching', 5);
  const fresh = await ride(s2, 'searching', 1);
  const done = await ride(s3, 'completed', 30);
  const sent = [];
  const send = async (a) => { sent.push(a); };
  await alertStuckSearching({ send });
  const mine = () => sent.filter((a) => [stuck, fresh, done].some((id) => a.dedupeKey === `ride-stuck-${id}`));
  assert.equal(mine().length, 1);
  assert.equal(mine()[0].dedupeKey, `ride-stuck-${stuck}`);
  assert.equal(mine()[0].severity, 'critical');
  const total = sent.length;
  assert.equal(await alertStuckSearching({ send }), 0);          // a second minute does not repeat anything
  assert.equal(sent.length, total);
  await q('DELETE FROM rides WHERE student_id = ANY($1)', [[s, s2, s3]]);
});

test('an SOS open over 2 minutes alerts and texts the on-call number; one acknowledged does not', db, async () => {
  _forget();
  const s = await student();
  const open = (await q(`INSERT INTO incidents (type,reporter_id,reporter_role,created_at) VALUES ('sos',$1,'student', now() - interval '3 minutes') RETURNING id`, [s])).rows[0].id;
  await q(`INSERT INTO incidents (type,reporter_id,reporter_role,status,created_at) VALUES ('sos',$1,'student','acknowledged', now() - interval '9 minutes')`, [s]);
  await q(`INSERT INTO incidents (type,reporter_id,reporter_role,created_at) VALUES ('sos',$1,'student', now() - interval '30 seconds')`, [s]);
  const sent = [], texts = [];
  const was = config.sosOncallPhone; config.sosOncallPhone = '+233209998877';
  try {
    assert.equal(await alertUnackedSos({ send: async (a) => { sent.push(a); }, sms: async (to, msg) => { texts.push([to, msg]); } }), 1);
  } finally { config.sosOncallPhone = was; }
  assert.equal(sent.length, 1);
  assert.equal(sent[0].dedupeKey, `sos-${open}`);
  assert.equal(texts.length, 1);
  assert.equal(texts[0][0], '+233209998877');
  assert.ok(!sent[0].detail.includes('233209998877'));
  await q('DELETE FROM incidents WHERE reporter_id=$1', [s]);
});

test('the SOS text still goes when inlet is off', db, async () => {
  _forget();
  const s = await student();
  await q(`INSERT INTO incidents (type,reporter_id,reporter_role,created_at) VALUES ('sos',$1,'student', now() - interval '3 minutes')`, [s]);
  const texts = []; const was = config.sosOncallPhone; config.sosOncallPhone = '+233209998877';
  try { await alertUnackedSos({ sms: async (to) => { texts.push(to); } }); } finally { config.sosOncallPhone = was; }   // default sink: alerts are off
  assert.equal(texts.length, 1);
  await q('DELETE FROM incidents WHERE reporter_id=$1', [s]);
});

test('a wallet that differs from its ledger raises one recon alert', db, async () => {
  _forget();
  const s = await student();
  await q(`INSERT INTO wallets (student_id, balance_pesewas, reserved_pesewas) VALUES ($1, 5000, 0)`, [s]);      // no ledger entry for it
  const sent = [];
  assert.ok((await alertWalletDrift({ send: async (a) => { sent.push(a); } })) >= 1);
  assert.equal(sent.length, 1);
  assert.equal(sent[0].dedupeKey, 'recon');
  await alertWalletDrift({ send: async (a) => { sent.push(a); } });
  assert.equal(sent.length, 1);
  await q('DELETE FROM wallets WHERE student_id=$1', [s]);
});
