import { ApiError } from './errors.js';
import { isUuid } from './util.js';

// Typed readers for query-string filters. A bad filter is a 422 with the field named, never a database error or a silently ignored value.
const bad = (field, message) => new ApiError(422, 'validation_failed', 'Invalid filter', { errors: [{ field, message }] });
export const qEnum = (req, name, allowed) => { const v = req.query[name]; if (v === undefined || v === '') return null; if (!allowed.includes(v)) throw bad(name, `one of ${allowed.join(', ')}`); return v; };
export const qUuid = (req, name) => { const v = req.query[name]; if (v === undefined || v === '') return null; if (!isUuid(v)) throw bad(name, 'must be an id'); return v; };
export const qDate = (req, name) => { const v = req.query[name]; if (v === undefined || v === '') return null; if (!/^\d{4}-\d{2}-\d{2}$/.test(v) || Number.isNaN(Date.parse(v))) throw bad(name, 'YYYY-MM-DD'); return v; };
export const qBool = (req, name) => { const v = req.query[name]; if (v === undefined || v === '') return null; if (!['true', 'false'].includes(v)) throw bad(name, 'true or false'); return v === 'true'; };
export const qInt = (req, name, min, max, dflt) => { const v = req.query[name]; if (v === undefined || v === '') return dflt; const n = Number(v); if (!Number.isInteger(n) || n < min || n > max) throw bad(name, `${min} to ${max}`); return n; };
// Search text for ILIKE: wildcards the user typed are escaped so "%" means a percent sign, not "match everything".
export const qText = (req, name, max = 60) => { const v = req.query[name]; if (v === undefined || v === '') return null; if (v.length > max) throw bad(name, `up to ${max} characters`); return v.replace(/[\\%_]/g, '\\$&'); };
