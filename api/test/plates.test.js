// Plates: one physical vehicle, one plate. Case, spaces and hyphens do not make a different plate, a retired vehicle still owns its plate, and the
// answer says which. The migration refuses to run if two live vehicles already collide. Needs the running API and a migrated, seeded database.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import pg from 'pg';
import { call, expect, staffLogin, pool, closeDb } from './walk-helpers.js';
after(closeDb);

const hr = async () => (await staffLogin('hr@turbo.test')).accessToken;
const letters = () => Array.from({ length: 2 }, () => String.fromCharCode(65 + Math.floor(Math.random() * 26))).join('');
const fresh = () => `${letters()}-${Math.floor(1000 + Math.random() * 8999)}-${20 + Math.floor(Math.random() * 9)}`;
const vehicle = (token, plateNumber, extra = {}) => call('POST', '/admin/vehicles', { token, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber, ...extra } });

test('the same plate in another case, with spaces or with hyphens removed is a duplicate, and the answer says it is active', async () => {
  const t = await hr(); const p = fresh();
  const made = expect(await vehicle(t, p), 201);
  const norm = p.replace(/[^A-Z0-9]/gi, '').toUpperCase();
  assert.equal((await pool.query('SELECT plate_normalised FROM vehicles WHERE id=$1', [made.id])).rows[0].plate_normalised, norm);
  for (const variant of [p.toLowerCase(), p.replace(/-/g, ' '), norm, ` ${p.replace(/-/g, '.')} `]) {
    const r = await vehicle(t, variant);
    assert.equal(r.status, 409, variant);
    assert.equal(r.body.code, 'duplicate_plate', variant);
    assert.match(r.body.detail, /active vehicle/, variant);
  }
});

test('a retired vehicle still owns its plate, and the answer tells staff to reactivate it', async () => {
  const t = await hr(); const p = fresh();
  const v = expect(await vehicle(t, p), 201);
  expect(await call('PATCH', `/admin/vehicles/${v.id}`, { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber: p, status: 'retired' } }), 200);
  const r = await vehicle(t, p.replace(/-/g, ' '));
  assert.equal(r.status, 409);
  assert.equal(r.body.code, 'duplicate_plate');
  assert.match(r.body.detail, /retired vehicle/);
  assert.match(r.body.detail, /Reactivate that vehicle/);
});

test('editing a vehicle onto another vehicle\'s plate is refused the same way; keeping its own plate is fine', async () => {
  const t = await hr(); const p1 = fresh(), p2 = fresh();
  const a = expect(await vehicle(t, p1), 201); expect(await vehicle(t, p2), 201);
  const clash = await call('PATCH', `/admin/vehicles/${a.id}`, { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Blue', plateNumber: p2.toLowerCase() } });
  assert.equal(clash.status, 409); assert.equal(clash.body.code, 'duplicate_plate');
  expect(await call('PATCH', `/admin/vehicles/${a.id}`, { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Blue', plateNumber: p1.replace(/-/g, ' ') } }), 200, 'its own plate, written differently');
});

test('migration 015 stops and lists the collisions when two live vehicles already share a plate once normalised', async () => {
  const admin = new pg.Client({ connectionString: process.env.DATABASE_URL }); await admin.connect();
  const name = `turbo_migtest_${Date.now()}`;
  await admin.query(`CREATE DATABASE ${name}`);
  const url = new URL(process.env.DATABASE_URL); url.pathname = `/${name}`;
  const c = new pg.Client({ connectionString: url.toString() }); await c.connect();
  try {
    const dir = new URL('../migrations/', import.meta.url);
    const files = fs.readdirSync(dir).filter((f) => f.endsWith('.sql')).sort();
    for (const f of files.filter((x) => x < '015')) await c.query(fs.readFileSync(new URL(f, dir), 'utf8'));
    await c.query(`INSERT INTO vehicles (make,model,colour,plate_number) VALUES ('K','P','R','AB-1234-26'), ('K','P','R','AB 1234 26'), ('K','P','R','CD-1-26')`);
    const m = fs.readFileSync(new URL('015_plate_normalised.sql', dir), 'utf8');
    await assert.rejects(() => c.query(m), /plate collisions after normalising.*AB123426/s);
    const cols = await c.query(`SELECT 1 FROM information_schema.columns WHERE table_name='vehicles' AND column_name='plate_normalised'`);
    assert.equal(cols.rowCount, 0, 'nothing changed');
    await c.query(`DELETE FROM vehicles WHERE plate_number='AB 1234 26'`);
    await c.query(m);                                                   // no collisions: it applies
    assert.equal((await c.query(`SELECT plate_normalised FROM vehicles ORDER BY plate_normalised`)).rows.map((r) => r.plate_normalised).join(','), 'AB123426,CD126');
    await assert.rejects(() => c.query(`INSERT INTO vehicles (make,model,colour,plate_number) VALUES ('K','P','R','ab 1234-26')`), /vehicles_plate_normalised_uq/);
  } finally { await c.end(); await admin.query(`DROP DATABASE ${name}`); await admin.end(); }
});
