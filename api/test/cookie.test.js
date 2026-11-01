// The turbo_rt refresh cookie: HttpOnly, SameSite=Strict, Secure from config, Path=/v1/auth, and the old Path=/ cookie is expired whenever the new one is
// set or cleared. The API for these tests runs with COOKIE_SECURE=true (as staging does). Needs the running API and a migrated, seeded database.
import test from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, closeDb } from './walk-helpers.js';
import { after } from 'node:test';
after(closeDb);

const ADMIN = process.env.ADMIN_URL || 'http://localhost:5173';
const cookiesOf = (r) => r.headers.getSetCookie().filter((c) => c.startsWith('turbo_rt='));
const attr = (c, name) => c.split(';').map((x) => x.trim()).find((x) => x.toLowerCase().startsWith(name.toLowerCase()));
const nameValue = (c) => c.split(';')[0];
const fresh = (cs) => cs.find((c) => /Path=\/v1\/auth/i.test(c));
const old = (cs) => cs.find((c) => /Path=\/(;|$)/i.test(c));

async function login() {
  const r = await call('POST', '/auth/admin/login', { body: { email: 'support@turbo.test', password: 'Turbo-demo-1' }, headers: { origin: ADMIN } });
  return expect(r, 200) && r;
}

test('sign-in sets the cookie with the hardened attributes and expires the old Path=/ cookie', async () => {
  const cs = cookiesOf(await login());
  assert.equal(cs.length, 2, JSON.stringify(cs));
  const c = fresh(cs);
  for (const a of ['HttpOnly', 'Secure', 'SameSite=Strict', 'Path=/v1/auth']) assert.ok(attr(c, a), `${a} in ${c}`);
  assert.match(c, /Max-Age=2592000/);
  assert.ok(nameValue(c).length > 'turbo_rt='.length, 'carries a token');
  const o = old(cs);
  assert.ok(o && /Max-Age=0/.test(o) && nameValue(o) === 'turbo_rt=', `old cookie expired: ${o}`);
  assert.ok(cs.indexOf(o) < cs.indexOf(c), 'the old one is expired first, so the new cookie wins wherever a proxy rewrites both to one path');
  assert.ok(attr(o, 'HttpOnly') && attr(o, 'Secure') && attr(o, 'SameSite=Strict'));
});

test('refresh rotates the cookie with the same attributes and expires the old one again', async () => {
  const jar = nameValue(fresh(cookiesOf(await login())));
  const r = await call('POST', '/auth/refresh', { headers: { cookie: jar, origin: ADMIN } });
  expect(r, 200);
  const cs = cookiesOf(r);
  const c = fresh(cs);
  for (const a of ['HttpOnly', 'Secure', 'SameSite=Strict', 'Path=/v1/auth']) assert.ok(attr(c, a), `${a} in ${c}`);
  assert.notEqual(nameValue(c), jar, 'the token rotated');
  assert.ok(old(cs) && /Max-Age=0/.test(old(cs)));
});

test('a session started before this change (cookie with Path=/) still refreshes, and moves to the new path', async () => {
  const jar = nameValue(fresh(cookiesOf(await login())));          // the same token a browser holds under the old Path=/
  const r = await call('POST', '/auth/refresh', { headers: { cookie: jar, origin: ADMIN } });
  expect(r, 200);
  assert.ok(fresh(cookiesOf(r)) && old(cookiesOf(r)));
});

test('sign-out clears the cookie on the new path and the old one', async () => {
  const l = await login();
  const out = await call('POST', '/auth/logout', { token: l.body.accessToken });
  assert.equal(out.status, 204);
  const cs = cookiesOf(out);
  assert.equal(cs.length, 2, JSON.stringify(cs));
  for (const c of cs) { assert.match(c, /Max-Age=0/); assert.equal(nameValue(c), 'turbo_rt='); assert.ok(attr(c, 'Secure') && attr(c, 'HttpOnly') && attr(c, 'SameSite=Strict')); }
  assert.ok(fresh(cs) && old(cs));
});

test('a mobile sign-in gets no cookie at all', async () => {
  const r = await call('POST', '/auth/admin/login', { body: { email: 'support@turbo.test', password: 'Turbo-demo-1' } });   // no browser origin
  expect(r, 200);
  assert.equal(cookiesOf(r).length, 0);
});

// Secure comes from config, not from how the request arrived (behind Caddy the API sees plain http).
test('Secure follows the setting, not the request; Path follows the setting too', async () => {
  const { config } = await import('../src/config.js');
  const { setRefreshCookie, clearRefreshCookie } = await import('../src/lib/session.js');
  const run = (fn, secure, path = '/v1/auth') => {
    const was = [config.cookieSecure, config.cookiePath]; config.cookieSecure = secure; config.cookiePath = path;
    const out = []; const res = { append: (k, v) => out.push(v) };
    try { fn(res); } finally { [config.cookieSecure, config.cookiePath] = was; }
    return out;
  };
  assert.ok(run((r) => setRefreshCookie(r, 'tok'), true).every((c) => /; Secure/.test(c)));
  assert.ok(run((r) => setRefreshCookie(r, 'tok'), false).every((c) => !/Secure/.test(c)), 'local http development: no Secure');
  assert.ok(run((r) => clearRefreshCookie(r), false).every((c) => !/Secure/.test(c)));
  const rootOnly = run((r) => setRefreshCookie(r, 'tok'), false, '/');
  assert.equal(rootOnly.length, 1, 'with Path=/ there is no separate old cookie to expire');
});

test('only the auth routes read or clear the cookie: everything that does lives under /auth', async () => {
  const { execFileSync } = await import('node:child_process');
  const hits = execFileSync('grep', ['-rn', '-E', 'readCookie\\(|clearRefreshCookie\\(|setRefreshCookie\\(', 'src/routes'], { encoding: 'utf8' }).trim().split('\n');
  const files = new Set(hits.map((l) => l.split(':')[0]));
  assert.deepEqual([...files].sort(), ['src/routes/auth.js']);
});
