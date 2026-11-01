// Log shipping to LogPulse: off without settings, ships only failures and warnings, and never ships secrets or personal data.
import test from 'node:test';
import assert from 'node:assert/strict';
import { config } from '../src/config.js';
import { logpulseEnabled, shipRequest, shipLogLine, maskText, _setClient } from '../src/lib/logpulse.js';

const flush = () => new Promise((r) => setTimeout(r, 20));
const withClient = (fn) => async () => {
  const logs = []; _setClient({ reportLog: async (e) => { logs.push(e); }, reportHealth: async () => {} });
  try { await fn(logs); } finally { _setClient(null); }
};

test('log shipping is off without settings', () => { assert.equal(logpulseEnabled(), false); });

test('only failing requests are shipped: 5xx as error, 401/403/429 and slow ones as warn', withClient(async (logs) => {
  const base = { method: 'GET', route: '/rides/:id', ms: 40, reqId: 'r-1' };
  shipRequest({ ...base, status: 200 });
  shipRequest({ ...base, status: 404 });
  shipRequest({ ...base, status: 500 });
  shipRequest({ ...base, status: 429 });
  shipRequest({ ...base, status: 200, ms: 3500 });
  shipRequest({ method: 'GET', route: '/health', status: 503, ms: 5, reqId: 'h' });
  await flush();
  assert.deepEqual(logs.map((l) => [l.level, l.statusCode]), [['error', 500], ['warn', 429], ['warn', 200]]);
  assert.equal(logs[0].path, '/rides/:id');
  assert.equal(logs[0].traceId, 'r-1');
}));

test('request entries carry no headers, body, query, ip or user agent', withClient(async (logs) => {
  shipRequest({ method: 'POST', route: '/auth/otp/verify?code=123456', status: 401, ms: 10, reqId: 'r' });
  await flush();
  const e = logs[0];
  assert.ok(!('request' in e) && !('response' in e));
  assert.ok(!e.path.includes('123456'));
}));

test('warn and error log lines ship with scalar fields; secrets, numbers, urls and positions are removed', withClient(async (logs) => {
  shipLogLine(30, [{ a: 1 }, 'info line']);                      // below warn: not shipped
  shipLogLine(50, [{ rideId: 'abc', count: 3, accessToken: 'TOKEN-1', phone: '+233201234567', lat: 5.6, signedUrl: 'https://x/y', err: 'duplicate key value (+233201234567)' }, 'top-up settled for +233201234567 at https://x/y?sig=abc']);
  await flush();
  assert.equal(logs.length, 1);
  const s = JSON.stringify(logs[0]);
  for (const bad of ['TOKEN-1', '233201234567', 'https://', 'sig=abc', '5.6']) assert.ok(!s.includes(bad), `shipped ${bad}`);
  assert.equal(logs[0].level, 'error');
  assert.equal(logs[0].metadata.rideId, 'abc');
  assert.equal(logs[0].metadata.count, 3);
}));

test('maskText removes jwt, email, url and phone-like numbers', () => {
  const m = maskText('user a.b@c.com paid +233 20 123 4567 see https://x.y/z token eyJhbGciOi.eyJzdWIiOi.sig_-1');
  for (const bad of ['a.b@c.com', '123 4567', 'https://', 'eyJ']) assert.ok(!m.includes(bad), m);
});

test('a client that throws never reaches the caller', async () => {
  _setClient({ reportLog: async () => { throw new Error('collector down'); } });
  try { shipRequest({ method: 'GET', route: '/x', status: 500, ms: 1, reqId: 'r' }); shipLogLine(50, ['boom']); await flush(); } finally { _setClient(null); }
});
