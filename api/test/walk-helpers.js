// Shared by the contract walk: a tiny client, actors, and checks that fail loudly on any contract violation.
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { pool } from '../src/db.js';

export const BASE = process.env.BASE_URL || 'http://localhost:3000';
export const JPEG = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0, 16, 0x4a, 0x46, 0x49, 0x46, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0xff, 0xd9]);
export const uuid = () => crypto.randomUUID();

export async function call(method, path, { token, body, headers = {}, raw, idem } = {}) {
  const h = { ...(raw === undefined && body !== undefined && { 'content-type': 'application/json' }), ...(token && { authorization: 'Bearer ' + token }),
    ...(idem && { 'idempotency-key': idem === true ? uuid() : idem }), ...headers };
  const r = await fetch(BASE + path, { method, headers: h, body: raw ?? (body !== undefined ? JSON.stringify(body) : undefined) });
  const t = await r.text(); let b = null; try { b = t ? JSON.parse(t) : null; } catch { b = t; }
  return { status: r.status, body: b, headers: r.headers };
}
// The server answers 500 with "CONTRACT VIOLATION ..." when a response does not match openapi.yaml. Surface that text.
export function expect(res, status, what = '') {
  const msg = typeof res.body?.title === 'string' ? res.body.title : JSON.stringify(res.body)?.slice(0, 300);
  assert.equal(res.status, status, `${what} expected ${status}, got ${res.status}: ${msg}`);
  return res.body;
}
export const login = async (phone, role = 'student', clientType = 'mobile') => {
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [phone]);
  expect(await call('POST', '/auth/otp/request', { body: { phone, role } }), 202, 'otp request');
  return expect(await call('POST', '/auth/otp/verify', { body: { phone, code: '123456', role, clientType, acceptedTermsVersion: '1.0', acceptedPrivacyVersion: '1.0' } }), 200, 'otp verify');
};
export const staffLogin = async (email) => expect(await call('POST', '/auth/admin/login', { body: { email, password: 'Turbo-demo-1' } }), 200, 'staff login ' + email);
export const randPhone = (prefix = '+23326') => prefix + String(Math.floor(Math.random() * 9e6) + 1e6);

export async function uploadFile(token, purpose, bytes = JPEG, contentType = 'image/jpeg') {
  const slot = expect(await call('POST', '/uploads', { token, body: { purpose, contentType, sizeBytes: bytes.length } }), 201, 'upload slot');
  const r = await fetch(slot.uploadUrl, { method: 'PUT', headers: { 'content-type': contentType }, body: bytes });
  assert.equal(r.status, 204, 'PUT file ' + (await r.text()));
  return slot.uploadId;
}
export async function submitVerification(token, over = {}) {
  const [f, b, i, s] = await Promise.all(['ghana_card_front', 'ghana_card_back', 'student_id', 'selfie_with_card'].map((p) => uploadFile(token, p)));
  const n = String(Math.floor(Math.random() * 1e9)).padStart(9, '0');
  return call('POST', '/me/verification', { token, body: { fullName: 'Esi Mensah', studentIdNumber: 'CU-' + Date.now() + Math.random().toString(36).slice(2, 6),
    ghanaCardNumber: `GHA-${n}-${Math.floor(Math.random() * 10)}`, ghanaCardFrontUploadId: f, ghanaCardBackUploadId: b, studentIdUploadId: i, selfieUploadId: s, ...over } });
}
export async function approvedStudent(fundPesewas = 0) {
  const s = await login(randPhone());
  expect(await submitVerification(s.accessToken), 201, 'submit verification');
  const v = await staffLogin('verifier@turbo.test');
  expect(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: v.accessToken, body: { decision: 'approved' } }), 200, 'approve');
  if (fundPesewas) await pool.query('UPDATE wallets SET balance_pesewas=$2 WHERE student_id=$1', [s.user.id, fundPesewas]);
  return s;
}
export const closeDb = () => pool.end();
export { pool };

// ---- ride helpers (need the worker running)
export const PICK = { point: { lat: 5.7203, lng: 0.0757 }, label: 'Central Gate' };
export const DROP = { point: { lat: 5.6935, lng: -0.029 }, label: 'Ashaiman China Mall' };
export const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
export const until = async (fn, ms = 20000) => { const t = Date.now(); while (Date.now() - t < ms) { const v = await fn(); if (v) return v; await sleep(400); } throw new Error('timed out waiting'); };

// Only this driver is on duty, so assignment is deterministic.
export async function soleDriver(phone = '+233200000003') {
  await pool.query(`UPDATE rides SET status='cancelled', cancelled_at=now(), cancel_by='system', cancel_reason='test cleanup', cancel_reason_code='other', driver_id=NULL WHERE status IN ('searching','assigned','driver_arrived','in_progress')`);
  await pool.query(`UPDATE drivers SET on_duty=false, duty_since=NULL`);
  const d = await login(phone, 'driver');
  expect(await call('PUT', '/driver/duty', { token: d.accessToken, body: { onDuty: true } }), 200, 'duty on');
  expect(await call('PUT', '/driver/location', { token: d.accessToken, body: { points: [{ point: { lat: 5.7210, lng: 0.0760 }, recordedAt: new Date().toISOString() }] } }), 204, 'location');
  return d;
}
export async function bookRide(s) {
  const q = expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200, 'quote');
  assert.equal(q.eligible, true, JSON.stringify(q.reasons));
  return { quote: q, ride: expect(await call('POST', '/rides', { token: s.accessToken, body: { quoteId: q.quoteId }, idem: true }), 201, 'book') };
}
// stage: 'assigned' | 'in_progress' | 'completed'
export async function rideTo(stage, { fund = 20000, phone } = {}) {
  const s = await approvedStudent(fund), d = await soleDriver(phone);
  const { quote, ride } = await bookRide(s);
  const a = await until(async () => { const r = (await call('GET', `/rides/${ride.id}`, { token: s.accessToken })).body; return r.status === 'assigned' ? r : null; });
  if (stage !== 'assigned') {
    expect(await call('POST', `/driver/rides/${ride.id}/ack`, { token: d.accessToken }), 200);
    expect(await call('POST', `/driver/rides/${ride.id}/arrived`, { token: d.accessToken, body: {} }), 200);
    expect(await call('POST', `/driver/rides/${ride.id}/start`, { token: d.accessToken, body: { pin: a.pin } }), 200);
    if (stage === 'completed') expect(await call('POST', `/driver/rides/${ride.id}/complete`, { token: d.accessToken, body: {} }), 200);
  }
  return { s, d, ride, quote };
}
