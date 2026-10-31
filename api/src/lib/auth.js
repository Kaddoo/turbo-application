import jwt from 'jsonwebtoken';
import crypto from 'node:crypto';
import { config } from '../config.js';
import { ApiError } from './errors.js';
import { q, tx } from '../db.js';
import { sha256, randomToken } from './util.js';
import { hit } from './ratelimit.js';
import { ensureBody } from './contract.js';

export const signAccess = (sub, role, extra = {}) =>
  jwt.sign({ sub, role, ...extra }, config.jwtSecret, { expiresIn: '15m', algorithm: 'HS256', issuer: 'turbo-api' });

// Stateless: no DB hit per request. 15 min token life bounds suspended-account exposure.
export function authenticate(req, _res, next) {
  const h = req.headers.authorization || '';
  if (!h.startsWith('Bearer ')) return next(new ApiError(401, 'unauthenticated', 'Sign in required'));
  try {
    const p = jwt.verify(h.slice(7, 2048), config.jwtSecret, { algorithms: ['HS256'], issuer: 'turbo-api' });
    if (!['student', 'driver', 'admin'].includes(p.role) || typeof p.sub !== 'string') throw new Error('bad claims');
    req.user = { id: p.sub, role: p.role, staffRole: p.staffRole, sid: p.sid, tv: p.tv };
    // Per account, not per IP: 5000 people share campus and carrier addresses, but one account is one person.
    const wait = hit(`u:${p.sub}`, config.rateUserPerMin, 60_000);
    if (wait) return next(new ApiError(429, 'rate_limited', 'Too many requests', { retryAfterSeconds: wait }));
  } catch {
    return next(new ApiError(401, 'invalid_token', 'Invalid or expired token'));
  }
  // Endpoints open to any signed-in user have no role check after this, so the body is validated here; the rest validate in requireRole.
  try { if (req.contractOp?.op['x-roles']?.includes('any')) ensureBody(req); } catch (e) { return next(e); }
  next();
}

// roles: 'student' | 'driver' | 'admin' ; staffRoles optional list; super_admin always passes
export const requireRole = (role, staffRoles) => (req, _res, next) => {
  if (req.user.role !== role) return next(new ApiError(403, 'forbidden', 'Not allowed for this account'));
  if (staffRoles && req.user.staffRole !== 'super_admin' && !staffRoles.includes(req.user.staffRole))
    return next(new ApiError(403, 'forbidden', 'Your staff role cannot do this'));
  try { ensureBody(req); } catch (e) { return next(e); }
  next();
};

export async function issueRefresh(c, subjectId, subjectType, familyId = crypto.randomUUID(), meta = {}) {
  const token = randomToken(40);
  await c.query(
    `INSERT INTO refresh_tokens (family_id, subject_id, subject_type, token_hash, expires_at, platform, device_name, client_type)
     VALUES ($1,$2,$3,$4, now() + interval '30 days', $5,$6,$7)`,
    [familyId, subjectId, subjectType, sha256(token), meta.platform ?? null, meta.deviceName ?? null, meta.clientType ?? null]);
  return token;
}

// Rotating refresh; reuse of a used token revokes the whole family.
export async function rotateRefresh(token) {
  if (typeof token !== 'string' || token.length > 200) throw new ApiError(401, 'invalid_token', 'Invalid refresh token');
  return tx(async (c) => {
    const { rows } = await c.query('SELECT * FROM refresh_tokens WHERE token_hash=$1 FOR UPDATE', [sha256(token || '')]);
    const t = rows[0];
    if (!t || t.revoked_at || t.expires_at < new Date()) throw new ApiError(401, 'invalid_token', 'Invalid refresh token');
    if (t.used_at) {
      await c.query('UPDATE refresh_tokens SET revoked_at=now() WHERE family_id=$1', [t.family_id]);
      await c.query('COMMIT'); await c.query('BEGIN');
      throw new ApiError(401, 'invalid_token', 'Refresh token reuse detected; signed out everywhere');
    }
    await c.query('UPDATE refresh_tokens SET used_at=now() WHERE id=$1', [t.id]);
    return { t, next: await issueRefresh(c, t.subject_id, t.subject_type, t.family_id, { platform: t.platform, deviceName: t.device_name, clientType: t.client_type }) };
  });
}

export async function revokeRefresh(token) {
  if (typeof token !== 'string' || token.length > 200) return;
  await q(`UPDATE refresh_tokens SET revoked_at=now() WHERE family_id =
           (SELECT family_id FROM refresh_tokens WHERE token_hash=$1)`, [sha256(token || '')]);
}

// scrypt runs on the libuv thread pool (never block the event loop: one login must not freeze 5000 other users).
// At most 4 hashes run at once and 64 may wait; beyond that we shed load with 503 instead of queueing forever.
const scrypt = (pw, salt) => new Promise((res, rej) => crypto.scrypt(pw, salt, 64, { N: 16384, r: 8, p: 1, maxmem: 64 * 1024 * 1024 }, (e, k) => (e ? rej(e) : res(k))));
let running = 0; const waiting = [];
async function slot() {
  if (running >= 4) {
    if (waiting.length >= 64) throw new ApiError(503, 'conflict', 'Busy, please retry', { retryAfterSeconds: 2 });
    await new Promise((r) => waiting.push(r));
  } else running++;
}
const release = () => { const n = waiting.shift(); if (n) n(); else running--; };

export async function hashPassword(pw) {
  await slot();
  try { const salt = crypto.randomBytes(16); return `scrypt$${salt.toString('hex')}$${(await scrypt(pw, salt)).toString('hex')}`; } finally { release(); }
}
// A fixed hash to compare against when the account does not exist, so "no such email" costs the same time as "wrong password".
const DUMMY = `scrypt$${'00'.repeat(16)}$${'00'.repeat(64)}`;
export async function checkPassword(pw, stored) {
  if (typeof pw !== 'string' || pw.length > 200) return false;
  const [, salt, hash] = String(stored || DUMMY).split('$');
  await slot();
  try { return crypto.timingSafeEqual(await scrypt(pw, Buffer.from(salt, 'hex')), Buffer.from(hash, 'hex')); } finally { release(); }
}

// Terms/privacy versions: when Turbo publishes new ones, protected endpoints answer 403 terms_not_accepted until the user accepts.
// Looked up from the database at most once every 10 s per user (and refreshed at once on this process when they accept).
import { cached, bust } from './cache.js';
export const bustTerms = (uid) => bust(`terms:${uid}`);
export const termsStamp = () => `${config.termsVersion}|${config.privacyVersion}`;
export async function terms(req, _res, next) {
  // Fast path: the token was issued after the user accepted the CURRENT versions (claim `tv`), so no lookup is needed at all.
  // Only tokens issued before a version bump (or before the user accepted) fall through to the database check below.
  if (req.user.tv === termsStamp()) return next();
  try {
    const v = await cached(`terms:${req.user.id}`, 10_000, async () => (await q('SELECT terms_version, privacy_version FROM users WHERE id=$1', [req.user.id])).rows[0] || {});
    if (v.terms_version !== config.termsVersion || v.privacy_version !== config.privacyVersion)
      return next(new ApiError(403, 'terms_not_accepted', 'Please accept the latest terms and privacy policy'));
    next();
  } catch (e) { next(e); }
}
