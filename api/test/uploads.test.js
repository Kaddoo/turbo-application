// Uploads and document retention (audit F-08, D5). Needs the running API and migrated, seeded DB.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, JPEG, submitVerification } from './walk-helpers.js';
import { purgeDocuments } from '../src/domain/retention.js';
after(closeDb);

test('upload requests are validated by the contract and by role', async () => {
  const t = (await login(randPhone())).accessToken;
  const bad = (body) => call('POST', '/uploads', { token: t, body });
  assert.equal((await bad({ purpose: 'provider_statement', contentType: 'text/csv', sizeBytes: 10 })).status, 422, 'students cannot upload statements');
  assert.equal((await bad({ purpose: 'student_id', contentType: 'image/gif', sizeBytes: 10 })).status, 422);
  assert.equal((await bad({ purpose: 'student_id', contentType: 'image/png', sizeBytes: 10485761 })).status, 422);
  assert.equal((await bad({ purpose: 'student_id', contentType: 'text/csv', sizeBytes: 10 })).status, 422, 'csv is only for statements');
  assert.equal((await bad({ purpose: 'student_id', contentType: 'image/png', sizeBytes: 5, extra: 1 })).status, 422, 'unknown fields refused');
  assert.equal((await call('POST', '/uploads', { body: { purpose: 'student_id', contentType: 'image/png', sizeBytes: 5 } })).status, 401);
  const fin = (await staffLogin('finance@turbo.test')).accessToken, hr = (await staffLogin('hr@turbo.test')).accessToken;
  assert.equal((await call('POST', '/uploads', { token: hr, body: { purpose: 'provider_statement', contentType: 'text/csv', sizeBytes: 10 } })).status, 422, 'HR cannot upload finance statements');
  assert.equal((await call('POST', '/uploads', { token: fin, body: { purpose: 'provider_statement', contentType: 'text/csv', sizeBytes: 10 } })).status, 201);
});

test('PUT checks signature, size, content type and magic bytes, and only works once', async () => {
  const t = (await login(randPhone())).accessToken;
  const slot = expect(await call('POST', '/uploads', { token: t, body: { purpose: 'student_id', contentType: 'image/jpeg', sizeBytes: JPEG.length } }), 201);
  const put = (url, body, type = 'image/jpeg') => fetch(url, { method: 'PUT', headers: { 'content-type': type }, body });
  assert.equal((await put(slot.uploadUrl.replace(/.$/, (c) => (c === 'A' ? 'B' : 'A')), JPEG)).status, 403, 'tampered signature');
  assert.equal((await put(slot.uploadUrl, Buffer.alloc(3))).status, 400, 'wrong size');
  assert.equal((await put(slot.uploadUrl, JPEG, 'image/png')).status, 400, 'wrong content type');
  assert.equal((await put(slot.uploadUrl, Buffer.alloc(JPEG.length, 1))).status, 400, 'bytes are not a JPEG');
  assert.equal((await put(slot.uploadUrl, JPEG)).status, 204);
  assert.equal((await put(slot.uploadUrl, JPEG)).status, 409, 'slot is single use');
});

test('a CSV statement must be real text, not a binary wearing a .csv label', async () => {
  const fin = (await staffLogin('finance@turbo.test')).accessToken;
  const mk = async (bytes) => { const s = expect(await call('POST', '/uploads', { token: fin, body: { purpose: 'provider_statement', contentType: 'text/csv', sizeBytes: bytes.length } }), 201);
    return (await fetch(s.uploadUrl, { method: 'PUT', headers: { 'content-type': 'text/csv' }, body: bytes })).status; };
  assert.equal(await mk(Buffer.from('reference,amount\nA1,5.00\n')), 204);
  assert.equal(await mk(Buffer.from([0x50, 0x4b, 0x03, 0x04, 0, 0, 1, 2, 3, 4])), 400, 'zip bytes');
});

test('documents are deleted N days after a final decision; the decision record stays', async () => {
  const s = await login(randPhone());
  expect(await submitVerification(s.accessToken), 201);
  const v = (await staffLogin('verifier@turbo.test')).accessToken;
  expect(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: v, body: { decision: 'approved' } }), 200);
  const { rows: ups } = await pool.query(`SELECT storage_key FROM uploads WHERE owner_id=$1`, [s.user.id]);
  const file = (k) => new URL('../data/uploads/' + k, import.meta.url);
  assert.ok(ups.every((u) => fs.existsSync(file(u.storage_key))));
  await purgeDocuments(30);
  assert.ok(ups.every((u) => fs.existsSync(file(u.storage_key))), 'too early to purge');
  await pool.query(`UPDATE students SET decided_at = now() - interval '31 days' WHERE user_id=$1`, [s.user.id]);
  assert.ok(await purgeDocuments(30) >= 1);
  assert.ok(ups.every((u) => !fs.existsSync(file(u.storage_key))), 'files gone');
  const d = expect(await call('GET', `/admin/verifications/${s.user.id}`, { token: v }), 200);
  assert.equal(d.documents.length, 0); assert.equal(d.history.length, 1);
});
