// Two behaviours that must stay true but cannot be switched on in staging: the minimum app version (0.0.0 means nobody is blocked) and 503 service_busy
// when the database is overloaded. Both run in-process with a temporary setting or a fake overloaded database. Needs a migrated database.
import test, { after, before } from 'node:test';
import assert from 'node:assert/strict';
import { buildApp } from '../src/app.js';
import { config } from '../src/config.js';
import { pool } from '../src/db.js';

let server, base;
before(async () => { server = buildApp().listen(0, '127.0.0.1'); await new Promise((r) => server.once('listening', r)); base = `http://127.0.0.1:${server.address().port}`; });
after(async () => { server.close(); await pool.end(); });
const get = (path, version) => fetch(base + path, { headers: version ? { 'x-app-version': version } : {} });
const withMin = async (min, fn) => { const was = { ...config.minVersion }; Object.assign(config.minVersion, min); try { await fn(); } finally { Object.assign(config.minVersion, was); } };

test('minimum web version 0.0.0 blocks nobody, even with an odd or very old version', async () => {
  assert.equal(config.minVersion.web, '0.0.0');
  for (const v of ['web/0.0.1', 'web/0.1.0', 'web/9.9.9', 'web/1', 'ios/0.0.1', 'android/0.0.1', 'garbage', undefined]) assert.equal((await get('/service-area', v)).status, 200, String(v));
});

test('a higher minimum answers 426 upgrade_required to older apps only, per platform', async () => {
  await withMin({ web: '1.2.0' }, async () => {
    const old = await get('/service-area', 'web/1.1.9');
    assert.equal(old.status, 426);
    assert.equal((await old.json()).code, 'upgrade_required');
    assert.equal((await get('/service-area', 'web/1.2.0')).status, 200);
    assert.equal((await get('/service-area', 'web/2.0.0')).status, 200);
    assert.equal((await get('/service-area', 'ios/0.0.1')).status, 200, 'other platforms keep their own minimum');
    assert.equal((await get('/service-area')).status, 200, 'no version header: curl, tests and the landing page are not blocked');
    for (const p of ['/app-config', '/health']) assert.notEqual((await get(p, 'web/0.0.1')).status, 426, `${p} is never blocked, so an old app can learn it must update`);
  });
});

test('an overloaded database answers 503 service_busy with Retry-After, and recovers', async () => {
  const real = pool.query.bind(pool);
  pool.query = () => Promise.reject(Object.assign(new Error('canceling statement due to statement timeout'), { code: '57014' }));
  try {
    const r = await get('/service-area');
    assert.equal(r.status, 503);
    assert.equal(r.headers.get('retry-after'), '2');
    const b = await r.json();
    assert.equal(b.code, 'service_busy');
    assert.equal(b.retryAfterSeconds, 2);
    assert.ok(!JSON.stringify(b).includes('statement timeout'), 'no internal detail leaks');
  } finally { pool.query = real; }
  assert.equal((await get('/service-area')).status, 200, 'normal again once the database is back');
});

test('too many connections and a deadlock are also service_busy', async () => {
  const real = pool.query.bind(pool);
  try {
    for (const code of ['53300', '40P01', '55P03']) {
      pool.query = () => Promise.reject(Object.assign(new Error('x'), { code }));
      const r = await get('/service-area');
      assert.equal(r.status, 503, code);
      assert.equal((await r.json()).code, 'service_busy', code);
    }
  } finally { pool.query = real; }
});
