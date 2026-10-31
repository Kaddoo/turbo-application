// How long does a broadcast to every student take? Gives each load-test student (+233990xxxxxx, created by `npm run loadtest`) a device,
// posts an announcement, and times the worker delivering it. Run the worker with PUSH_SIMULATED_LATENCY_MS=100 to model Google's round trip.
//   PUSH_SIMULATED_LATENCY_MS=100 npm run worker     (separate terminal)       then:      npm run pushload
import { call, expect, staffLogin, pool, closeDb, sleep } from '../test/walk-helpers.js';
const { rows: [n] } = await pool.query(`SELECT count(*)::int n FROM users WHERE phone LIKE '+233990%'`);
if (!n.n) { console.error('Run `npm run loadtest` first: it creates the synthetic students.'); process.exit(1); }
await pool.query(`INSERT INTO devices (user_id,user_type,device_id,fcm_token,platform) SELECT id,'user','pl-'||id,'pl-token-'||id,'android' FROM users WHERE phone LIKE '+233990%' ON CONFLICT DO NOTHING`);
await pool.query(`DELETE FROM notifications WHERE kind='announcement' AND title='pushload'`);
const disp = await staffLogin('dispatch@turbo.test');
const t0 = Date.now();
const ann = expect(await call('POST', '/admin/announcements', { token: disp.accessToken, body: { audience: 'students', title: 'pushload', body: 'Broadcast timing test' } }), 202);
const total = (await pool.query(`SELECT count(*)::int n FROM notifications WHERE data->>'announcementId'=$1`, [ann.id])).rows[0].n;
console.log(`announcement accepted in ${Date.now() - t0} ms; ${total} notifications queued`);
// While the broadcast drains, a time-critical push (a ride offer, priority 10) must NOT queue behind 5,000 low-priority announcements.
const probeUser = (await pool.query(`SELECT id FROM users WHERE phone LIKE '+233990%' ORDER BY phone LIMIT 1`)).rows[0].id;
const probeAt = Date.now();
const { rows: [probe] } = await pool.query(`INSERT INTO notifications (user_id,user_type,kind,title,body,data,priority,expires_at) VALUES ($1,'user','ride_offer','probe','probe','{"type":"ride_offer"}',10, now() + interval '5 minutes') RETURNING id`, [probeUser]);
while ((await pool.query(`SELECT status FROM notifications WHERE id=$1`, [probe.id])).rows[0].status === 'pending') await sleep(100);
console.log(`urgent ride-offer push sent ${Date.now() - probeAt} ms after being queued, in the middle of the broadcast`);
let sent = 0;
while (Date.now() - t0 < 300_000) {
  sent = (await pool.query(`SELECT count(*)::int n FROM notifications WHERE data->>'announcementId'=$1 AND status='sent'`, [ann.id])).rows[0].n;
  // devices registered by tests as deliberately flaky ("retry-...") stay pending by design; don't wait for them
  const flaky = (await pool.query(`SELECT count(*)::int n FROM notifications WHERE data->>'announcementId'=$1 AND status='pending' AND last_error='simulated outage'`, [ann.id])).rows[0].n;
  if (sent + flaky >= total) break; await sleep(500);
}
console.log(`${sent}/${total} delivered in ${((Date.now() - t0) / 1000).toFixed(1)} s  (${Math.round(sent / ((Date.now() - t0) / 1000))} per second)`);
// leave no trace: the synthetic devices would otherwise receive every later announcement
await pool.query(`DELETE FROM notifications WHERE title IN ('pushload','probe')`);
await pool.query(`DELETE FROM devices WHERE device_id LIKE 'pl-%'`);
await closeDb();
