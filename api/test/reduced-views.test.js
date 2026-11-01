// Contract 0.3.1: support may open a student, support and finance may open a ride, each as a reduced and audited view. The owner roles
// (verifier for students, dispatcher for rides) and super admin keep the full record. Needs the running API and a migrated, seeded database.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, staffLogin, randPhone, pool, closeDb, login } from './walk-helpers.js';
after(closeDb);

const tok = async (email) => (await staffLogin(email)).accessToken;
async function fixture() {
  const phone = randPhone();
  const s = await login(phone);
  await pool.query(`UPDATE students SET student_id_number='CU-2024-0042' WHERE user_id=$1`, [s.user.id]);
  const { rows: [r] } = await pool.query(
    `INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,pin) VALUES ($1,'searching',5.7,0.07,5.69,-0.03,9000,800,3500,'4821') RETURNING id`, [s.user.id]);
  await pool.query(`INSERT INTO ride_events (ride_id,type,actor_type,data) VALUES ($1,'sos','student',$2)`, [r.id, JSON.stringify({ location: { lat: 5.7, lng: 0.07 }, secret: 'LIVE-TRAIL' })]);
  return { phone, studentId: s.user.id, rideId: r.id };
}
const audits = async (action, target) => (await pool.query(`SELECT data FROM audit_log WHERE action=$1 AND target=$2`, [action, target])).rows.map((x) => (typeof x.data === 'string' ? JSON.parse(x.data) : x.data));

test('student detail: verifier and super admin see the full record, support sees it without the student id number, audited', async () => {
  const f = await fixture();
  const full = expect(await call('GET', `/admin/students/${f.studentId}`, { token: await tok('verifier@turbo.test') }), 200);
  assert.equal(full.studentIdNumber, 'CU-2024-0042');
  assert.equal(expect(await call('GET', `/admin/students/${f.studentId}`, { token: await tok('admin@turbo.test') }), 200).studentIdNumber, 'CU-2024-0042');
  assert.deepEqual(await audits('student.view_reduced', f.studentId), []);
  const reduced = expect(await call('GET', `/admin/students/${f.studentId}`, { token: await tok('support@turbo.test') }), 200);
  assert.equal(reduced.studentIdNumber, null);
  assert.equal(reduced.id, f.studentId);
  assert.deepEqual(await audits('student.view_reduced', f.studentId), [{ role: 'support' }]);
});

test('student detail stays closed to the other roles', async () => {
  const f = await fixture();
  for (const who of ['finance@turbo.test', 'dispatch@turbo.test', 'hr@turbo.test']) assert.equal((await call('GET', `/admin/students/${f.studentId}`, { token: await tok(who) })).status, 403, who);
});

test('ride detail: dispatcher gets everything; support and finance get the reduced view and each access is audited', async () => {
  const f = await fixture();
  const full = expect(await call('GET', `/admin/rides/${f.rideId}`, { token: await tok('dispatch@turbo.test') }), 200);
  assert.equal(full.ride.pin, null, 'the PIN is never in a staff view');
  assert.ok(full.events.some((e) => e.detail && e.detail.includes('LIVE-TRAIL')));
  assert.equal(full.student.phone, f.phone);
  assert.deepEqual(await audits('ride.view_reduced', f.rideId), []);
  for (const [who, role] of [['support@turbo.test', 'support'], ['finance@turbo.test', 'finance']]) {
    const r = expect(await call('GET', `/admin/rides/${f.rideId}`, { token: await tok(who) }), 200, who);
    assert.equal(r.ride.id, f.rideId); assert.equal(r.ride.farePesewas, 3500); assert.equal(r.ride.status, 'searching');
    assert.equal(r.ride.pin, null, 'no PIN');
    assert.equal(r.driver, null, 'no driver detail or position');
    assert.ok(r.events.length > 0 && r.events.every((e) => e.detail === null), 'no event details');
    assert.ok(!JSON.stringify(r).includes('LIVE-TRAIL'));
    assert.notEqual(r.student.phone, f.phone); assert.match(r.student.phone, /\*\*\*/, 'masked phone');
    assert.ok(!JSON.stringify(r).includes(f.phone.slice(4)), 'the number does not appear anywhere');
    assert.ok((await audits('ride.view_reduced', f.rideId)).some((a) => a.role === role), `audited for ${role}`);
  }
});

test('ride detail stays closed to verifier and HR', async () => {
  const f = await fixture();
  for (const who of ['verifier@turbo.test', 'hr@turbo.test']) assert.equal((await call('GET', `/admin/rides/${f.rideId}`, { token: await tok(who) })).status, 403, who);
});

test('the approval threshold is on /admin/me for finance and super admin only', async () => {
  for (const [who, has] of [['finance@turbo.test', true], ['admin@turbo.test', true], ['support@turbo.test', false], ['dispatch@turbo.test', false], ['verifier@turbo.test', false]]) {
    const me = expect(await call('GET', '/admin/me', { token: await tok(who) }), 200, who);
    if (has) assert.equal(typeof me.adjustmentApprovalThresholdPesewas, 'number', who);
    else assert.ok(!('adjustmentApprovalThresholdPesewas' in me), who);
  }
});

test('finance still cannot read the settings', async () => {
  assert.equal((await call('GET', '/admin/settings', { token: await tok('finance@turbo.test') })).status, 403);
});
