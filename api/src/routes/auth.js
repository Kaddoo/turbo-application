import { Router } from 'express';
import crypto from 'node:crypto';
import { q, tx } from '../db.js';
import { config } from '../config.js';
import { ApiError } from '../lib/errors.js';
import { normalizePhone, sha256 } from '../lib/util.js';
import { idempotent } from '../lib/idempotency.js';
import { derive } from '../lib/secrets.js';
import { authenticate, rotateRefresh, revokeRefresh, signAccess, bustTerms } from '../lib/auth.js';
import { startSession, tokens, readCookie, fromBrowser, requireTrustedOrigin, clearRefreshCookie } from '../lib/session.js';
import { sendSms } from '../lib/notify.js';
import { limit, hit } from '../lib/ratelimit.js';
import { sessionUser } from '../lib/session.js';
import { firstNameOf, fullName } from '../views.js';

export const auth = Router();

const ip = (req) => req.ip;
// Codes are stored as a keyed hash: with only 1,000,000 possible codes, a plain SHA-256 would be reversed in milliseconds if the table ever leaked.
const codeHash = (code, phone) => crypto.createHmac('sha256', derive('otp')).update(`${phone}:${code}`).digest('hex');
const sameHash = (a, b) => a.length === b.length && crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b));
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });

auth.post('/auth/otp/request', limit('otp-ip', Number(process.env.OTP_PER_IP_HOUR || 3000), 3600_000, ip), async (req, res) => {
  const phone = normalizePhone(req.body.phone);       // the contract already pinned the pattern to +233XXXXXXXXX
  if (!phone) throw invalid('phone', 'Only +233 numbers are accepted');
  // A key makes a retry of the same tap safe: the first answer is replayed and no second SMS goes out. The key is scoped to the number (hashed) and
  // remembered for 10 minutes. A new tap sends a new key, so a deliberate resend still works; the cooldown and rate limits below still apply to it.
  // The header is optional: apps released before it existed do not send one.
  return idempotent(req, res, 'otp-request', async () => {
    const { deviceId, role } = req.body;
    if (deviceId && hit(`otp-device:${deviceId}`, 10, 3600_000)) throw new ApiError(429, 'otp_rate_limited', 'Too many codes requested from this device', { retryAfterSeconds: 600 });
    const [{ rows: [c] }, { rows: [g] }] = await Promise.all([
      q(`SELECT count(*)::int n, max(created_at) last FROM otp_challenges WHERE phone=$1 AND created_at > now() - interval '1 hour'`, [phone]),
      q(`SELECT count(*)::int n FROM otp_challenges WHERE created_at > now() - interval '1 hour'`),
    ]);
    if (c.n >= 5) throw new ApiError(429, 'otp_rate_limited', 'Too many codes requested for this number', { retryAfterSeconds: 600 });
    // One code per 30 seconds per number: stops someone flooding a victim's phone with five texts at once.
    if (c.last && Date.now() - new Date(c.last).getTime() < 30_000) throw new ApiError(429, 'otp_rate_limited', 'Wait a moment before asking for another code', { retryAfterSeconds: 30 });
    // Ceiling on total SMS per hour, so SMS-pumping fraud cannot run up the bill.
    if (g.n >= config.otpGlobalPerHour) { console.error('OTP global hourly budget reached'); throw new ApiError(503, 'sms_budget_exceeded', 'Sign-in is busy right now, try again shortly', { retryAfterSeconds: 300 }); }

    const code = config.otpMode === 'fixed' ? '123456' : String(crypto.randomInt(0, 1_000_000)).padStart(6, '0');
    await q(`INSERT INTO otp_challenges (phone, ip, code_hash, expires_at) VALUES ($1,$2,$3, now() + interval '5 minutes')`, [phone, ip(req), codeHash(code, phone)]);
    // Drivers are created by staff. For a number that is not a driver we answer exactly the same but send nothing (saves SMS cost and does not reveal who is a driver).
    const known = role === 'student' || (await q(`SELECT 1 FROM users WHERE phone=$1 AND role='driver' AND deleted_at IS NULL`, [phone])).rowCount;
    if (known) await sendSms(phone, `Your Turbo code is ${code}`);
    return { status: 202, body: { expiresInSeconds: 300, resendInSeconds: 30 } };
  }, { subject: sha256(phone), windowSeconds: 600, required: false });
});

auth.post('/auth/otp/verify', limit('otp-verify', Number(process.env.OTP_PER_IP_HOUR || 3000), 3600_000, ip), async (req, res) => {
  const phone = normalizePhone(req.body.phone);
  const { code, role, clientType, acceptedTermsVersion, acceptedPrivacyVersion } = req.body;
  const out = await tx(async (c) => {
    const { rows: [ch] } = await c.query(`SELECT * FROM otp_challenges WHERE phone=$1 AND consumed_at IS NULL ORDER BY created_at DESC LIMIT 1 FOR UPDATE`, [phone]);
    if (!ch) throw new ApiError(401, 'otp_invalid', 'Request a new code');
    if (ch.expires_at < new Date()) throw new ApiError(401, 'otp_expired', 'Code expired');
    if (ch.attempts >= 3) throw new ApiError(429, 'otp_rate_limited', 'Too many attempts; request a new code', { retryAfterSeconds: 300 });
    if (!sameHash(ch.code_hash, codeHash(code, phone))) {
      await c.query('UPDATE otp_challenges SET attempts=attempts+1 WHERE id=$1', [ch.id]);
      await c.query('COMMIT'); await c.query('BEGIN');
      throw new ApiError(401, 'otp_invalid', 'Wrong code');
    }
    await c.query('UPDATE otp_challenges SET consumed_at=now() WHERE id=$1', [ch.id]);
    let { rows: [u] } = await c.query('SELECT * FROM users WHERE phone=$1 AND deleted_at IS NULL', [phone]);
    if (!u) {
      if (role === 'driver') throw new ApiError(403, 'forbidden', 'Drivers are created by an admin');
      if (acceptedTermsVersion !== config.termsVersion || acceptedPrivacyVersion !== config.privacyVersion)
        throw new ApiError(403, 'terms_not_accepted', 'Accept the terms and privacy policy to create an account');
      ({ rows: [u] } = await c.query(`INSERT INTO users (role, phone, terms_version, terms_accepted_at, privacy_version) VALUES ('student',$1,$2, now(), $3) RETURNING *`,
        [phone, acceptedTermsVersion, acceptedPrivacyVersion]));
      await c.query('INSERT INTO students (user_id) VALUES ($1)', [u.id]);
      await c.query('INSERT INTO wallets (student_id) VALUES ($1)', [u.id]);
    } else if (u.role !== role) {
      throw new ApiError(403, 'forbidden', `This number is registered as a ${u.role}`);
    }
    if (u.status !== 'active') throw new ApiError(403, 'account_suspended', 'Account suspended');
    // Returning users may accept newer versions right at login.
    if (acceptedTermsVersion === config.termsVersion && acceptedPrivacyVersion === config.privacyVersion && (u.terms_version !== config.termsVersion || u.privacy_version !== config.privacyVersion)) {
      await c.query('UPDATE users SET terms_version=$2, privacy_version=$3, terms_accepted_at=now() WHERE id=$1', [u.id, acceptedTermsVersion, acceptedPrivacyVersion]);
      bustTerms(u.id);
    }
    return u;
  });
  const accepted = acceptedTermsVersion === config.termsVersion && acceptedPrivacyVersion === config.privacyVersion;
  const termsOk = accepted || (out.terms_version === config.termsVersion && out.privacy_version === config.privacyVersion);
  res.json(await startSession(req, res, { id: out.id, role: out.role, displayName: firstNameOf(out) ?? undefined, termsOk }, { web: clientType === 'web' }));
});

auth.post('/auth/refresh', limit('refresh', 600, 3600_000, ip), async (req, res) => {
  const cookie = readCookie(req);
  const fromCookie = !req.body?.refreshToken && !!cookie;
  if (fromCookie) requireTrustedOrigin(req);          // cookies ride along automatically, so only our own web origins may use them (CSRF)
  const token = req.body?.refreshToken ?? cookie;
  const { t, next } = await rotateRefresh(token);
  let user;
  if (t.subject_type === 'staff') {
    const { rows: [s] } = await q('SELECT id, role, is_active, name FROM staff_users WHERE id=$1', [t.subject_id]);
    if (!s?.is_active) throw new ApiError(401, 'invalid_token', 'Account deactivated');
    user = { id: s.id, role: 'admin', staffRole: s.role, displayName: s.name ?? undefined };
  } else {
    const { rows: [u] } = await q('SELECT id, role, status, first_name, full_name, terms_version, privacy_version FROM users WHERE id=$1 AND deleted_at IS NULL', [t.subject_id]);
    if (!u) throw new ApiError(401, 'invalid_token', 'Account not found');
    if (u.status !== 'active') throw new ApiError(403, 'account_suspended', 'Account suspended');
    user = { id: u.id, role: u.role, displayName: firstNameOf(u) ?? undefined, termsOk: u.terms_version === config.termsVersion && u.privacy_version === config.privacyVersion };
  }
  await q('UPDATE refresh_tokens SET last_used_at=now() WHERE family_id=$1', [t.family_id]);
  res.json(tokens(res, user, t.family_id, next, t.client_type === 'web'));
});

auth.post('/auth/logout', authenticate, async (req, res) => {
  if (req.user.sid) await q('UPDATE refresh_tokens SET revoked_at=now() WHERE family_id=$1 AND subject_id=$2 AND revoked_at IS NULL', [req.user.sid, req.user.id]);
  clearRefreshCookie(res);
  res.status(204).end();
});

// ---- push tokens
auth.post('/devices', authenticate, async (req, res) => {
  const { deviceId, fcmToken, platform, appVersion } = req.body;
  await q(`INSERT INTO devices (user_id,user_type,device_id,fcm_token,platform,app_version) VALUES ($1,$2,$3,$4,$5,$6)
           ON CONFLICT (user_id, device_id) DO UPDATE SET fcm_token=$4, platform=$5, app_version=$6, updated_at=now()`,
    [req.user.id, req.user.role === 'admin' ? 'staff' : 'user', deviceId, fcmToken, platform, appVersion ?? null]);
  // A phone that signs in as someone else must stop receiving the previous person's pushes.
  await q('DELETE FROM devices WHERE fcm_token=$1 AND NOT (user_id=$2 AND device_id=$3)', [fcmToken, req.user.id, deviceId]);
  res.status(204).end();
});
auth.delete('/devices/:deviceId', authenticate, async (req, res) => {
  const { rowCount } = await q('DELETE FROM devices WHERE user_id=$1 AND device_id=$2', [req.user.id, req.params.deviceId.slice(0, 128)]);
  if (!rowCount) throw new ApiError(404, 'not_found', 'Device not found');
  res.status(204).end();
});

// ---- public meta
import { createRequire } from 'node:module';
const version = createRequire(import.meta.url)('../../package.json').version;
auth.get('/health', async (_req, res) => {
  try { await q('SELECT 1'); res.json({ status: 'ok', version, time: new Date().toISOString() }); }
  catch { res.status(503).json({ status: 'degraded', version, time: new Date().toISOString() }); }
});
auth.get('/app-config', async (_req, res) => {
  const { getSettings } = await import('../lib/settings.js');
  const s = await getSettings();
  res.set('cache-control', 'public, max-age=60').json({
    minVersion: config.minVersion, maintenance: { active: config.maintenance, message: config.maintenance ? config.maintenanceMessage || null : null },
    bookingsPaused: !!s.bookingsPaused, pauseMessage: s.pauseMessage ?? null });
});
auth.get('/legal', (_req, res) => res.set('cache-control', 'public, max-age=300').json({
  termsVersion: config.termsVersion, privacyVersion: config.privacyVersion, termsUrl: config.termsUrl, privacyUrl: config.privacyUrl,
  ...(config.locationNoticeUrl && { locationNoticeUrl: config.locationNoticeUrl }) }));
