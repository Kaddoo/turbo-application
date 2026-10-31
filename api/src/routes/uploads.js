import express, { Router } from 'express';
import { q } from '../db.js';
import { authenticate } from '../lib/auth.js';
import { ApiError, bad, notFound } from '../lib/errors.js';
import { isUuid } from '../lib/util.js';
import * as storage from '../lib/storage.js';

export const uploads = Router();

const TYPES = ['image/jpeg', 'image/png', 'application/pdf', 'text/csv'];
const MAX = 10 * 1024 * 1024;
// Who may upload what. The caller's role comes from the token, never from the body.
const ALLOWED = {
  student: ['ghana_card_front', 'ghana_card_back', 'student_id', 'selfie_with_card', 'support_attachment'],
  driver: ['support_attachment'],
  admin: ['driver_document', 'vehicle_document', 'support_attachment', 'provider_statement'],   
};
const OWNER_TYPE = { student: 'student', driver: 'driver', admin: 'staff' };

uploads.post('/uploads', authenticate, async (req, res) => {
  const { purpose, contentType, sizeBytes } = req.body || {};
  const errors = [];
  if (!ALLOWED[req.user.role]?.includes(purpose)) errors.push({ field: 'purpose', message: 'not allowed for this account' });
  if (!TYPES.includes(contentType)) errors.push({ field: 'contentType', message: 'must be image/jpeg, image/png, application/pdf or text/csv' });
  if (contentType === 'text/csv' && purpose !== 'provider_statement') errors.push({ field: 'contentType', message: 'text/csv is only for provider_statement' });
  if (purpose === 'provider_statement' && contentType !== 'text/csv') errors.push({ field: 'contentType', message: 'a provider statement must be a CSV' });
  if (!Number.isInteger(sizeBytes) || sizeBytes < 1 || sizeBytes > MAX) errors.push({ field: 'sizeBytes', message: 'must be 1 to 10485760' });
  // Staff upload only what their role handles: statements are finance's, driver and vehicle papers are HR's.
  const STAFF_ONLY = { provider_statement: ['finance'], driver_document: ['hr'], vehicle_document: ['hr'], support_attachment: ['support'] };
  if (req.user.role === 'admin' && STAFF_ONLY[purpose] && req.user.staffRole !== 'super_admin' && !STAFF_ONLY[purpose].includes(req.user.staffRole))
    errors.push({ field: 'purpose', message: 'your staff role cannot upload this kind of file' });      // 422, the only refusal the contract declares for this endpoint
  if (errors.length) throw new ApiError(422, 'validation_failed', 'Invalid upload request', { errors });

  // Quotas stop one account filling the disk. A student or driver needs a handful of photos: 30 slots an hour and 60 MB a day.
  // Staff legitimately upload in bulk (HR onboarding a batch of drivers brings 3 to 4 documents each), so they get a far higher ceiling.
  const [perHour, perDay] = req.user.role === 'admin' ? [600, 1024 * 1024 * 1024] : [30, 60 * 1024 * 1024];
  const { rows: [n] } = await q(`SELECT count(*) FILTER (WHERE created_at > now() - interval '1 hour')::int per_hour, COALESCE(sum(size_bytes),0)::bigint bytes
                                   FROM uploads WHERE owner_id=$1 AND created_at > now() - interval '1 day'`, [req.user.id]);
  if (n.per_hour >= perHour || n.bytes + sizeBytes > perDay) throw new ApiError(429, 'rate_limited', 'Upload limit reached, try again later', { retryAfterSeconds: 600 });

  const { rows: [u] } = await q(
    `INSERT INTO uploads (owner_id,owner_type,purpose,content_type,size_bytes,storage_key) VALUES ($1,$2,$3,$4,$5,'') RETURNING id`,
    [req.user.id, OWNER_TYPE[req.user.role], purpose, contentType, sizeBytes]);
  await q('UPDATE uploads SET storage_key=$2 WHERE id=$1', [u.id, storage.newKey(u.id)]);
  const { url, expiresAt } = storage.signedUrl('PUT', u.id, 600);
  res.status(201).json({ uploadId: u.id, uploadUrl: url, method: 'PUT', headers: { 'content-type': contentType }, expiresAt });
});

// The signature is the credential here (a mobile client PUTs straight to us with no bearer token).
// Each request buffers up to 10 MB in memory, so cap how many run at once per process (503 + retry beyond that).
let inFlight = 0;
const MAX_IN_FLIGHT = Number(process.env.UPLOAD_CONCURRENCY || 16);
const gate = (_req, _res, next) => {
  if (inFlight >= MAX_IN_FLIGHT) return next(new ApiError(503, 'conflict', 'Busy, please retry', { retryAfterSeconds: 3 }));
  inFlight++; let done = false; const free = () => { if (!done) { done = true; inFlight--; } };
  _res.on('close', free); _res.on('finish', free);
  next();
};

uploads.put('/uploads/:id/content', gate, express.raw({ type: () => true, limit: MAX }), async (req, res) => {
  const { id } = req.params;
  if (!isUuid(id) || !storage.checkSignature('PUT', id, req.query.exp, req.query.sig))
    throw new ApiError(403, 'forbidden', 'Upload link is invalid or has expired');
  const { rows: [u] } = await q('SELECT * FROM uploads WHERE id=$1', [id]);
  if (!u) throw notFound('Upload');
  const body = req.body;
  if (!Buffer.isBuffer(body) || body.length !== u.size_bytes) throw bad('Body size does not match the declared sizeBytes');
  if (req.get('content-type')?.split(';')[0].trim() !== u.content_type) throw bad('Content-Type does not match the upload request');
  if (storage.sniff(body, u.content_type) !== u.content_type) throw bad('File contents do not match the declared type');
  // Claim the slot BEFORE touching the disk. Two parallel PUTs with the same link used to both pass the "pending" check and
  // the second could overwrite the first file; now exactly one request wins the claim.
  const { rowCount } = await q(`UPDATE uploads SET status='uploading' WHERE id=$1 AND status='pending'`, [id]);
  if (!rowCount) throw new ApiError(409, 'conflict', 'This upload slot was already used');
  try { await storage.put(u.storage_key, body); }
  catch (e) { await q(`UPDATE uploads SET status='pending' WHERE id=$1`, [id]); throw e; }
  await q(`UPDATE uploads SET status='stored', stored_at=now() WHERE id=$1`, [id]);
  res.status(204).end();
});

// Short-lived signed read link for staff (handed out by the verification detail endpoint, which audits it).
uploads.get('/files/:id/file', async (req, res) => {
  const { id } = req.params;
  if (!isUuid(id) || !storage.checkSignature('GET', id, req.query.exp, req.query.sig))
    throw new ApiError(403, 'forbidden', 'File link is invalid or has expired');
  const { rows: [u] } = await q(`SELECT * FROM uploads WHERE id=$1 AND status='stored'`, [id]);
  if (!u) throw notFound('File');
  // sandbox + default-src none: even a PDF or image crafted to carry script cannot run in the API's origin.
  res.set({ 'content-type': u.content_type, 'cache-control': 'private, no-store', 'x-content-type-options': 'nosniff',
    'content-disposition': 'inline', 'cross-origin-resource-policy': 'cross-origin', 'content-security-policy': "default-src 'none'; sandbox" });
  res.send(await storage.get(u.storage_key));
});
