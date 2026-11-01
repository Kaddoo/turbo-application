import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole } from '../lib/auth.js';
import { ApiError, notFound, conflict } from '../lib/errors.js';
import { isUuid, cedisToPesewas } from '../lib/util.js';
import { getSettings } from '../lib/settings.js';
import { idempotent } from '../lib/idempotency.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { qEnum, qUuid, qDate, qBool } from '../lib/query.js';
import * as storage from '../lib/storage.js';
import * as wallet from '../domain/wallet.js';
import { walletView, txView, topupView, iso } from '../views.js';
import { audit } from './admin.js';
import { notifyUser } from '../domain/notify.js';

export const finance = Router();
const F = [authenticate, requireRole('admin', ['finance'])];
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });
const need = (id, what) => { if (!isUuid(id)) throw notFound(what); };
const TX_TYPES = ['topup', 'ride_hold', 'ride_release', 'ride_charge', 'refund', 'adjustment', 'provider_reversal'];

// ---- a student's wallet, as seen by finance
async function ensureStudent(id) {
  need(id, 'Student');
  const { rows: [s] } = await q('SELECT 1 FROM students WHERE user_id=$1', [id]);
  if (!s) throw notFound('Student');
}
finance.get('/admin/students/:id/wallet', ...F, async (req, res) => {
  await ensureStudent(req.params.id);
  const { rows: [w] } = await q('SELECT * FROM wallets WHERE student_id=$1', [req.params.id]);
  res.json(walletView(w));
});
finance.get('/admin/students/:id/wallet/transactions', ...F, async (req, res) => {
  await ensureStudent(req.params.id);
  const a = pageArgs(req), type = qEnum(req, 'type', TX_TYPES), cur = a.ts == null ? null : Number(a.ts);
  const { rows } = await q(`SELECT * FROM (SELECT l.*, (SELECT balance_pesewas FROM wallets w WHERE w.student_id=l.student_id) - COALESCE(sum(amount_pesewas) OVER (ORDER BY id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0)::bigint AS balance_after FROM ledger_entries l WHERE student_id=$1) x
      WHERE ($2::text IS NULL OR type=$2) AND ($3::bigint IS NULL OR id < $3) ORDER BY id DESC LIMIT $4`, [req.params.id, type, cur, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.id], txView));
});

// ---- adjustments: up to the threshold they apply at once; above it a DIFFERENT finance person must approve (D25)
const REASON_TEXT = { goodwill: 'Goodwill credit', duplicate_charge: 'Duplicate charge corrected', provider_reconciliation: 'Provider reconciliation', correction: 'Correction', other: 'Adjustment' };
const adjView = (a) => ({ id: a.id, studentId: a.student_id, amountPesewas: a.amount_pesewas, reasonCode: a.reason_code, ...(a.note && { note: a.note }), status: a.status,
  requestedBy: a.requested_by, decidedBy: a.decided_by ?? null, createdAt: iso(a.created_at), decidedAt: iso(a.decided_at) });

async function lastTx(c, studentId) {
  const { rows: [e] } = await c.query(`SELECT l.*, (SELECT balance_pesewas FROM wallets WHERE student_id=$1)::bigint AS balance_after FROM ledger_entries l WHERE student_id=$1 ORDER BY id DESC LIMIT 1`, [studentId]);
  return txView(e);
}
async function applyAdjustment(c, a, by) {
  const note = `${REASON_TEXT[a.reason_code]}${a.note ? `: ${a.note}` : ''}`;
  if (a.amount_pesewas > 0) await wallet.credit(c, a.student_id, a.amount_pesewas, 'adjustment', { note, by });
  else await wallet.debitAdjustment(c, a.student_id, -a.amount_pesewas, { note, by });
}

finance.post('/admin/students/:id/wallet/adjustments', ...F, async (req, res) => idempotent(req, res, 'adjust', async () => {
  const { amountPesewas, reasonCode, note } = req.body;
  await ensureStudent(req.params.id);
  if (amountPesewas === 0 || Math.abs(amountPesewas) > 1_000_000) throw invalid('amountPesewas', 'must be a non-zero amount up to GHS 10,000');
  const cfg = await getSettings();
  return tx(async (c) => {
    const needs = Math.abs(amountPesewas) > cfg.adjustmentApprovalThresholdPesewas;
    const { rows: [a] } = await c.query(`INSERT INTO wallet_adjustments (student_id,amount_pesewas,reason_code,note,status,requested_by,decided_by,decided_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`, [req.params.id, amountPesewas, reasonCode, note, needs ? 'pending' : 'approved', req.user.id, needs ? null : req.user.id, needs ? null : new Date()]);
    await audit(c, req, 'wallet.adjustment', a.id, { studentId: req.params.id, amountPesewas, reasonCode, pending: needs });
    if (needs) return { status: 202, body: adjView(a) };
    await applyAdjustment(c, a, req.user.id);
    return { status: 201, body: await lastTx(c, req.params.id) };
  });
}));

finance.get('/admin/wallet-adjustments', ...F, async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', ['pending', 'approved', 'rejected']);
  const { rows } = await q(`SELECT * FROM wallet_adjustments WHERE ($1::text IS NULL OR status=$1) AND ($2::timestamptz IS NULL OR (created_at, id) < ($2::timestamptz, $3::uuid))
      ORDER BY created_at DESC, id DESC LIMIT $4`, [status, a.ts, a.id, a.fetch]);
  const p = pageOf(rows, a, (r) => [r.created_at, r.id], adjView);
  res.json({ items: p.data, page: p.page });
});

async function decide(req, res, outcome) {
  const { note } = req.body ?? {};
  need(req.params.id, 'Adjustment');
  return idempotent(req, res, `adjdecide:${outcome}`, async () => tx(async (c) => {
    const { rows: [a] } = await c.query('SELECT * FROM wallet_adjustments WHERE id=$1 FOR UPDATE', [req.params.id]);
    if (!a) throw notFound('Adjustment');
    if (a.status !== 'pending') throw conflict('conflict', `Adjustment is already ${a.status}`);
    if (a.requested_by === req.user.id) throw new ApiError(403, 'approval_by_requester_forbidden', 'A second person must decide on this');
    if (outcome === 'approved') await applyAdjustment(c, a, req.user.id);
    const { rows: [u] } = await c.query(`UPDATE wallet_adjustments SET status=$2, decided_by=$3, decided_at=now(), decision_note=$4 WHERE id=$1 RETURNING *`, [a.id, outcome, req.user.id, note ?? null]);
    await audit(c, req, `wallet.adjustment.${outcome}`, a.id, { note: note ?? null });
    return { status: 200, body: adjView(u) };
  }));
}
finance.post('/admin/wallet-adjustments/:id/approve', ...F, (req, res) => decide(req, res, 'approved'));
finance.post('/admin/wallet-adjustments/:id/reject', ...F, (req, res) => decide(req, res, 'rejected'));

// ---- refunds
const REFUND_TEXT = { driver_cancelled: 'Driver cancelled', service_issue: 'Service issue', breakdown: 'Vehicle breakdown', partial_trip: 'Partial trip', wrong_charge: 'Wrong charge', other: 'Refund' };
finance.post('/admin/rides/:id/refund', ...F, async (req, res) => idempotent(req, res, 'refund', async () => {
  const { amountPesewas, reasonCode, note } = req.body;
  need(req.params.id, 'Ride');
  return tx(async (c) => {
    const { rows: [r] } = await c.query(`SELECT student_id, fare_pesewas,
        (SELECT COALESCE(SUM(-amount_pesewas) FILTER (WHERE type='ride_charge'),0) - COALESCE(SUM(amount_pesewas) FILTER (WHERE type='refund'),0) FROM ledger_entries WHERE ride_id=rides.id) AS refundable
        FROM rides WHERE id=$1`, [req.params.id]);
    if (!r) throw notFound('Ride');
    const amount = amountPesewas ?? Number(r.refundable);            // omitted = refund whatever is left to refund
    if (!Number.isInteger(amount) || amount <= 0 || amount > 1_000_000) throw invalid('amountPesewas', 'must be a positive whole number (and not more than was charged)');
    await wallet.refund(c, r.student_id, req.params.id, amount, { note: `${REFUND_TEXT[reasonCode]}: ${note}`, by: req.user.id });
    await audit(c, req, 'ride.refund', req.params.id, { amountPesewas: amount, reasonCode, note });
    await notifyUser(c, r.student_id, 'refund', { vars: { amount }, data: { rideId: req.params.id } });
    return { status: 201, body: await lastTx(c, r.student_id) };
  });
}));

// ---- top-ups
finance.get('/admin/topups', ...F, async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', ['pending', 'succeeded', 'failed', 'abandoned']), sid = qUuid(req, 'studentId'), flagged = qBool(req, 'flagged');
  const from = qDate(req, 'from'), to = qDate(req, 'to');
  const { rows } = await q(`SELECT * FROM topups WHERE ($1::text IS NULL OR status=$1) AND ($2::uuid IS NULL OR student_id=$2)
      AND ($3::boolean IS NULL OR (CASE WHEN $3 THEN flagged AND resolved_at IS NULL ELSE NOT flagged OR resolved_at IS NOT NULL END))
      AND ($4::date IS NULL OR created_at >= $4) AND ($5::date IS NULL OR created_at < $5::date + 1)
      AND ($6::timestamptz IS NULL OR (created_at, id) < ($6::timestamptz, $7::uuid)) ORDER BY created_at DESC, id DESC LIMIT $8`, [status, sid, flagged, from, to, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.created_at, r.id], (t) => topupView(t, { staff: true })));
});

finance.post('/admin/topups/:id/resolve', ...F, async (req, res) => idempotent(req, res, `topupresolve:${req.params.id}`, async () => {
  const { resolution, note } = req.body;
  need(req.params.id, 'Top-up');
  const t = await tx(async (c) => {
    const { rows: [t] } = await c.query('SELECT * FROM topups WHERE id=$1 FOR UPDATE', [req.params.id]);
    if (!t) throw notFound('Top-up');
    if (!t.flagged) throw conflict('conflict', 'This top-up is not flagged');
    if (t.resolved_at) throw conflict('conflict', 'This top-up was already resolved');
    await c.query(`UPDATE topups SET resolution=$2, resolution_note=$3, resolved_by=$4, resolved_at=now() WHERE id=$1`, [t.id, resolution, note.trim(), req.user.id]);
    await audit(c, req, 'topup.resolve', t.id, { resolution, note: note.trim(), validation: t.validation, amountPesewas: t.amount_pesewas, receivedPesewas: t.amount_received_pesewas });
    return (await c.query('SELECT * FROM topups WHERE id=$1', [t.id])).rows[0];
  });
  return { body: topupView(t, { staff: true }) };
}));

// ---- reconciliation against the provider's own statement (CSV)
const reportView = (r) => ({ id: r.id, periodFrom: new Date(r.period_from).toISOString().slice(0, 10), periodTo: new Date(r.period_to).toISOString().slice(0, 10), matchedCount: r.matched_count,
  providerTotalPesewas: Number(r.provider_total_pesewas), ourTotalPesewas: Number(r.our_total_pesewas), exceptions: r.exceptions, createdAt: iso(r.created_at) });

// Minimal CSV reader (quoted fields, commas, CRLF). Finds the reference/amount/status columns by header name so a column reorder at the provider does not break us.
function parseCsv(text) {
  const rows = []; let row = [], cur = '', quoted = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (quoted) { if (ch === '"' && text[i + 1] === '"') { cur += '"'; i++; } else if (ch === '"') quoted = false; else cur += ch; }
    else if (ch === '"') quoted = true;
    else if (ch === ',') { row.push(cur); cur = ''; }
    else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(cur); cur = ''; if (row.some((x) => x.trim())) rows.push(row); row = []; }
    else cur += ch;
  }
  row.push(cur); if (row.some((x) => x.trim())) rows.push(row);
  return rows;
}

finance.post('/admin/reconciliation/reports', ...F, async (req, res) => idempotent(req, res, 'reconrun', async () => {
  const { statementUploadId, periodFrom, periodTo } = req.body;
  if (periodTo < periodFrom) throw invalid('periodTo', 'must not be before periodFrom');
  if (Date.parse(periodTo) - Date.parse(periodFrom) > 93 * 86400_000) throw invalid('periodTo', 'at most 93 days per report');
  const { rows: [u] } = await q(`SELECT * FROM uploads WHERE id=$1 AND purpose='provider_statement' AND status='stored'`, [statementUploadId]);
  if (!u) throw notFound('Statement upload');
  if (u.content_type !== 'text/csv') throw invalid('statementUploadId', 'the statement must be a CSV file');
  const rows = parseCsv((await storage.get(u.storage_key)).toString('utf8'));
  const head = (rows.shift() || []).map((h) => h.trim().toLowerCase());
  const col = (re) => head.findIndex((h) => re.test(h));
  const iRef = col(/reference/), iAmt = col(/amount/), iStatus = col(/status/);
  if (iRef < 0 || iAmt < 0) throw invalid('statementUploadId', 'CSV needs a reference column and an amount column');
  const provider = new Map();
  for (const r of rows.slice(0, 50_000)) {
    const ref = (r[iRef] || '').trim(); if (!ref) continue;
    let amt; try { amt = cedisToPesewas((r[iAmt] || '0').replace(/[^\d.]/g, '')); } catch { continue; }
    provider.set(ref, { amount: amt, status: (r[iStatus] || '').trim().toLowerCase() });
  }
  const { rows: ours } = await q(`SELECT * FROM topups WHERE created_at >= $1 AND created_at < $2::date + 1 AND status IN ('succeeded','pending','failed')`, [periodFrom, periodTo]);
  const byRef = new Map(ours.map((t) => [t.reference, t]));
  const exceptions = []; let matched = 0, providerTotal = 0, ourTotal = 0;
  const flag = [];
  for (const [ref, p] of provider) {
    const t = byRef.get(ref), paid = !p.status || /success|received|complete|paid/.test(p.status);
    if (paid) providerTotal += p.amount;
    if (!t) { exceptions.push({ providerReference: ref, topupId: null, providerAmountPesewas: p.amount, ourAmountPesewas: null, issue: 'missing_here' }); continue; }
    const mine = t.status === 'succeeded' ? t.amount_received_pesewas ?? t.amount_pesewas : 0;
    if (t.status === 'succeeded') ourTotal += mine;
    if (paid && t.status !== 'succeeded') { exceptions.push({ providerReference: ref, topupId: t.id, providerAmountPesewas: p.amount, ourAmountPesewas: mine, issue: 'status_mismatch' }); flag.push(t.id); }
    else if (paid && p.amount !== mine) { exceptions.push({ providerReference: ref, topupId: t.id, providerAmountPesewas: p.amount, ourAmountPesewas: mine, issue: 'amount_mismatch' }); flag.push(t.id); }
    else matched++;
  }
  for (const t of ours) if (t.status === 'succeeded' && !provider.has(t.reference)) {
    ourTotal += t.amount_received_pesewas ?? t.amount_pesewas;
    exceptions.push({ providerReference: t.reference, topupId: t.id, providerAmountPesewas: null, ourAmountPesewas: t.amount_received_pesewas ?? t.amount_pesewas, issue: 'missing_at_provider' }); flag.push(t.id);
  }
  const out = await tx(async (c) => {
    if (flag.length) await c.query(`UPDATE topups SET flagged=true, flag_reason=COALESCE(flag_reason,'reconciliation_mismatch') WHERE id = ANY($1) AND resolved_at IS NULL`, [flag]);
    const { rows: [r] } = await c.query(`INSERT INTO reconciliation_reports (period_from,period_to,matched_count,provider_total_pesewas,our_total_pesewas,exceptions,statement_upload_id,created_by)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`, [periodFrom, periodTo, matched, providerTotal, ourTotal, JSON.stringify(exceptions.slice(0, 1000)), statementUploadId, req.user.id]);
    await c.query('UPDATE uploads SET used_at=now() WHERE id=$1', [statementUploadId]);
    await audit(c, req, 'reconciliation.run', r.id, { periodFrom, periodTo, exceptions: exceptions.length });
    return r;
  });
  return { status: 201, body: reportView(out) };
}));

finance.get('/admin/reconciliation/reports', ...F, async (req, res) => {
  const a = pageArgs(req);
  const { rows } = await q(`SELECT * FROM reconciliation_reports WHERE ($1::timestamptz IS NULL OR (created_at, id) < ($1::timestamptz, $2::uuid)) ORDER BY created_at DESC, id DESC LIMIT $3`, [a.ts, a.id, a.fetch]);
  const p = pageOf(rows, a, (r) => [r.created_at, r.id], reportView);
  res.json({ items: p.data, page: p.page });
});
