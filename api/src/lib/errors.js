// RFC 9457 problem details with stable `code` values from the contract.
export class ApiError extends Error {
  constructor(status, code, title, extra = {}) {
    super(title);
    this.status = status; this.code = code; this.title = title; this.extra = extra;
  }
}
export const bad = (title, errors) => new ApiError(400, 'validation_failed', title, { errors });
export const notFound = (what = 'Resource') => new ApiError(404, 'not_found', `${what} not found`);
export const conflict = (code, title, extra) => new ApiError(409, code, title, extra);
export const forbidden = (title = 'Not allowed') => new ApiError(403, 'forbidden', title);

// Postgres "your input is wrong" classes: invalid text representation, out of range, too long, bad datetime, invalid encoding, check/not-null violations.
const PG_CLIENT_ERRORS = new Set(['22P02', '22003', '22001', '22007', '22008', '22021', '22P05', '22023', '23502', '23514', '22004']);

export function errorHandler(log) {
  return (err, req, res, _next) => {
    let e = err;
    if (!(e instanceof ApiError)) {
      if (e?.type === 'entity.parse.failed') e = new ApiError(400, 'validation_failed', 'Invalid JSON body');
      else if (e?.type === 'entity.too.large') e = new ApiError(413, 'validation_failed', 'Body too large');
      else if (PG_CLIENT_ERRORS.has(e?.code)) e = new ApiError(400, 'validation_failed', 'Invalid value in request');   // bad uuid, number out of range, text too long...
      else if (e?.code === '23505') e = new ApiError(409, 'conflict', 'That already exists');
      else if (e?.code === '23503') e = new ApiError(409, 'conflict', 'Related record not found');
      else if (['57014', '55P03', '40001', '40P01', '53300', '57P03'].includes(e?.code) || e?.message?.includes('timeout exceeded when trying to connect')) {
        // statement/lock timeout, deadlock, serialization failure, too many connections: busy, not broken. Tell clients to retry.
        log.warn({ pg: e.code, reqId: req.id }, 'database busy');
        e = new ApiError(503, 'service_busy', 'Busy, please retry', { retryAfterSeconds: 2 });
      } else {
        log.error({ err: { message: e?.message, code: e?.code, stack: e?.stack }, reqId: req.id }, 'unhandled');
        e = new ApiError(500, 'conflict', 'Internal error');       // never echo database or library messages to the client
      }
    }
    if (e.extra.retryAfterSeconds) res.set('retry-after', String(e.extra.retryAfterSeconds));
    res.status(e.status).type('application/problem+json').json({
      type: 'about:blank', title: e.title, status: e.status, code: e.code,
      detail: e.extra.detail, instance: req.originalUrl, errors: e.extra.errors,
      retryAfterSeconds: e.extra.retryAfterSeconds,
    });
  };
}
