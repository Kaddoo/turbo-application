// Attack-shaped inputs against a running API. Every case is something a real attacker (or a broken client) would send.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid, uploadFile, JPEG, approvedStudent, PICK, DROP, submitVerification } from './walk-helpers.js';
import { sign } from '../src/lib/payments.js';
after(closeDb);
const BASE = process.env.BASE_URL || 'http://localhost:3000';
const st = async (email) => (await staffLogin(email)).accessToken;
const J = { 'content-type': 'application/json' };

test('prototype pollution keys, NUL bytes, control and bidi characters are refused everywhere', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  const evil = ['{"fullName":"x","__proto__":{"isAdmin":true}}', '{"a":{"constructor":{"prototype":{"x":1}}}}', '{"fullName":"Ama\\u0000"}', '{"fullName":"Esi\\u202eevil"}', '{"fullName":"a\\u0007b"}', '{"fullName":"\\ud800"}'];
  for (const raw of evil) assert.equal((await call('PATCH', '/me', { token: t, raw, headers: J })).status, 400, raw);
  assert.equal(({}).isAdmin, undefined, 'Object.prototype untouched');
  let deep = '1'; for (let i = 0; i < 20; i++) deep = `{"a":${deep}}`;
  assert.equal((await call('PATCH', '/me', { token: t, raw: deep, headers: J })).status, 400, 'deep nesting');
  assert.equal((await call('PATCH', '/me', { token: t, raw: '{"fullName":"' + 'x'.repeat(6000) + '"}', headers: J })).status, 400, 'giant string');
  expect(await call('PATCH', '/me', { token: t, body: { fullName: 'Ama Test' } }), 200, 'normal input still works');
});

test('bodies must be JSON objects with the right content type; queries must be single plain values', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  for (const raw of ['[]', '5', '"x"', 'null']) assert.equal((await call('PATCH', '/me', { token: t, raw, headers: J })).status, 400, raw);
  assert.equal((await call('PATCH', '/me', { token: t, raw: '{"fullName":"A B"}', headers: { 'content-type': 'text/plain' } })).status, 415);
  assert.equal((await call('PATCH', '/me', { token: t, raw: '{bad json', headers: J })).status, 400);
  const v = await st('verifier@turbo.test');
  assert.equal((await call('GET', '/admin/verifications?status=pending&status=approved', { token: v })).status, 400, 'array query');
  assert.equal((await call('GET', '/admin/verifications?__proto__=1', { token: v })).status, 400);
  assert.equal((await call('GET', '/admin/verifications?limit=' + 'a'.repeat(500), { token: v })).status, 400);
  assert.equal((await call('GET', '/admin/verifications?limit=abc', { token: v })).status, 400, 'a junk limit is refused, not ignored');
  assert.equal((await call('GET', '/admin/verifications?status=bogus', { token: v })).status, 422, 'unknown filter value');
});

test('bad ids and database-shaped input become 4xx and never leak internals', async () => {
  const s = await login(randPhone()), d = await st('dispatch@turbo.test');
  const r = await call('POST', '/admin/rides/zzz-bad-id/cancel', { token: d, body: { reason: 'testing it' } });
  assert.equal(r.status, 404);
  assert.ok(!JSON.stringify(r.body).match(/uuid|postgres|syntax|select|pg_/i), 'no database wording in the response');
  assert.equal((await call('POST', '/rides/zzz-bad-id/rating', { token: s.accessToken, body: { stars: 5 } })).status, 404);
  assert.equal((await call('GET', '/admin/verifications/' + 'z'.repeat(36), { token: await st('verifier@turbo.test') })).status, 404);
  const big = await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 1e20, channel: 'mobile_money' }, idem: true });
  assert.equal(big.status, 422);
});

test('JWT attacks: none algorithm, wrong secret, tampered role, junk, other issuer', async () => {
  const s = await login(randPhone());
  const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
  const none = `${b64({ alg: 'none', typ: 'JWT' })}.${b64({ sub: s.user.id, role: 'admin', staffRole: 'super_admin', iss: 'turbo-api' })}.`;
  const hs = (payload, secret) => { const h = b64({ alg: 'HS256', typ: 'JWT' }), p = b64(payload); return `${h}.${p}.${crypto.createHmac('sha256', secret).update(`${h}.${p}`).digest('base64url')}`; };
  const exp = Math.floor(Date.now() / 1000) + 600;
  const cases = [none, hs({ sub: s.user.id, role: 'admin', staffRole: 'super_admin', iss: 'turbo-api', exp }, 'guess'),
    hs({ sub: s.user.id, role: 'admin', staffRole: 'super_admin', exp }, 'dev-secret-dev-secret-dev-secret-00'), s.accessToken.slice(0, -4) + 'AAAA', 'Bearer', '', 'x'.repeat(5000)];
  for (const tok of cases) assert.equal((await call('GET', '/admin/staff', { token: tok })).status, 401);
  assert.equal((await call('GET', '/admin/staff', { token: s.accessToken })).status, 403, 'a real student token is not staff');
});

test('role and ownership boundaries: students, drivers and staff roles cannot cross over', async () => {
  const s = await login(randPhone()), other = await login(randPhone());
  const d = await login('+233200000003', 'driver');
  for (const [m, p] of [['GET', '/driver/profile'], ['GET', '/admin/incidents'], ['GET', '/admin/support/tickets'], ['GET', '/admin/topups'], ['GET', '/admin/staff']])
    assert.equal((await call(m, p, { token: s.accessToken })).status, 403, `student on ${p}`);
  for (const p of ['/wallet', '/me/trusted-contacts', '/rides']) assert.equal((await call('GET', p, { token: d.accessToken })).status, 403, `driver on ${p}`);
  const ticket = expect(await call('POST', '/support/tickets', { token: s.accessToken, body: { category: 'other', subject: 'private', message: 'secret' } }), 201);
  assert.equal((await call('GET', `/support/tickets/${ticket.id}`, { token: other.accessToken })).status, 404);
  assert.equal((await call('POST', `/support/tickets/${ticket.id}/messages`, { token: other.accessToken, body: { body: 'hi' } })).status, 404);
  const v = await st('verifier@turbo.test'), fin = await st('finance@turbo.test');
  assert.equal((await call('GET', '/admin/topups', { token: v })).status, 403, 'verifier cannot see finance');
  assert.equal((await call('GET', '/admin/verifications', { token: fin })).status, 403, 'finance cannot read identity documents');
  assert.equal((await call('PUT', '/admin/settings', { token: fin, body: {} })).status, 403);
  // a student cannot ride on another student's quote or ride
  const a = await approvedStudent(20000), b = await approvedStudent(20000);
  const q = expect(await call('POST', '/rides/quote', { token: a.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
  if (q.eligible) assert.equal((await call('POST', '/rides', { token: b.accessToken, body: { quoteId: q.quoteId }, idem: true })).status, 404, "someone else's quote");
});

test('admin settings, fare bands and boundary refuse nonsense', async () => {
  const sa = await st('admin@turbo.test');
  const cur = expect(await call('GET', '/admin/settings', { token: sa }), 200);
  const area = expect(await call('GET', '/service-area'), 200);
  const bad = async (path, body, why) => assert.equal((await call('PUT', path, { token: sa, body })).status, 422, why);
  await bad('/admin/settings', { ...cur, maxTripDistanceMeters: -1 }, 'negative limit');
  await bad('/admin/settings', { ...cur, maxTripDistanceMeters: '18000' }, 'string number');
  await bad('/admin/settings', { ...cur, quoteTtlSeconds: 1e9 }, 'absurd ttl');
  await bad('/admin/settings', { ...cur, pauseMessage: { x: 1 } }, 'object message');
  await bad('/admin/settings', { ...cur, minTopupPesewas: 90000, maxTopupPesewas: 1000 }, 'min above max');
  await bad('/admin/settings', { ...cur, nonsense: 1 }, 'unknown setting');
  await bad('/admin/fare-bands', { bands: [] }, 'empty');
  await bad('/admin/fare-bands', { bands: [{ upToMeters: 3000, farePesewas: -100 }] }, 'negative fare');
  await bad('/admin/fare-bands', { bands: [{ upToMeters: 6000, farePesewas: 2000 }, { upToMeters: 3000, farePesewas: 3000 }] }, 'descending distances');
  await bad('/admin/fare-bands', { bands: [{ upToMeters: 3000, farePesewas: 150 }] }, 'not whole cedis');
  await bad('/admin/service-area', { boundary: { type: 'Polygon', coordinates: [[[0, 0], [1, 0], [1, 1], [0, 1]]] } }, 'ring not closed');
  await bad('/admin/service-area', { boundary: { type: 'Polygon', coordinates: [[[0, 0], [999, 0], [1, 1], [0, 0]]] } }, 'longitude 999');
  await bad('/admin/service-area', { boundary: { type: 'Polygon', coordinates: [[[0, 0], ['a', 0], [1, 1], [0, 0]]] } }, 'text coordinate');
  await bad('/admin/service-area', { boundary: { type: 'Polygon', coordinates: Array.from({ length: 600 }, () => [[0, 0]]) } }, 'too many rings');
  expect(await call('PUT', '/admin/settings', { token: sa, body: cur }), 200);
  expect(await call('PUT', '/admin/service-area', { token: sa, body: { boundary: area.boundary } }), 200);
});

test('wallet adjustments and refunds are bounded and well-formed', async () => {
  const fin = await st('finance@turbo.test'), s = await login(randPhone());
  const adj = (body) => call('POST', `/admin/students/${s.user.id}/wallet/adjustments`, { token: fin, body, idem: true });
  for (const body of [{ amountPesewas: 1e12, reasonCode: 'goodwill', note: 'x' }, { amountPesewas: 0, reasonCode: 'goodwill', note: 'x' }, { amountPesewas: 1.5, reasonCode: 'goodwill', note: 'x' },
    { amountPesewas: 100, reasonCode: 'DROP TABLE;', note: 'x' }, { amountPesewas: 100, reasonCode: 'goodwill', note: 'x'.repeat(400) }, { amountPesewas: '100', reasonCode: 'goodwill', note: 'x' }])
    assert.equal((await adj(body)).status, 422, JSON.stringify(body).slice(0, 60));
  assert.equal((await call('POST', `/admin/students/${s.user.id}/wallet/adjustments`, { token: fin, body: { amountPesewas: 100, reasonCode: 'goodwill', note: 'ok' } })).status, 422, 'Idempotency-Key required');
});

test('top-ups: flood limited, webhooks only for payaza, absurd credits held for review', async () => {
  const s = await login(randPhone('+23327')), t = s.accessToken;
  const topup = (body) => call('POST', '/wallet/topups', { token: t, body, idem: true });
  assert.equal((await topup({ amountPesewas: 1000, channel: 'HACK; DROP' })).status, 422);
  assert.equal((await topup({ amountPesewas: 1000, channel: { a: 1 } })).status, 422);
  const first = expect(await topup({ amountPesewas: 1000, channel: 'mobile_money' }), 201);
  await topup({ amountPesewas: 1000, channel: 'mobile_money' }); await topup({ amountPesewas: 1000, channel: 'mobile_money' });
  assert.equal((await topup({ amountPesewas: 1000, channel: 'mobile_money' })).status, 429, 'more than 3 open prompts');
  const raw = JSON.stringify({ transaction_reference: first.reference, transaction_status: 'Funds Received', amount_received: '10.00' });
  assert.equal((await call('POST', '/webhooks/stripe', { raw, headers: { 'x-payaza-signature': sign(Buffer.from(raw)), 'content-type': 'application/json' } })).status, 404, 'unknown provider');
  const big = JSON.stringify({ transaction_reference: first.reference, transaction_status: 'Funds Received', amount_received: '500.00' });
  assert.equal((await call('POST', '/webhooks/payaza', { raw: big, headers: { 'x-payaza-signature': sign(Buffer.from(big)), 'content-type': 'application/json' } })).status, 200);
  assert.equal(expect(await call('GET', '/wallet', { token: t }), 200).balancePesewas, 0, 'nothing credited');
  assert.equal((await pool.query('SELECT flagged FROM topups WHERE reference=$1', [first.reference])).rows[0].flagged, true);
});

test('OTP: cooldown, keyed hashes, junk types refused, wrong-code cap', async () => {
  const phone = randPhone('+23329');
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [phone]);
  expect(await call('POST', '/auth/otp/request', { body: { phone, role: 'student' } }), 202);
  const again = await call('POST', '/auth/otp/request', { body: { phone, role: 'student' } });
  assert.equal(again.status, 429); assert.ok(again.headers.get('retry-after'));
  const { rows: [c] } = await pool.query('SELECT code_hash FROM otp_challenges WHERE phone=$1', [phone]);
  assert.notEqual(c.code_hash, crypto.createHash('sha256').update('123456' + phone).digest('hex'), 'not a bare SHA-256 anyone can precompute');
  const v = (code) => call('POST', '/auth/otp/verify', { body: { phone, code, role: 'student', clientType: 'mobile' } });
  for (const code of [123456, ['123456'], '12345']) assert.ok([400, 422].includes((await v(code)).status), String(code));
  assert.equal((await call('POST', '/auth/otp/verify', { body: { phone: { $ne: 1 }, code: '123456', role: 'student', clientType: 'mobile' } })).status, 422);
  for (const rt of [5, { a: 1 }, ['x']]) assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: rt } })).status, 422);
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: 'x'.repeat(500) } })).status, 401);
  assert.equal((await call('POST', '/auth/otp/request', { body: { phone: '+4477001234567', role: 'student' } })).status, 422, 'only +233 numbers');
  for (const code of ['000001', '000002', '000003']) assert.equal((await v(code)).status, 401);
  assert.equal((await v('123456')).status, 429, 'even the right code is refused after 3 misses');
});

test('staff login: unknown and known accounts look the same, and cost the same', async () => {
  const L = (email, password = 'nope-nope-nope') => call('POST', '/auth/admin/login', { body: { email, password } });
  const wrong = await L('finance@turbo.test'), ghost = await L('ghost@turbo.test');
  assert.equal(wrong.status, 401); assert.equal(ghost.status, 401);
  assert.equal(wrong.body.code, ghost.body.code); assert.equal(wrong.body.title, ghost.body.title);
  for (const body of [{ email: 5, password: 'x'.repeat(12) }, { email: 'a@b.co', password: { $gt: '' } }, { email: ['a@b.co'], password: 'x'.repeat(12) }, {}])
    assert.equal((await call('POST', '/auth/admin/login', { body })).status, 422);
  const t = async (email) => { const s = process.hrtime.bigint(); await L(email, 'wrong-wrong-1'); return Number(process.hrtime.bigint() - s) / 1e6; };
  const real = Math.min(await t('verifier@turbo.test'), await t('verifier@turbo.test')), none = Math.min(await t('nobody1@turbo.test'), await t('nobody2@turbo.test'));
  assert.ok(Math.abs(real - none) < Math.max(real, none) * 0.6 + 15, `timing leak? known ${real.toFixed(0)}ms vs unknown ${none.toFixed(0)}ms`);
});

test('uploads: parallel PUTs cannot overwrite, files are sandboxed, quotas hold, foreign uploads cannot be attached', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  const slot = expect(await call('POST', '/uploads', { token: t, body: { purpose: 'student_id', contentType: 'image/jpeg', sizeBytes: JPEG.length } }), 201);
  const other = Buffer.from(JPEG); other[10] = 9;
  const put = (body) => fetch(slot.uploadUrl, { method: 'PUT', headers: { 'content-type': 'image/jpeg' }, body });
  const results = await Promise.all([put(JPEG), put(other), put(JPEG), put(other), put(JPEG)]);
  assert.equal(results.filter((r) => r.status === 204).length, 1, 'exactly one writer wins');
  assert.ok(results.every((r) => [204, 409].includes(r.status)));
  assert.equal((await pool.query('SELECT status FROM uploads WHERE id=$1', [slot.uploadId])).rows[0].status, 'stored');

  const mine = await uploadFile(t, 'ghana_card_front'), intruder = await login(randPhone());
  const [b, i, sf] = await Promise.all(['ghana_card_back', 'student_id', 'selfie_with_card'].map((p) => uploadFile(intruder.accessToken, p)));
  assert.equal((await call('POST', '/me/verification', { token: intruder.accessToken, body: { fullName: 'Thief Person', studentIdNumber: 'X1', ghanaCardNumber: 'GHA-123456789-0',
    ghanaCardFrontUploadId: mine, ghanaCardBackUploadId: b, studentIdUploadId: i, selfieUploadId: sf } })).status, 422, "cannot attach another student's document");

  for (let k = 0; k < 6; k++) await call('POST', '/uploads', { token: t, body: { purpose: 'support_attachment', contentType: 'application/pdf', sizeBytes: 10485760 } });
  assert.equal((await call('POST', '/uploads', { token: t, body: { purpose: 'support_attachment', contentType: 'application/pdf', sizeBytes: 10485760 } })).status, 429, '60 MB a day');

  const ver = await st('verifier@turbo.test'), fresh = await login(randPhone());
  expect(await submitVerification(fresh.accessToken), 201);
  const detail = expect(await call('GET', `/admin/verifications/${fresh.user.id}`, { token: ver }), 200);
  const file = await fetch(detail.documents[0].url);
  assert.match(file.headers.get('content-security-policy'), /sandbox/); assert.equal(file.headers.get('x-content-type-options'), 'nosniff');
  assert.equal((await fetch(detail.documents[0].url.replace(/sig=[^&]+/, 'sig=AAAA'))).status, 403);
  assert.equal((await fetch(`${BASE}/files/${slot.uploadId}/file${new URL(slot.uploadUrl).search}`)).status, 403, 'an upload link cannot be used to read');
});

test('trip-share SMS and SOS cannot be abused to message arbitrary numbers or flood staff', async () => {
  const s = await approvedStudent(20000), t = s.accessToken;
  await pool.query(`UPDATE users SET first_name=$2, full_name=$2 WHERE id=$1`, [s.user.id, 'Click http://evil.example/pay now']);
  const c = expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Mum', phone: randPhone('+23324') } }), 201);
  const ride = (await pool.query(`INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,pin) VALUES ($1,'in_progress',5.72,0.07,5.69,-0.03,9000,900,5000,'1234') RETURNING id`, [s.user.id])).rows[0].id;
  const { safeForMessage } = await import('../src/lib/sanitize.js');
  assert.ok(!/http|evil|\.example/i.test(safeForMessage('Click http://evil.example/pay now')), 'links stripped from names used in SMS');
  let last;
  for (let n = 0; n < 4; n++) last = await call('POST', `/rides/${ride}/share`, { token: t, body: { trustedContactIds: [c.id] } });
  assert.equal(last.status, 429, 'the same recipient number gets at most 3 texts a day');
});

test('headers: not cacheable, not frameable; CORS only for listed origins (with credentials); error pages are ours', async () => {
  const h = await call('GET', '/health');
  assert.equal(h.headers.get('x-content-type-options'), 'nosniff'); assert.equal(h.headers.get('x-powered-by'), null);
  assert.match(h.headers.get('content-security-policy'), /default-src 'none'/); assert.match(h.headers.get('cache-control'), /no-store/);
  assert.match((await call('GET', '/service-area')).headers.get('cache-control'), /max-age=300/);
  const evil = await fetch(BASE + '/service-area', { headers: { origin: 'https://evil.example' } });
  assert.equal(evil.headers.get('access-control-allow-origin'), null, 'unlisted origin gets no CORS headers');
  const pre = await fetch(BASE + '/rides', { method: 'OPTIONS', headers: { origin: 'https://evil.example', 'access-control-request-method': 'POST' } });
  assert.equal(pre.headers.get('access-control-allow-origin'), null);
  const ok = await fetch(BASE + '/service-area', { headers: { origin: 'http://localhost:5173' } });
  assert.equal(ok.headers.get('access-control-allow-origin'), 'http://localhost:5173'); assert.equal(ok.headers.get('access-control-allow-credentials'), 'true');
  const nf = await call('GET', '/definitely/not/here'); assert.equal(nf.status, 404);
  assert.ok(!JSON.stringify(nf.body).includes('Cannot GET'), 'no framework error pages');
});

test('per-account rate limit trips on one account without blocking others sharing its IP', async () => {
  const a = await login(randPhone()), b = await login(randPhone());
  const burst = await Promise.all(Array.from({ length: 360 }, () => call('GET', '/wallet', { token: a.accessToken })));
  assert.ok(burst.filter((r) => r.status === 429).length > 0, 'the noisy account is limited');
  assert.equal((await call('GET', '/wallet', { token: b.accessToken })).status, 200, 'a neighbour on the same IP is unaffected');
});
