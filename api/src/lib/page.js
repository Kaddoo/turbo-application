import { ApiError } from './errors.js';

// Cursor pagination as the contract defines it: ?cursor=&limit= in, { data, page: { nextCursor, hasMore } } out.
// A cursor is the sort key of the last row sent, opaque to clients. Queries are keyset ("rows after this one"), never OFFSET,
// so page 500 costs the same as page 1 and rows added while paging cannot shift the window.
const enc = (k) => Buffer.from(JSON.stringify(k)).toString('base64url');
const dec = (c) => {
  try { const k = JSON.parse(Buffer.from(c, 'base64url').toString()); if (Array.isArray(k) && k.length <= 2) return k; } catch { /* fall through */ }
  throw new ApiError(400, 'validation_failed', 'Invalid cursor', { errors: [{ field: 'cursor', message: 'not a cursor from this API' }] });
};

export function pageArgs(req) {
  const n = parseInt(req.query.limit);
  if (req.query.limit !== undefined && (!Number.isInteger(n) || n < 1 || n > 100)) throw new ApiError(400, 'validation_failed', 'limit must be 1 to 100', { errors: [{ field: 'limit', message: '1 to 100' }] });
  const cur = req.query.cursor ? dec(req.query.cursor) : null;
  return { limit: n || 20, ts: cur?.[0] ?? null, id: cur?.[1] ?? null, fetch: (n || 20) + 1 };
}

// rows were fetched with LIMIT fetch (= limit + 1); key(row) -> [sortValue, id]
export function pageOf(rows, args, key, map = (r) => r) {
  const more = rows.length > args.limit;
  const items = rows.slice(0, args.limit);
  return { data: items.map(map), page: { nextCursor: more ? enc(key(items.at(-1))) : null, hasMore: more } };
}
