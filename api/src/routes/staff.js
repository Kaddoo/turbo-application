import { Router } from 'express';
import crypto from 'node:crypto';
import { q, tx } from '../db.js';
import { config } from '../config.js';
import { ApiError, bad, notFound, conflict } from '../lib/errors.js';
import { isUuid, pageLimit, sha256, randomToken } from '../lib/util.js';
import { authenticate, requireRole, signAccess, issueRefresh, hashPassword, checkPassword } from '../lib/auth.js';
import { limit } from '../lib/ratelimit.js';
import { newSecret, verifyTotp, otpauthUri } from '../lib/totp.js';
import { seal, open } from '../lib/secrets.js';
import { sendEmail } from '../lib/notify.js';
import { auditStaff } from '../lib/audit.js';
import { startSession, fromBrowser } from '../lib/session.js';

export const staff = Router();
const ip = (req) => req.ip;
const ROLES = ['super_admin', 'finance', 'verifier', 'dispatcher', 'support', 'hr'];
const SA = [authenticate, requireRole('admin', ['super_admin'])];
const MIN_PW = 10;
const EMAIL = /^[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$/;      // no spaces, quotes, commas or angle brackets: nothing that can smuggle a second recipient
const emailOk = (e) => typeof e === 'string' && e.length <= 254 && EMAIL.test(e);

const view = (s) => ({
  id: s.id, email: s.email, fullName: s.name, staffRole: s.role, isActive: s.is_active,
  mfaEnrolled: !!s.mfa_secret_enc, lastLoginAt: s.last_login_at, lockedUntil: s.locked_until, invitePending: s.invite_pending,
});

// One live token per (staff, purpose): issuing a new one voids the old.
async function issueToken(c, staffId, purpose, ttlMinutes) {
  await c.query(`UPDATE staff_tokens SET used_at=now() WHERE staff_id=$1 AND purpose=$2 AND used_at IS NULL`, [staffId, purpose]);
  const token = randomToken(32);
  await c.query(`INSERT INTO staff_tokens (staff_id,purpose,token_hash,expires_at) VALUES ($1,$2,$3, now() + make_interval(mins => $4))`,
    [staffId, purpose, sha256(token), ttlMinutes]);
  return token;
}
// Locks the token row so it can be used once even under concurrent requests.
async function takeToken(c, token, purpose) {
  const { rows: [t] } = await c.query(
    `SELECT * FROM staff_tokens WHERE token_hash=$1 AND purpose=$2 FOR UPDATE`, [sha256(String(token || '')), purpose]);
  if (!t || t.used_at || t.expires_at < new Date()) throw new ApiError(401, 'invalid_token', 'This link is invalid or has expired');
  return t;
}
export const revokeStaffSessions = (c, staffId, exceptFamily = null) =>
  c.query(`UPDATE refresh_tokens SET revoked_at=now() WHERE subject_id=$1 AND subject_type='staff' AND revoked_at IS NULL
           AND ($2::uuid IS NULL OR family_id <> $2)`, [staffId, exceptFamily]);

const checkPw = (pw, field = 'password') => {
  if (typeof pw !== 'string' || pw.length < MIN_PW) throw bad(`Password must be at least ${MIN_PW} characters`, [{ field, message: `min ${MIN_PW}` }]);
  if (pw.length > 200) throw bad('Password too long');
};

async function sendInvite(s, token) {
  const link = `${config.adminUrl}/accept-invite?token=${token}`;
  await sendEmail(s.email, 'Your Turbo staff invitation',
    `Hello ${s.name || ''},\n\nYou have been invited to the Turbo admin dashboard as ${s.role}.\nSet your password and your authenticator app here (valid 72 hours):\n${link}\n`);
}

// Starts enrolment: stores a pending secret, returns what the authenticator app needs.
async function startEnrolment(c, s) {
  const secret = newSecret();
  await c.query('UPDATE staff_users SET mfa_pending_enc=$2 WHERE id=$1', [s.id, seal(secret)]);
  return { enrollmentToken: await issueToken(c, s.id, 'enroll', 30), secret, otpauthUri: otpauthUri(secret, s.email) };
}

// Shared by login and MFA-confirm. The dashboard is a browser app, so its refresh token goes in an httpOnly cookie; other callers get it in the body.
export async function openSession(req, res, s) {
  await q('UPDATE staff_users SET failed_logins=0, locked_until=NULL, last_login_at=now() WHERE id=$1', [s.id]);
  return startSession(req, res, { id: s.id, role: 'admin', staffRole: s.role, displayName: s.name ?? undefined }, { subjectType: 'staff', web: fromBrowser(req) });
}

export async function failStaffLogin(id) {
  await q(`UPDATE staff_users SET
      locked_until = CASE WHEN failed_logins+1 >= 5 THEN now() + interval '15 minutes' ELSE locked_until END,
      failed_logins = CASE WHEN failed_logins+1 >= 5 THEN 0 ELSE failed_logins+1 END WHERE id=$1`, [id]);
}

// ---- public: login
staff.post('/auth/admin/login', limit('admin-login', Number(process.env.ADMIN_LOGIN_PER_10MIN || 20), 600_000, ip), async (req, res) => {
  const { email, password, totpCode } = req.body || {};
  if (typeof email !== 'string' || typeof password !== 'string') throw bad('email and password required');
  const { rows: [s] } = await q('SELECT * FROM staff_users WHERE email=$1', [email.toLowerCase()]);
  if (s?.locked_until && s.locked_until > new Date()) throw new ApiError(429, 'account_locked', 'Account locked; try again later', { retryAfterSeconds: Math.ceil((s.locked_until - Date.now()) / 1000) });
  const pwOk = await checkPassword(password, s?.password_hash);        // runs even when the email is unknown (constant cost)
  if (!s || s.invite_pending || !pwOk) {
    if (s && !s.invite_pending) await failStaffLogin(s.id);
    throw new ApiError(401, 'invalid_credentials', 'Wrong email or password');
  }
  if (!s.is_active) throw new ApiError(403, 'forbidden', 'This account is deactivated');
  if (s.mfa_secret_enc) {
    const step = verifyTotp(open(s.mfa_secret_enc), totpCode, { lastStep: s.mfa_last_step });
    // The step is claimed atomically: two requests with the same code cannot both pass.
    const claimed = step != null && (await q('UPDATE staff_users SET mfa_last_step=$2 WHERE id=$1 AND (mfa_last_step IS NULL OR mfa_last_step < $2)', [s.id, step])).rowCount === 1;
    if (!claimed) { await failStaffLogin(s.id); throw new ApiError(401, 'mfa_required', 'Authenticator code required or wrong'); }
  } else if (config.staffMfa === 'required') {
    throw new ApiError(403, 'mfa_enrollment_required', 'Ask a super admin to send you a new invite to set up MFA');
  }
  res.json(await openSession(req, res, s));
});

// ---- public: invite -> password -> MFA
staff.post('/auth/admin/invite/accept', limit('invite', 20, 600_000, ip), async (req, res) => {
  const { token, password } = req.body || {};
  checkPw(password);
  const pwHash = await hashPassword(password);          // hashed before the transaction: never hold a DB lock while waiting on CPU
  const out = await tx(async (c) => {
    const t = await takeToken(c, token, 'invite');
    const { rows: [s] } = await c.query('SELECT * FROM staff_users WHERE id=$1 FOR UPDATE', [t.staff_id]);
    if (!s.is_active) throw new ApiError(401, 'invalid_token', 'This link is invalid or has expired');
    await c.query('UPDATE staff_tokens SET used_at=now() WHERE id=$1', [t.id]);
    await c.query('UPDATE staff_users SET password_hash=$2, failed_logins=0, locked_until=NULL WHERE id=$1', [s.id, pwHash]);
    await revokeStaffSessions(c, s.id);
    return startEnrolment(c, s);
  });
  res.json(out);
});

staff.post('/auth/admin/mfa/confirm', limit('mfa-confirm', 20, 600_000, ip), async (req, res) => {
  const { enrollmentToken, totpCode } = req.body || {};
  if (!/^\d{6}$/.test(totpCode || '')) throw bad('totpCode must be 6 digits');
  const s = await tx(async (c) => {
    const t = await takeToken(c, enrollmentToken, 'enroll');
    const { rows: [s] } = await c.query('SELECT * FROM staff_users WHERE id=$1 FOR UPDATE', [t.staff_id]);
    if (!s.is_active || !s.mfa_pending_enc) throw new ApiError(401, 'invalid_token', 'Enrolment expired; ask for a new invite');
    const step = verifyTotp(open(s.mfa_pending_enc), totpCode);
    if (step == null) throw new ApiError(401, 'mfa_required', 'That code is wrong. Check your phone clock and try the next code');
    await c.query('UPDATE staff_tokens SET used_at=now() WHERE id=$1', [t.id]);
    await c.query(`UPDATE staff_users SET mfa_secret_enc=mfa_pending_enc, mfa_pending_enc=NULL, mfa_confirmed_at=now(),
                   mfa_last_step=$2, invite_pending=false WHERE id=$1`, [s.id, step]);
    await auditStaff(c, s.id, 'staff.mfa_enrolled', s.id);
    return s;
  });
  res.json(await openSession(req, res, s));
});

// ---- public: password reset (no enumeration: always 202)
staff.post('/auth/admin/password/forgot', limit('pw-forgot', 10, 3600_000, ip), async (req, res) => {
  const email = typeof req.body?.email === 'string' ? req.body.email.toLowerCase() : '';
  if (!emailOk(email)) throw bad('A valid email is required');
  const { rows: [s] } = await q('SELECT * FROM staff_users WHERE email=$1 AND is_active AND NOT invite_pending', [email]);
  if (s) {
    const token = await tx((c) => issueToken(c, s.id, 'reset', 60));
    sendEmail(s.email, 'Reset your Turbo password', `Reset link (valid 1 hour):\n${config.adminUrl}/reset-password?token=${token}\n\nIf you did not ask for this, ignore this email.`)
      .catch((e) => console.error('reset email failed', e.message));
  }
  res.status(202).end();
});

staff.post('/auth/admin/password/reset', limit('pw-reset', 20, 600_000, ip), async (req, res) => {
  const { token, password } = req.body || {};
  checkPw(password);
  const pwHash = await hashPassword(password);
  await tx(async (c) => {
    const t = await takeToken(c, token, 'reset');
    await c.query('UPDATE staff_tokens SET used_at=now() WHERE id=$1', [t.id]);
    await c.query('UPDATE staff_users SET password_hash=$2, failed_logins=0, locked_until=NULL WHERE id=$1', [t.staff_id, pwHash]);
    await revokeStaffSessions(c, t.staff_id);
    await auditStaff(c, t.staff_id, 'staff.password_reset', t.staff_id);
  });
  res.status(204).end();
});

// ---- signed in: change own password
staff.post('/admin/me/password', authenticate, requireRole('admin'), limit('pw-change', 10, 600_000, ip), async (req, res) => {
  const { currentPassword, newPassword, totpCode } = req.body || {};
  checkPw(newPassword, 'newPassword');
  if (typeof currentPassword !== 'string') throw bad('currentPassword required');
  const { rows: [s] } = await q('SELECT * FROM staff_users WHERE id=$1', [req.user.id]);
  if (!s || !s.is_active) throw new ApiError(401, 'invalid_token', 'Sign in again');
  if (!(await checkPassword(currentPassword, s.password_hash))) { await failStaffLogin(s.id); throw new ApiError(401, 'invalid_credentials', 'Current password is wrong'); }
  if (s.mfa_secret_enc) {
    const step = verifyTotp(open(s.mfa_secret_enc), totpCode, { lastStep: s.mfa_last_step });
    if (step == null) { await failStaffLogin(s.id); throw new ApiError(401, 'mfa_required', 'Authenticator code required or wrong'); }
    await q('UPDATE staff_users SET mfa_last_step=$2 WHERE id=$1', [s.id, step]);
  }
  const newHash = await hashPassword(newPassword);
  await tx(async (c) => {
    await c.query('UPDATE staff_users SET password_hash=$2 WHERE id=$1', [s.id, newHash]);
    await revokeStaffSessions(c, s.id, isUuid(req.user.sid) ? req.user.sid : null);
    await auditStaff(c, s.id, 'staff.password_changed', s.id);
  });
  res.status(204).end();
});

// ---- super admin: manage staff
staff.get('/admin/staff', ...SA, async (req, res) => {
  const { rows } = await q('SELECT * FROM staff_users ORDER BY created_at LIMIT 500');
  res.json({ data: rows.map(view), page: { nextCursor: null, hasMore: false } });
});

staff.post('/admin/staff', ...SA, async (req, res) => {
  const { email, fullName, staffRole } = req.body || {};
  if (!emailOk(email)) throw bad('A valid email is required', [{ field: 'email', message: 'invalid' }]);
  if (typeof fullName !== 'string' || fullName.trim().length < 2 || fullName.length > 120) throw bad('fullName required', [{ field: 'fullName', message: 'min 2' }]);
  if (!ROLES.includes(staffRole)) throw bad(`staffRole must be one of ${ROLES.join(', ')}`);
  const unusable = await hashPassword(randomToken(32));
  const { s, token } = await tx(async (c) => {
    let s;
    try {
      // Unusable random password until the invite is accepted.
      ({ rows: [s] } = await c.query(`INSERT INTO staff_users (email,password_hash,name,role,invite_pending) VALUES ($1,$2,$3,$4,true) RETURNING *`,
        [email.toLowerCase(), unusable, fullName.trim(), staffRole]));
    } catch (e) { if (e.code === '23505') throw conflict('conflict', 'That email already has an account'); throw e; }
    const token = await issueToken(c, s.id, 'invite', 72 * 60);
    await auditStaff(c, req.user.id, 'staff.invite', s.id, { role: staffRole });
    return { s, token };
  });
  sendInvite(s, token).catch((e) => console.error('invite email failed (resend from the dashboard)', e.message));
  res.status(201).json(view(s));
});

staff.patch('/admin/staff/:id', ...SA, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Staff user');
  const { staffRole, isActive } = req.body || {};
  if (staffRole !== undefined && !ROLES.includes(staffRole)) throw bad(`staffRole must be one of ${ROLES.join(', ')}`);
  if (isActive !== undefined && typeof isActive !== 'boolean') throw bad('isActive must be boolean');
  if (req.params.id === req.user.id && (isActive === false || (staffRole && staffRole !== 'super_admin')))
    throw conflict('conflict', 'You cannot deactivate or demote yourself');
  const s = await tx(async (c) => {
    const { rows: [s] } = await c.query(
      `UPDATE staff_users SET role=COALESCE($2,role), is_active=COALESCE($3,is_active) WHERE id=$1 RETURNING *`,
      [req.params.id, staffRole ?? null, isActive ?? null]);
    if (!s) throw notFound('Staff user');
    if (isActive === false || staffRole) await revokeStaffSessions(c, s.id);   // a role change or deactivation takes effect now
    await auditStaff(c, req.user.id, 'staff.update', s.id, { staffRole, isActive });
    return s;
  });
  res.json(view(s));
});

staff.post('/admin/staff/:id/invite', ...SA, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Staff user');
  const { s, token } = await tx(async (c) => {
    const { rows: [s] } = await c.query(
      `UPDATE staff_users SET invite_pending=true, mfa_secret_enc=NULL, mfa_pending_enc=NULL, mfa_confirmed_at=NULL, mfa_last_step=NULL
       WHERE id=$1 AND is_active RETURNING *`, [req.params.id]);
    if (!s) throw notFound('Staff user');
    await revokeStaffSessions(c, s.id);
    await auditStaff(c, req.user.id, 'staff.reinvite', s.id);   // re-inviting also resets MFA (lost phone)
    return { s, token: await issueToken(c, s.id, 'invite', 72 * 60) };
  });
  await sendInvite(s, token);
  res.status(202).end();
});

staff.delete('/admin/staff/:id/sessions', ...SA, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Staff user');
  await tx(async (c) => {
    const { rowCount } = await c.query('SELECT 1 FROM staff_users WHERE id=$1', [req.params.id]);
    if (!rowCount) throw notFound('Staff user');
    await revokeStaffSessions(c, req.params.id);
    await auditStaff(c, req.user.id, 'staff.sessions_revoked', req.params.id);
  });
  res.status(204).end();
});
