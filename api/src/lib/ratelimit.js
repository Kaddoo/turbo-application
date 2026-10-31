import { ApiError } from './errors.js';

// Per-process fixed-window limiter. nginx limit_req is the cross-process outer layer (see deploy/).
const buckets = new Map();
setInterval(() => { const now = Date.now(); for (const [k, v] of buckets) if (v.reset < now) buckets.delete(k); }, 30_000).unref();

export function hit(key, limit, windowMs) {
  const now = Date.now();
  let b = buckets.get(key);
  if (!b || b.reset < now) {
    // Memory is bounded: a flood of unique keys evicts the oldest entries instead of growing without limit.
    if (buckets.size >= 200_000) { let i = 0; for (const k of buckets.keys()) { buckets.delete(k); if (++i >= 5000) break; } }
    b = { n: 0, reset: now + windowMs }; buckets.set(key, b);
  }
  b.n++;
  return b.n <= limit ? 0 : Math.ceil((b.reset - now) / 1000);
}

export const limit = (name, max, windowMs, keyFn) => (req, _res, next) => {
  const key = keyFn(req);
  if (key == null) return next();                      // keyFn may opt a request out
  const retry = hit(`${name}:${key}`, max, windowMs);
  if (retry) return next(new ApiError(429, 'rate_limited', 'Too many requests', { retryAfterSeconds: retry }));
  next();
};
