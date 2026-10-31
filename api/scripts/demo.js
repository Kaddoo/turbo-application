// End-to-end walkthrough against a running API + worker, speaking exactly the contract (openapi.yaml). Safe to run repeatedly.
// Start first:  npm start   and   npm run worker    (and  npm run seed  once)
import { sign } from '../src/lib/payments.js';
import { call, expect, login, staffLogin, randPhone, submitVerification, closeDb, uuid, PICK, DROP, until, pool } from '../test/walk-helpers.js';

const say = (s) => console.log('\n\x1b[1m' + s + '\x1b[0m');
const ok = (s, v) => console.log('  ✓', s, v === undefined ? '' : '→ ' + (typeof v === 'object' ? JSON.stringify(v) : v));

say('1. Student signs up (SMS code), submits ID documents, a verifier approves');
const s = await login(randPhone('+23324')); ok('student signed in', s.user.id);
expect(await submitVerification(s.accessToken), 201); ok('documents uploaded and verification submitted');
const v = await staffLogin('verifier@turbo.test');
expect(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: v.accessToken, body: { decision: 'approved' } }), 200);
ok('verifier approved the student');

say('2. Drivers go on duty');
await pool.query('UPDATE drivers SET on_duty=false, duty_since=NULL');
const drivers = [];
for (const [i, [lat, lng]] of [[5.7210, 0.0760], [5.7300, 0.0900], [5.7000, 0.0500]].entries()) {
  const d = await login('+23320000000' + (i + 1), 'driver'); drivers.push(d);
  expect(await call('PUT', '/driver/duty', { token: d.accessToken, body: { onDuty: true } }), 200);
  expect(await call('PUT', '/driver/location', { token: d.accessToken, body: { points: [{ point: { lat, lng }, recordedAt: new Date().toISOString() }] } }), 204);
}
ok('3 drivers on duty, reporting location');

say('3. Booking without money is refused; then top up (signed Payaza-style webhook)');
const q0 = expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
ok('quote', { eligible: q0.eligible, fare: q0.farePesewas, km: q0.routeDistanceMeters / 1000, sufficient: q0.wallet.sufficient });
const r0 = await call('POST', '/rides', { token: s.accessToken, body: { quoteId: q0.quoteId }, idem: true });
ok('book with empty wallet', `${r0.status} ${r0.body.code}`);
const tu = expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 10000, channel: 'mobile_money' }, idem: true }), 201);
const payload = JSON.stringify({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '100.00', amount_validation: 'EXACT' });
const hook = (sig) => call('POST', '/webhooks/payaza', { raw: payload, headers: { 'x-payaza-signature': sig, 'content-type': 'application/json' } });
ok('bad signature rejected', (await hook('nope')).status);
ok('webhook #1', (await hook(sign(Buffer.from(payload)))).status);
ok('webhook #2 (replay, credited once)', (await hook(sign(Buffer.from(payload)))).status);
ok('wallet', expect(await call('GET', '/wallet', { token: s.accessToken }), 200));

say('4. Book, auto-assign, ride, pay');
const q1 = expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
const key = uuid();
const [b1, b2] = await Promise.all([1, 2].map(() => call('POST', '/rides', { token: s.accessToken, body: { quoteId: q1.quoteId }, idem: key })));
ok('double-tap with the same Idempotency-Key → one ride', [b1.status, b2.status].sort().join(','));
const ride = [b1, b2].find((b) => b.status === 201).body;
ok('ride created, fare held', { status: ride.status, payment: ride.payment.status });
const assigned = await until(async () => { const r = expect(await call('GET', `/rides/${ride.id}`, { token: s.accessToken }), 200); return r.status === 'assigned' && r; });
ok('worker assigned the nearest driver', assigned.driver.firstName + ' in ' + assigned.vehicle.colour + ' ' + assigned.vehicle.plateNumber);
let drv;
for (const d of drivers) { const c = await call('GET', '/driver/rides/current', { token: d.accessToken }); if (c.status === 200) { drv = d; ok('driver sees the offer, with price and ETA', { fare: c.body.farePesewas, etaSeconds: c.body.pickupEtaSeconds, pickup: c.body.pickup.label }); } }
ok('student sees the start PIN', assigned.pin);
expect(await call('POST', `/driver/rides/${ride.id}/ack`, { token: drv.accessToken }), 200);
expect(await call('POST', `/driver/rides/${ride.id}/arrived`, { token: drv.accessToken, body: {} }), 200);
ok('wrong PIN', (await call('POST', `/driver/rides/${ride.id}/start`, { token: drv.accessToken, body: { pin: assigned.pin === '0000' ? '1111' : '0000' } })).body.code);
expect(await call('POST', `/driver/rides/${ride.id}/start`, { token: drv.accessToken, body: { pin: assigned.pin } }), 200);
ok('student cancel during trip', (await call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: {} })).body.code);
expect(await call('POST', `/driver/rides/${ride.id}/complete`, { token: drv.accessToken, body: { location: DROP.point } }), 200);
ok('wallet after completion', expect(await call('GET', '/wallet', { token: s.accessToken }), 200));
ok('receipt', (({ receiptNumber, totalPesewas }) => ({ receiptNumber, totalPesewas }))(expect(await call('GET', `/rides/${ride.id}/receipt`, { token: s.accessToken }), 200)));
ok('ledger', expect(await call('GET', '/wallet/transactions', { token: s.accessToken }), 200).data.map((i) => `${i.type}:${i.amountPesewas} → ${i.balanceAfterPesewas}`));

say('5. Free cancellation releases the hold');
const q2 = expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
const r2 = expect(await call('POST', '/rides', { token: s.accessToken, body: { quoteId: q2.quoteId }, idem: true }), 201);
expect(await call('POST', `/rides/${r2.id}/cancel`, { token: s.accessToken, body: { reasonCode: 'student_changed_mind' } }), 200);
ok('wallet after cancel', expect(await call('GET', '/wallet', { token: s.accessToken }), 200));

say('6. Staff view');
const a = await staffLogin('admin@turbo.test');
ok('stats', expect(await call('GET', '/admin/stats', { token: a.accessToken }), 200));
ok('ride timeline', expect(await call('GET', `/admin/rides/${ride.id}`, { token: (await staffLogin('dispatch@turbo.test')).accessToken }), 200).events.map((e) => e.type));
for (const d of drivers) await call('PUT', '/driver/duty', { token: d.accessToken, body: { onDuty: false } });
console.log('\nDemo complete.');
await closeDb();
