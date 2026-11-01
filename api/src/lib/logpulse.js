import { config } from '../config.js';
import { FORBIDDEN_KEY } from './alerts.js';

// Ships warnings, errors and security-relevant request failures to LogPulse (central-logging-service) with @bevingh/telemetry.
// Off unless TELEMETRY_COLLECTOR_URL and TELEMETRY_API_KEY are both set. Everything here is fire-and-forget and never throws.
// What is shipped: request method, route pattern, status, duration, request id; warn/error log messages with scalar fields.
// What is not: headers, bodies, query strings, IPs, driver positions, and any field whose name or text looks like a token, OTP,
// phone number, email, URL or coordinate. Routine successful requests and location pings are never shipped.

export const logpulseEnabled = () => !!(config.logpulseUrl && config.logpulseKey);

let ready = null;                                         // Promise<client>, built on first use
let injected = null;
export const _setClient = (c) => { injected = c; ready = null; };

function getClient() {
  if (injected) return Promise.resolve(injected);
  if (!ready) {
    ready = import('@bevingh/telemetry').then(({ createTelemetryClient }) => createTelemetryClient({
      appId: config.logpulseAppId, collectorUrl: config.logpulseUrl.replace(/\/$/, ''), apiKey: config.logpulseKey,
      onReportError: () => {},                            // never log from here: a log line would be shipped again
    }));
  }
  return ready;
}

/** Masks things that must not leave the server inside free text: numbers that look like phones, emails, JWTs, URLs. */
export function maskText(s, max = 300) {
  return String(s ?? '')
    .replace(/eyJ[\w-]+\.[\w-]+\.[\w-]+/g, '[jwt]')
    .replace(/https?:\/\/\S+/g, '[url]')
    .replace(/[\w.+-]+@[\w-]+\.[\w.-]+/g, '[email]')
    .replace(/\+?\d[\d\s().-]{6,}\d/g, '[number]')
    .slice(0, max);
}

function scalars(obj) {
  const out = {};
  for (const [k, v] of Object.entries(obj || {})) {
    if (FORBIDDEN_KEY.test(k) || k === 'err' || k === 'msg') continue;
    if (typeof v === 'string') out[k] = maskText(v, 200);
    else if (typeof v === 'number' || typeof v === 'boolean') out[k] = v;
  }
  return out;
}

function send(entry) {
  if (!logpulseEnabled() && !injected) return;
  try { getClient().then((c) => c.reportLog(entry)).catch(() => {}); } catch { /* never throws */ }
}

/** One request that failed: 5xx as error; 401, 403 and 429 as warn (sign-in trouble and rate limits); slow ones as warn. 404s and successes are not shipped. */
export function shipRequest({ method, route, status, ms, reqId }) {
  const slow = ms >= 3000;
  const level = status >= 500 ? 'error' : (status === 401 || status === 403 || status === 429 || slow) ? 'warn' : null;
  if (!level || route === '/health') return;
  send({ level, method, path: String(route).split('?')[0].slice(0, 120), statusCode: status, duration: ms, traceId: reqId, metadata: { kind: 'request', slow } });
}

/** A pino warn or error line (level 40 or 50). args are pino's: (obj, msg) or (msg). */
export function shipLogLine(level, args) {
  if (level < 40) return;
  const [a, b] = args;
  const obj = a && typeof a === 'object' ? a : {};
  const message = typeof a === 'string' ? a : b;
  send({
    level: level >= 50 ? 'error' : 'warn', path: typeof obj.path === 'string' ? obj.path.split('?')[0].slice(0, 120) : undefined,
    error: { message: maskText(message ?? obj.err ?? 'log'), ...(obj.err && message ? { code: maskText(obj.err, 80) } : {}) },
    metadata: { kind: 'log', ...scalars(obj) },
  });
}

export function announceLogpulse(logger) {
  if (logpulseEnabled()) logger.info({ app: config.logpulseAppId }, 'log shipping enabled (LogPulse)');
  else logger.info('log shipping disabled: TELEMETRY_COLLECTOR_URL / TELEMETRY_API_KEY not set');
}

/** A health ping once a minute. Opt in with TELEMETRY_HEALTH_PING=true: the key needs metrics:write and must belong to TELEMETRY_APP_ID. */
export function startHealthPing() {
  if (!logpulseEnabled() || !config.logpulseHealth) return;
  const t = setInterval(() => { try { getClient().then((c) => c.reportHealth()).catch(() => {}); } catch { /* ignore */ } }, 60_000);
  t.unref();
}
