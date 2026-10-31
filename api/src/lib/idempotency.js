import { q } from '../db.js';
import { ApiError } from './errors.js';
import { sha256 } from './util.js';

// Wrap a money/booking handler. Same key + same body replays the stored response;
// same key + different body is a 422. A concurrent duplicate gets 409 while the first runs.
export async function idempotent(req, res, scope, fn) {
  const key = req.get('Idempotency-Key');
  if (!key || key.length < 8 || key.length > 128) throw new ApiError(422, 'validation_failed', 'Idempotency-Key header is required (8 to 128 characters)', { errors: [{ field: 'Idempotency-Key', message: 'required, 8 to 128 characters' }] });
  const s = `${scope}:${req.user.id}`;
  const hash = sha256(JSON.stringify(req.body ?? {}));
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
