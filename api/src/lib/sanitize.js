import { ApiError } from './errors.js';

// One gate in front of every route. The per-field checks in each handler stay (they know the business rules);
// this closes the classes of input no handler should have to think about.
const FORBIDDEN_KEYS = new Set(['__proto__', 'constructor', 'prototype']);
// C0/C1 controls except tab, newline and carriage return; bidi overrides and isolates (can make "Esi" render as "isE"); zero-width joiners used to hide text.
const BAD_CHARS = /[\u0000-\u0008\u000b\u000c\u000e-\u001f\u007f-\u009f‪-‮⁦-⁩​-‍⁠﻿]/;
const MAX_DEPTH = 8, MAX_NODES = 3000, MAX_STRING = 5000, MAX_QUERY_VALUE = 200, MAX_QUERY_KEYS = 20;

const invalid = (field, message) => new ApiError(400, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });

function checkString(s, path) {
  if (s.length > MAX_STRING) throw invalid(path, `longer than ${MAX_STRING} characters`);
  if (!s.isWellFormed()) throw invalid(path, 'contains invalid unicode');            // lone surrogates make Postgres reject the row
  if (BAD_CHARS.test(s)) throw invalid(path, 'contains control or hidden characters');
}

export function checkJson(root) {
  let nodes = 0;
  const walk = (v, depth, path) => {
    if (++nodes > MAX_NODES) throw invalid(path, 'request is too complex');
    if (depth > MAX_DEPTH) throw invalid(path, 'nested too deeply');
    if (typeof v === 'string') return checkString(v, path);
    if (typeof v === 'number') { if (!Number.isFinite(v)) throw invalid(path, 'must be a finite number'); return; }
    if (v === null || typeof v === 'boolean') return;
    if (Array.isArray(v)) { v.forEach((x, i) => walk(x, depth + 1, `${path}[${i}]`)); return; }
    if (typeof v === 'object') {
      for (const k of Object.keys(v)) {
        if (FORBIDDEN_KEYS.has(k)) throw invalid(path, `key "${k}" is not allowed`);
        checkString(k, path);
        walk(v[k], depth + 1, path ? `${path}.${k}` : k);
      }
      return;
    }
    throw invalid(path, 'unsupported value');
  };
  walk(root, 0, '');
}

export function sanitizeRequest(req, _res, next) {
  try {
    // Query: plain short strings only. `?status=a&status=b` would otherwise reach SQL as an array.
    const keys = Object.keys(req.query);
    if (keys.length > MAX_QUERY_KEYS) throw invalid('query', 'too many parameters');
    for (const k of keys) {
      const v = req.query[k];
      if (FORBIDDEN_KEYS.has(k)) throw invalid(k, 'not allowed');
      if (typeof v !== 'string') throw invalid(k, 'must be a single value');
      if (v.length > MAX_QUERY_VALUE) throw invalid(k, 'too long');
      if (!v.isWellFormed() || BAD_CHARS.test(v)) throw invalid(k, 'contains invalid characters');
    }
    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(req.method)) {
      const type = (req.get('content-type') || '').split(';')[0].trim().toLowerCase();
      const hasBody = Number(req.get('content-length') || 0) > 0 || req.get('transfer-encoding');
      // Uploads (signed PUT) and webhooks are parsed raw by their own routes; everything else is JSON.
      const raw = req.path.startsWith('/uploads/') || req.path.startsWith('/webhooks/');
      if (hasBody && !raw && type !== 'application/json') throw new ApiError(415, 'validation_failed', 'Content-Type must be application/json');
      if (!raw && req.body !== undefined) {
        // a JSON body must be an object: `[]`, `5` and `"x"` make `req.body?.field` code misbehave
        if (req.body === null || typeof req.body !== 'object' || Array.isArray(req.body)) throw invalid('body', 'must be a JSON object');
        checkJson(req.body);
      }
    }
    next();
  } catch (e) { next(e); }
}

// Free text that ends up in an SMS or an email: no links, no line breaks, short. Names are user-controlled and
// would otherwise let a student send arbitrary text to arbitrary numbers from Turbo's sender ID.
export const safeForMessage = (s, max = 30) =>
  String(s ?? '').replace(/https?:\/\/\S+|www\.\S+|\S+\.(com|net|org|gh|io|co)\b\S*/gi, '').replace(/[^\p{L}\p{N} '.-]/gu, '').replace(/\s+/g, ' ').trim().slice(0, max) || 'A Turbo rider';
