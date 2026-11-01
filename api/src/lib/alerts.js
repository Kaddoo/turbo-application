import { config } from '../config.js';
import { log } from '../app.js';

// Operational alerts to inlet (https://github.com/KosherKev/inlet). Off unless INLET_SECRET_KEY and INLET_PRODUCT_ID are both set.
// alert() never throws, gives up after 3 seconds per try (one retry), and logs failures without the payload.
// Alerts carry ids and counts only: no tokens, OTPs, document URLs, phone numbers or coordinates.

export const ALERT_TYPES = { custom: 'custom_alert', errorSpike: 'error_spike', healthCheckFailed: 'health_check_failed' };
const SEVERITIES = new Set(['info', 'low', 'normal', 'high', 'critical']);
const TIMEOUT_MS = 3000;

export const alertsEnabled = () => !!(config.inletSecretKey && config.inletProductId);

let client = null;
let injected = null;                                   // tests swap the client for a fake
export const _setClient = (c) => { injected = c; client = null; };

async function getClient() {
  if (injected) return injected;
  if (client) return client;
  const { InletClient } = await import('@bevingh/sdk-node');
  client = new InletClient({
    apiKey: config.inletSecretKey,
    ...(config.inletBaseUrl && { baseUrl: config.inletBaseUrl }),
    fetch: (req) => fetch(req, { signal: AbortSignal.timeout(TIMEOUT_MS) }),
  });
  return client;
}

// Keys that must never leave the server inside an alert, whatever a caller passes by mistake.
export const FORBIDDEN_KEY = /token|otp|code|secret|password|authorization|phone|url|lat|lng|coord|location|email|name/i;
function scrub(payload) {
  const out = {};
  for (const [k, v] of Object.entries(payload || {})) {
    if (FORBIDDEN_KEY.test(k)) continue;
    if (typeof v === 'string') out[k] = v.slice(0, 300);
    else if (typeof v === 'number' || typeof v === 'boolean') out[k] = v;
  }
  return out;
}

/** Sends one alert. Resolves true if inlet accepted it, false if alerts are off or it could not be delivered. */
export async function alert({ type = ALERT_TYPES.custom, severity, dedupeKey, title, detail, payload } = {}) {
  if (!alertsEnabled() && !injected) return false;
  if (!SEVERITIES.has(severity) || !dedupeKey || !title) { log.warn({ dedupeKey }, 'alert skipped: needs severity, dedupeKey and title'); return false; }
  const body = {
    productId: config.inletProductId, module: 'alert', type, severity, dedupeKey: String(dedupeKey).slice(0, 120),
    payload: { title: String(title).slice(0, 200), ...(detail && { detail: String(detail).slice(0, 500) }), ...scrub(payload) },
  };
  for (let attempt = 1; attempt <= 2; attempt++) {
    try {
      await (await getClient()).sendEvent(body);
      return true;
    } catch (e) {
      // The error is never logged with the body. Status or error name only.
      if (attempt === 2) log.warn({ dedupeKey, status: e?.status, err: e?.name }, 'alert not delivered');
    }
  }
  return false;
}

/** One log line at startup saying whether alerts are on. */
export function announceAlerts(logger = log) {
  if (alertsEnabled()) logger.info({ sosSms: !!config.sosOncallPhone }, 'alerts enabled (inlet)');
  else logger.info({ sosSms: !!config.sosOncallPhone }, 'alerts disabled: INLET_SECRET_KEY / INLET_PRODUCT_ID not set');
}

// ---- 5xx rate over the last 5 minutes (per API process; each process in the cluster watches its own traffic) ----------------------
const BUCKET_MS = 60_000, BUCKETS = 5;
const buckets = new Map();                             // minute -> { total, errors }
const minute = (t = Date.now()) => Math.floor(t / BUCKET_MS);

export function trackRequest(status, t = Date.now()) {
  const m = minute(t);
  const b = buckets.get(m) || { total: 0, errors: 0 };
  b.total++; if (status >= 500) b.errors++;
  buckets.set(m, b);
  for (const k of buckets.keys()) if (k <= m - BUCKETS) buckets.delete(k);
}

/** Alerts (high) when more than `maxRate` of the last 5 minutes' requests failed with 5xx, once there are `minRequests` to judge by. */
export async function checkErrorRate({ now = Date.now(), maxRate = 0.02, minRequests = 50 } = {}) {
  const m = minute(now);
  let total = 0, errors = 0;
  for (const [k, b] of buckets) if (k > m - BUCKETS && k <= m) { total += b.total; errors += b.errors; }
  if (total < minRequests || errors / total <= maxRate) return false;
  return alert({ severity: 'high', dedupeKey: 'api-5xx', title: 'API error rate above 2%',
    detail: `${errors} of ${total} requests failed with 5xx in the last 5 minutes (one API process)`, payload: { errors, total } });
}
export const _resetErrorRate = () => buckets.clear();
