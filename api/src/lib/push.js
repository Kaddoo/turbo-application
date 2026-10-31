import crypto from 'node:crypto';
import fs from 'node:fs';
import { config } from '../config.js';

// Push providers. Each returns { status: 'sent' | 'gone' | 'retry' | 'failed', error?, retryAfterSeconds? }:
//   gone   -> the token is dead (app uninstalled / token rotated): delete the device
//   retry  -> Google is busy or unreachable: try again later
//   failed -> this message can never be delivered: stop
// No SDK: FCM's HTTP v1 API is one POST, and its OAuth token is a signed JWT, both a few lines of the standard library.

export function createFcm({ serviceAccount, fetchFn = fetch, tokenUrl, apiBase = 'https://fcm.googleapis.com' }) {
  const sa = typeof serviceAccount === 'string' ? JSON.parse(serviceAccount) : serviceAccount;
  const oauth = tokenUrl || sa.token_uri || 'https://oauth2.googleapis.com/token';
  let cached = null, inflight = null;

  const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
  async function accessToken(force = false) {
    if (!force && cached && cached.exp - Date.now() > 300_000) return cached.token;
    if (inflight) return inflight;                                // many sends at once share one token request
    inflight = (async () => {
      const now = Math.floor(Date.now() / 1000);
      const head = b64({ alg: 'RS256', typ: 'JWT' }), body = b64({ iss: sa.client_email, scope: 'https://www.googleapis.com/auth/firebase.messaging', aud: oauth, iat: now, exp: now + 3600 });
      const sig = crypto.sign('RSA-SHA256', Buffer.from(`${head}.${body}`), sa.private_key).toString('base64url');
      const r = await fetchFn(oauth, { method: 'POST', headers: { 'content-type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer', assertion: `${head}.${body}.${sig}` }), signal: AbortSignal.timeout(8000) });
      if (!r.ok) throw new Error(`oauth ${r.status}`);
      const j = await r.json();
      cached = { token: j.access_token, exp: Date.now() + (j.expires_in ?? 3600) * 1000 };
      return cached.token;
    })().finally(() => { inflight = null; });
    return inflight;
  }

  async function post(message, token) {
    return fetchFn(`${apiBase}/v1/projects/${sa.project_id}/messages:send`, { method: 'POST', signal: AbortSignal.timeout(8000),
      headers: { authorization: `Bearer ${token}`, 'content-type': 'application/json' }, body: JSON.stringify({ message }) });
  }

  return {
    async send({ token, title, body, data = {}, ttlSeconds = 3600, priority = 5, collapseKey }) {
      // FCM data values must all be strings.
      const strData = Object.fromEntries(Object.entries(data).filter(([, v]) => v != null).map(([k, v]) => [k, String(v)]));
      const high = priority >= 10;
      const message = {
        token, notification: { title, body }, data: strData,
        android: { priority: high ? 'HIGH' : 'NORMAL', ttl: `${ttlSeconds}s`, ...(collapseKey && { collapse_key: collapseKey }), notification: { channel_id: high ? 'turbo_urgent' : 'turbo_default' } },
        apns: { headers: { 'apns-priority': high ? '10' : '5', 'apns-expiration': String(Math.floor(Date.now() / 1000) + ttlSeconds), ...(collapseKey && { 'apns-collapse-id': collapseKey }) }, payload: { aps: { sound: 'default' } } },
        webpush: { headers: { TTL: String(ttlSeconds), Urgency: high ? 'high' : 'normal' } },
      };
      try {
        let r = await post(message, await accessToken());
        if (r.status === 401) r = await post(message, await accessToken(true));      // token expired early: fetch a new one once
        if (r.ok) return { status: 'sent' };
        const j = await r.json().catch(() => ({}));
        const code = j.error?.details?.find?.((d) => d.errorCode)?.errorCode || j.error?.status || '';
        if (r.status === 404 || code === 'UNREGISTERED') return { status: 'gone', error: code || 'UNREGISTERED' };
        if (r.status === 400 && /registration token|INVALID_ARGUMENT/i.test(`${code} ${j.error?.message}`) && /token/i.test(j.error?.message || '')) return { status: 'gone', error: 'invalid token' };
        if (r.status === 429 || r.status >= 500) return { status: 'retry', error: `fcm ${r.status} ${code}`, retryAfterSeconds: Number(r.headers.get('retry-after')) || undefined };
        return { status: 'failed', error: `fcm ${r.status} ${code}` };
      } catch (e) { return { status: 'retry', error: e.message }; }          // network error or timeout
    },
  };
}

// Development: print instead of sending. Tokens that start with "gone-" / "retry-" act as a dead / flaky device, so the worker's
// pruning and back-off paths can be exercised without Google. Never available in production (config refuses it).
const consoleProvider = {
  async send({ token, title, body, data }) {
    if (token.startsWith('gone-')) return { status: 'gone', error: 'UNREGISTERED' };
    if (token.startsWith('retry-')) return { status: 'retry', error: 'simulated outage' };
    if (process.env.PUSH_SIMULATED_LATENCY_MS) await new Promise((r) => setTimeout(r, Number(process.env.PUSH_SIMULATED_LATENCY_MS)));   // pretend Google takes this long (load testing)
    if (config.env !== 'test') console.log(`[push:console] ${token.slice(0, 12)}… "${title}" — ${body} ${JSON.stringify(data)}`);
    return { status: 'sent' };
  },
};

let provider;
export function pushProvider() {
  if (provider) return provider;
  if (config.pushProvider === 'fcm') {
    const raw = config.fcmServiceAccount.trim();
    provider = createFcm({ serviceAccount: raw.startsWith('{') ? raw : fs.readFileSync(raw, 'utf8') });
  } else if (config.pushProvider === 'console') provider = consoleProvider;
  else provider = { async send() { return { status: 'sent' }; } };       // 'off'
  return provider;
}
