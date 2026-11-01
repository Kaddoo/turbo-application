import { q } from '../db.js';
import { ApiError } from './errors.js';
import { sha256 } from './util.js';

// Wrap a money/booking/SMS handler. Same key + same body replays the stored response;
// same key + different body is 409 idempotency_key_reused. A concurrent duplicate gets 409 while the first runs.
// Options, for callers that are not signed in or that want a short memory:
//   subject        what the key is scoped to (default: the signed-in user's id). A public call passes a hash of what identifies the caller.
//   windowSeconds  a key older than this is forgotten and the request runs again (default: kept until housekeeping, 2 days).
//   required       false: no header means no idempotency, the handler just runs (older apps do not send one).
export async function idempotent(req, res, scope, fn, { subject = req.user?.id, windowSeconds = null, required = true } = {}) {
  const key = req.get('Idempotency-Key');
  if (!key && !required) { const { status = 200, body } = await fn(); return res.status(status).json(body); }
  if (!key || key.length < 8 || key.length > 128) throw new ApiError(422, 'validation_failed', 'Idempotency-Key header is required (8 to 128 characters)', { errors: [{ field: 'Idempotency-Key', message: 'required, 8 to 128 characters' }] });
  const s = `${scope}:${subject}`;
  const hash = sha256(JSON.stringify(req.body ?? {}));
  if (windowSeconds) await q('DELETE FROM idempotency_keys WHERE scope=$1 AND key=$2 AND created_at < now() - make_interval(secs => $3)', [s, key, windowSeconds]);
  const ins = await q(
    `INSERT INTO idempotency_keys (scope,key,request_hash) VALUES ($1,$2,$3) ON CONFLICT DO NOTHING RETURNING 1`, [s, key, hash]);
  if (!ins.rowCount) {
    const { rows: [r] } = await q('SELECT request_hash,status_code,response FROM idempotency_keys WHERE scope=$1 AND key=$2', [s, key]);
    if (r.request_hash !== hash) throw new ApiError(409, 'idempotency_key_reused', 'Idempotency-Key was used with a different request');
    if (r.status_code == null) throw new ApiError(409, 'conflict', 'A request with this key is still being processed', { retryAfterSeconds: 1 });
    return res.status(r.status_code).json(r.response);
  }
  try {
    const { status = 200, body } = await fn();
    await q('UPDATE idempotency_keys SET status_code=$3, response=$4 WHERE scope=$1 AND key=$2', [s, key, status, JSON.stringify(body)]);
    return res.status(status).json(body);
  } catch (e) {
    // A failed attempt must not poison the key: let the client retry after fixing the cause.
    await q('DELETE FROM idempotency_keys WHERE scope=$1 AND key=$2', [s, key]).catch(() => {});
    throw e;
  }
}
