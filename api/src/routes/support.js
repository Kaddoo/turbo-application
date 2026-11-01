import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole, terms } from '../lib/auth.js';
import { ApiError, notFound } from '../lib/errors.js';
import { isUuid } from '../lib/util.js';
import { ensureBody } from '../lib/contract.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { qEnum } from '../lib/query.js';
import { notifyUser } from '../domain/notify.js';

export const support = Router();

const user = (req, _res, next) => { if (!['student', 'driver'].includes(req.user.role)) return next(new ApiError(403, 'forbidden', 'Not allowed for this account')); try { ensureBody(req); } catch (e) { return next(e); } next(); };
const UA = [authenticate, user, terms];
const A = [authenticate, requireRole('admin', ['support'])];

const CATEGORIES = ['safety', 'driver_conduct', 'vehicle', 'wrong_charge', 'payment_problem', 'lost_item', 'account', 'other', 'phone_change', 'data_request'];
const STATUSES = ['open', 'in_progress', 'waiting_on_user', 'resolved', 'closed'];
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });

const ticketView = (t, messages) => ({ id: t.id, category: t.category, status: t.status, subject: t.subject, rideId: t.ride_id ?? null,
  assignedToStaffId: t.assigned_to ?? null, createdAt: t.created_at, updatedAt: t.updated_at, ...(messages && { messages }) });
const msgView = (m) => ({ id: m.id, author: m.author, body: m.body, internal: m.internal, createdAt: m.created_at });

async function messagesOf(id, { internal }) {
  const { rows } = await q(`SELECT * FROM support_messages WHERE ticket_id=$1 AND ($2 OR NOT internal) ORDER BY created_at, id`, [id, internal]);
  return rows.map((m) => (internal ? msgView(m) : (({ internal: _i, ...rest }) => rest)(msgView(m))));
}

// Attachments must be the caller's own, already-stored support_attachment uploads, used once.
async function claimUploads(c, ids, ownerId) {
  if (!ids?.length) return [];
  if (!Array.isArray(ids) || ids.length > 5 || !ids.every(isUuid)) throw invalid('uploadIds', 'up to 5 upload ids');
  const { rows } = await c.query(`SELECT id FROM uploads WHERE id = ANY($1) AND owner_id=$2 AND purpose='support_attachment' AND status='stored' AND used_at IS NULL FOR UPDATE`, [ids, ownerId]);
  if (rows.length !== new Set(ids).size) throw invalid('uploadIds', 'each must be your own stored, unused support_attachment upload');
  await c.query('UPDATE uploads SET used_at=now() WHERE id = ANY($1)', [ids]);
  return ids;
}

// ---------- student / driver ----------
support.post('/support/tickets', ...UA, async (req, res) => {
  const { category, rideId, subject, message, uploadIds } = req.body || {};
  if (!CATEGORIES.includes(category)) throw invalid('category', 'unknown category');
  if (typeof subject !== 'string' || subject.trim().length < 3 || subject.length > 120) throw invalid('subject', '3 to 120 characters');
  if (typeof message !== 'string' || !message.trim() || message.length > 2000) throw invalid('message', '1 to 2000 characters');
  if (rideId != null && !isUuid(rideId)) throw invalid('rideId', 'must be an id');
  const t = await tx(async (c) => {
    if (rideId) {
      const col = req.user.role === 'student' ? 'student_id' : 'driver_id';
      if (!(await c.query(`SELECT 1 FROM rides WHERE id=$1 AND ${col}=$2`, [rideId, req.user.id])).rowCount) throw notFound('Ride');
    }
    const { rows: [n] } = await c.query(`SELECT count(*)::int n FROM support_tickets WHERE user_id=$1 AND created_at > now() - interval '1 hour'`, [req.user.id]);
    if (n.n >= 10) throw new ApiError(429, 'rate_limited', 'Too many tickets', { retryAfterSeconds: 600 });
    const { rows: [t] } = await c.query(`INSERT INTO support_tickets (user_id,user_role,category,subject,ride_id) VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [req.user.id, req.user.role, category, subject.trim(), rideId ?? null]);
    const ups = await claimUploads(c, uploadIds, req.user.id);
    await c.query(`INSERT INTO support_messages (ticket_id,author,author_id,body,upload_ids) VALUES ($1,'user',$2,$3,$4)`, [t.id, req.user.id, message.trim(), ups]);
    return t;
  });
  res.status(201).json(ticketView(t, await messagesOf(t.id, { internal: false })));
});

support.get('/support/tickets', ...UA, async (req, res) => {
  const a = pageArgs(req);
  const { rows } = await q(`SELECT * FROM support_tickets WHERE user_id=$1 AND ($2::timestamptz IS NULL OR (updated_at, id) < ($2::timestamptz, $3::uuid)) ORDER BY updated_at DESC, id DESC LIMIT $4`, [req.user.id, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (t) => [t.updated_at, t.id], (t) => ticketView(t)));
});

const mine = async (id, uid) => {
  if (!isUuid(id)) throw notFound('Ticket');
  const { rows: [t] } = await q('SELECT * FROM support_tickets WHERE id=$1 AND user_id=$2', [id, uid]);
  if (!t) throw notFound('Ticket');
  return t;
};

support.get('/support/tickets/:id', ...UA, async (req, res) => {
  const t = await mine(req.params.id, req.user.id);
  res.json(ticketView(t, await messagesOf(t.id, { internal: false })));
});

support.post('/support/tickets/:id/messages', ...UA, async (req, res) => {
  const { body, uploadIds } = req.body || {};
  if (typeof body !== 'string' || !body.trim() || body.length > 2000) throw invalid('body', '1 to 2000 characters');
  const t0 = await mine(req.params.id, req.user.id);
  const m = await tx(async (c) => {
    const { rows: [t] } = await c.query('SELECT status FROM support_tickets WHERE id=$1 FOR UPDATE', [t0.id]);
    if (t.status === 'closed') throw new ApiError(409, 'ticket_state_invalid', 'This ticket is closed; open a new one');
    const ups = await claimUploads(c, uploadIds, req.user.id);
    const { rows: [m] } = await c.query(`INSERT INTO support_messages (ticket_id,author,author_id,body,upload_ids) VALUES ($1,'user',$2,$3,$4) RETURNING *`, [t0.id, req.user.id, body.trim(), ups]);
    // A reply from the user puts the ball back in staff's court.
    await c.query(`UPDATE support_tickets SET updated_at=now(), status = CASE WHEN status IN ('waiting_on_user','resolved') THEN 'open' ELSE status END WHERE id=$1`, [t0.id]);
    return m;
  });
  const { internal: _i, ...out } = msgView(m);
  res.status(201).json(out);
});

// ---------- staff ----------
support.get('/admin/support/tickets', ...A, async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', STATUSES), category = qEnum(req, 'category', CATEGORIES);
  const { rows } = await q(`SELECT * FROM support_tickets WHERE ($1::text IS NULL OR status=$1) AND ($2::text IS NULL OR category=$2)
      AND ($3::timestamptz IS NULL OR (updated_at, id) < ($3::timestamptz, $4::uuid)) ORDER BY updated_at DESC, id DESC LIMIT $5`, [status, category, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (t) => [t.updated_at, t.id], (t) => ticketView(t)));
});

const anyTicket = async (id) => {
  if (!isUuid(id)) throw notFound('Ticket');
  const { rows: [t] } = await q('SELECT * FROM support_tickets WHERE id=$1', [id]);
  if (!t) throw notFound('Ticket');
  return t;
};

support.get('/admin/support/tickets/:id', ...A, async (req, res) => {
  const t = await anyTicket(req.params.id);
  res.json(ticketView(t, await messagesOf(t.id, { internal: true })));
});

support.patch('/admin/support/tickets/:id', ...A, async (req, res) => {
  const b = req.body || {};
  if (b.status === undefined && b.assignedToStaffId === undefined) throw invalid('status', 'status or assignedToStaffId required');
  if (b.status !== undefined && !STATUSES.includes(b.status)) throw invalid('status', 'unknown status');
  if (b.assignedToStaffId != null && !isUuid(b.assignedToStaffId)) throw invalid('assignedToStaffId', 'must be an id or null');
  const t0 = await anyTicket(req.params.id);
  if (b.assignedToStaffId && !(await q('SELECT 1 FROM staff_users WHERE id=$1', [b.assignedToStaffId])).rowCount) throw invalid('assignedToStaffId', 'no such staff member');
  const t = await tx(async (c) => {
    const { rows: [t] } = await c.query(`UPDATE support_tickets SET status=COALESCE($2,status),
        assigned_to = CASE WHEN $3::boolean THEN $4::uuid ELSE assigned_to END, updated_at=now() WHERE id=$1 RETURNING *`,
      [t0.id, b.status ?? null, b.assignedToStaffId !== undefined, b.assignedToStaffId ?? null]);
    await c.query('INSERT INTO audit_log (actor_type,actor_id,action,target,data) VALUES ($1,$2,$3,$4,$5)', ['staff', req.user.id, 'ticket.update', t.id, JSON.stringify({ status: b.status, assignedToStaffId: b.assignedToStaffId })]);
    return t;
  });
  res.json(ticketView(t, await messagesOf(t.id, { internal: true })));
});

support.post('/admin/support/tickets/:id/messages', ...A, async (req, res) => {
  const { body, internal = false } = req.body || {};
  if (typeof body !== 'string' || !body.trim() || body.length > 2000) throw invalid('body', '1 to 2000 characters');
  if (typeof internal !== 'boolean') throw invalid('internal', 'must be true or false');
  const t0 = await anyTicket(req.params.id);
  const m = await tx(async (c) => {
    const { rows: [m] } = await c.query(`INSERT INTO support_messages (ticket_id,author,author_id,body,internal) VALUES ($1,'staff',$2,$3,$4) RETURNING *`, [t0.id, req.user.id, body.trim(), internal]);
    // A reply the user can see waits on the user; an internal note changes nothing but the clock.
    await c.query(`UPDATE support_tickets SET updated_at=now(), status = CASE WHEN NOT $2 AND status IN ('open','in_progress') THEN 'waiting_on_user' ELSE status END WHERE id=$1`, [t0.id, internal]);
    if (!internal) await notifyUser(c, t0.user_id, 'support_reply', { data: { ticketId: t0.id } });      // internal notes are never announced
    return m;
  });
  res.status(201).json(msgView(m));
});
