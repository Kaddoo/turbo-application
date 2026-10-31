import fs from 'node:fs';
import YAML from 'yaml';
import Ajv2020 from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
import { config } from '../config.js';
import { ApiError } from './errors.js';

// The OpenAPI file is the interface the apps and dashboard were built against. This module makes the API obey it:
//  - every request body is validated against the contract's schema (so bad input never reaches a handler), and
//  - in development/test every response is validated too, so drift between code and contract fails loudly.
const file = new URL('../../contract/openapi.yaml', import.meta.url);
export const spec = YAML.parse(fs.readFileSync(file, 'utf8'));

const ajv = new Ajv2020({ strict: false, allErrors: true, allowUnionTypes: true, validateFormats: true });
addFormats(ajv);
ajv.addFormat('password', true);
ajv.addSchema(spec, 'turbo');

const esc = (s) => s.replace(/~/g, '~0').replace(/\//g, '~1');
const validators = new Map();
const compiled = (pointer) => {
  if (!validators.has(pointer)) validators.set(pointer, ajv.compile({ $ref: `turbo#${pointer}` }));
  return validators.get(pointer);
};

// path template -> regex. Operations are indexed by method, segment count and first segment, so matching a request looks at a
// handful of candidates instead of scanning all ~115 patterns (this runs on every request).
const index = new Map();
const keyOf = (method, segs) => `${method} ${segs.length} ${segs[0] ?? ''}`;
for (const [path, item] of Object.entries(spec.paths)) {
  const segs = path.split('/').filter(Boolean);
  const re = new RegExp('^' + path.replace(/\{[^}]+\}/g, '([^/]+)') + '/?$');
  const specificity = segs.filter((x) => !x.startsWith('{')).length * 10 - (path.match(/\{/g) || []).length;
  for (const [method, op] of Object.entries(item)) if (['get', 'post', 'put', 'patch', 'delete'].includes(method)) {
    const k = keyOf(method.toUpperCase(), segs), list = index.get(k) ?? [];
    list.push({ method: method.toUpperCase(), path, re, specificity, op }); list.sort((a, b) => b.specificity - a.specificity); index.set(k, list);
  }
}
export const findOp = (method, p) => {
  const segs = p.split('/').filter(Boolean);
  return index.get(keyOf(method, segs))?.find((o) => o.re.test(p));
};

const fieldOf = (e) => (e.instancePath || '').replace(/^\//, '').replace(/\//g, '.') || (e.params?.missingProperty ?? '');
const toErrors = (errs) => errs.slice(0, 20).map((e) => ({
  field: [fieldOf(e), e.keyword === 'required' || e.keyword === 'additionalProperties' ? (e.params.missingProperty ?? e.params.additionalProperty) : ''].filter(Boolean).join('.'),
  message: e.keyword === 'additionalProperties' ? 'unknown field' : e.keyword === 'required' ? 'is required' : e.message,
}));

// ---- requests
// Order matters: who you are, then whether you may, THEN whether your body is valid. Checking the body first would let anonymous callers
// probe our schemas and would answer a forbidden caller with a validation error instead of 403. So the lookup happens up front, and the
// body check is a function that authenticate/requireRole call once the caller has passed (public endpoints validate immediately).
export function contractRequest(req, _res, next) {
  const hit = findOp(req.method, req.path);
  if (!hit) return next();
  req.contractOp = hit;
  const rb = hit.op.requestBody;
  const schemaRef = rb?.content?.['application/json']?.schema;
  req.validated = !schemaRef;
  if (schemaRef) req.validateBody = () => {
    if (req.validated) return;
    req.validated = true;
    const present = req.body !== undefined && !(typeof req.body === 'object' && Object.keys(req.body).length === 0 && !rb.required);
    if (!present) { if (rb.required) throw new ApiError(422, 'validation_failed', 'Request body is required'); return; }
    const v = compiled(`/paths/${esc(hit.path)}/${hit.method.toLowerCase()}/requestBody/content/application~1json/schema`);
    if (!v(req.body)) throw new ApiError(422, 'validation_failed', 'Request does not match the API contract', { errors: toErrors(v.errors) });
  };
  if (schemaRef && Array.isArray(hit.op.security) && hit.op.security.length === 0) { try { req.validateBody(); } catch (e) { return next(e); } }   // public: nothing to check first
  next();
}
export const ensureBody = (req) => req.validateBody?.();

// ---- responses (development/test only unless CONTRACT_RESPONSES says otherwise)
const mode = process.env.CONTRACT_RESPONSES || (config.env === 'production' ? 'off' : 'strict');
export function contractResponse(req, res, next) {
  if (mode === 'off') return next();
  const json = res.json.bind(res);
  res.json = (body) => {
    const hit = req.contractOp;
    if (hit) {
      body = body === undefined ? body : JSON.parse(JSON.stringify(body));      // validate what the client will actually receive (Dates become strings, undefined disappears)
      const code = String(res.statusCode);
      const problems = [];
      if (!req.validated && res.statusCode < 400) problems.push('the request body was never validated against the contract (route forgot a role/auth guard)');
      if (res.statusCode < 400) {
        const r = hit.op.responses?.[code];
        if (!r) problems.push(`status ${code} is not declared for ${hit.method} ${hit.path} (declared: ${Object.keys(hit.op.responses).join(', ')})`);
        else if (r.content?.['application/json']?.schema) {
          const v = compiled(`/paths/${esc(hit.path)}/${hit.method.toLowerCase()}/responses/${code}/content/application~1json/schema`);
          if (!v(body)) problems.push(...toErrors(v.errors).map((e) => `${e.field || '(root)'}: ${e.message}`));
        } else if (body !== undefined && body !== null) problems.push(`status ${code} should have no body`);
      } else if (res.get('content-type')?.includes('problem+json')) {
        const v = compiled('/components/schemas/Problem');
        if (!v(body)) problems.push(...toErrors(v.errors).map((e) => `problem ${e.field}: ${e.message}`));
      }
      if (problems.length) {
        const msg = `CONTRACT VIOLATION ${hit.method} ${hit.path} -> ${code}: ${problems.slice(0, 8).join(' | ')}`;
        console.error(msg);
        if (mode === 'strict') { res.status(500); return json({ type: 'about:blank', title: msg, status: 500, code: 'conflict' }); }
      }
    }
    return json(body);
  };
  next();
}
