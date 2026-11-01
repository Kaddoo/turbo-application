import { Router, raw } from 'express';
import crypto from 'node:crypto';
import { q } from '../db.js';
import { authenticate, requireRole, terms } from '../lib/auth.js';
import { ApiError, notFound } from '../lib/errors.js';
import { isUuid } from '../lib/util.js';
import { getSettings } from '../lib/settings.js';
import { idempotent } from '../lib/idempotency.js';
import { provider, verifyWebhook } from '../lib/payments.js';
import { applyOutcome, receivedPesewas } from '../domain/topups.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { walletView, txView, topupView } from '../views.js';
import { tx } from '../db.js';
import { alert } from '../lib/alerts.js';

export const walletRoutes = Router();
const S = [authenticate, requireRole('student'), terms];

// The contract does not ask the app for a mobile money network, so we infer it from the number's prefix (Ghana's allocation).
// Number portability can make this wrong for a few people; Payaza's check-status will fail the prompt and the student can retry.
const NETWORK_PREFIX = { MTN: ['24', '25', '53', '54', '55', '59'], VODAFONE: ['20', '50'], AIRTELTIGO: ['26', '27', '56', '57'] };
const networkOf = (phone) => Object.entries(NETWORK_PREFIX).find(([, p]) => p.some((x) => phone.slice(4, 6) === x))?.[0] ?? 'MTN';

walletRoutes.get('/wallet', ...S, async (req, res) => {
  const { rows: [w] } = await q('SELECT * FROM wallets WHERE student_id=$1', [req.user.id]);
  res.json(walletView(w));
});

walletRoutes.get('/wallet/transactions', ...S, async (req, res) => {
  const a = pageArgs(req);
  const cur = a.ts == null ? null : Number(a.ts);
  // balanceAfter = the wallet's actual balance minus everything that happened after that row. Anchoring to the real balance keeps it correct
  // (and never negative) even if old rows are missing; the window runs in a subquery BEFORE the cursor filter.
  const { rows } = await q(`SELECT * FROM (SELECT l.*, (SELECT balance_pesewas FROM wallets w WHERE w.student_id=l.student_id) - COALESCE(sum(amount_pesewas) OVER (ORDER BY id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0)::bigint AS balance_after FROM ledger_entries l WHERE student_id=$1) x
      WHERE ($2::bigint IS NULL OR id < $2) ORDER BY id DESC LIMIT $3`, [req.user.id, cur, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.id], txView));
});

walletRoutes.post('/wallet/topups', ...S, async (req, res) => idempotent(req, res, 'topup', async () => {
  const { amountPesewas, channel } = req.body;
  const cfg = await getSettings();
  if (amountPesewas < cfg.minTopupPesewas || amountPesewas > cfg.maxTopupPesewas)
    throw new ApiError(422, 'topup_amount_out_of_range', `Top-up must be between ${cfg.minTopupPesewas} and ${cfg.maxTopupPesewas} pesewas`);
  if (channel === 'card') throw new ApiError(422, 'validation_failed', 'Card payments are not available yet', { errors: [{ field: 'channel', message: 'use mobile_money' }] });
  // A student cannot spam the provider (and their own phone) with prompts: 10 an hour, 3 open at once.
  const { rows: [r] } = await q(`SELECT count(*)::int n, count(*) FILTER (WHERE status='pending')::int open FROM topups WHERE student_id=$1 AND created_at > now() - interval '1 hour'`, [req.user.id]);
  if (r.n >= 10 || r.open >= 3) throw new ApiError(429, 'rate_limited', 'Too many top-ups in a short time', { retryAfterSeconds: 300 });
  const reference = 'TU' + crypto.randomBytes(9).toString('hex');
  const { rows: [u] } = await q('SELECT phone FROM users WHERE id=$1', [req.user.id]);
  const network = networkOf(u.phone);
  const { rows: [t] } = await q(`INSERT INTO topups (student_id,amount_pesewas,reference,network,channel) VALUES ($1,$2,$3,$4,$5) RETURNING *`, [req.user.id, amountPesewas, reference, network, channel]);
  try { await provider().createCollection({ reference, amountPesewas, phone: u.phone, network }); }
  catch { await q(`UPDATE topups SET status='failed', completed_at=now() WHERE id=$1`, [t.id]); throw new ApiError(502, 'payment_provider_error', 'Payment provider unavailable'); }
  return { status: 201, body: topupView(t) };
}));

walletRoutes.get('/wallet/topups/:id', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Top-up');
  const { rows: [t] } = await q('SELECT * FROM topups WHERE id=$1 AND student_id=$2', [req.params.id, req.user.id]);
  if (!t) throw notFound('Top-up');
  res.json(topupView(t));
});

// Mounted with a RAW body parser: the signature is over the exact bytes Payaza sent.
export const webhook = Router();
webhook.post('/webhooks/:provider', raw({ type: '*/*', limit: '64kb' }), async (req, res) => {
  if (req.params.provider !== 'payaza') throw notFound('Webhook');                 // only providers we actually integrate; the name is part of the dedupe key
  if (!verifyWebhook(req.body, req.get('x-payaza-signature'))) {
    alert({ severity: 'critical', dedupeKey: 'payaza-webhook', title: 'Payaza webhook rejected: bad signature',
      detail: 'A request to /webhooks/payaza failed signature verification. Check PAYAZA_WEBHOOK_SECRET or look for forged calls.' });
    throw new ApiError(401, 'unauthenticated', 'Bad signature');
  }
  let p; try { p = JSON.parse(req.body.toString('utf8')); } catch { throw new ApiError(400, 'validation_failed', 'Invalid JSON'); }
  const ref = p.transaction_reference, ok = p.transaction_status === 'Funds Received';
  if (typeof ref !== 'string' || ref.length > 64 || !['Funds Received', 'Transaction Failed'].includes(p.transaction_status)) throw new ApiError(400, 'validation_failed', 'Unrecognised event');
  try {
    await tx((c) => applyOutcome(c, req.params.provider, ref, ok ? 'success' : 'failed', p,
      ok ? { received: receivedPesewas(p.amount_received), validation: p.amount_validation } : {}));
  } catch (e) {
    alert({ severity: 'critical', dedupeKey: 'payaza-webhook', title: 'Payaza webhook could not be processed',
      detail: `A signed webhook failed while applying the top-up (${e?.name || 'Error'}). Money may be waiting: check topups and the log.` });
    throw e;
  }
  res.json({ received: true });          // the result (credited, duplicate, held...) is for our logs, not for the provider
});
