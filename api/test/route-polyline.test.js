// The road from pickup to drop-off travels with the quote, the booked ride and the driver's view. Without a Maps key the server sends
// the straight line between the two points. Needs the running API and worker, migrated and seeded.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, closeDb, rideTo } from './walk-helpers.js';
import { encodePolyline } from '../src/lib/util.js';
after(closeDb);

test('encodePolyline matches the example in Google\'s documentation', () => {
  assert.equal(encodePolyline([[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]]), '_p~iF~ps|U_ulLnnqC_mqNvxq`@');
});

test('the quote, the ride and the driver view all carry the same routePolyline', async () => {
  const { s, d, ride, quote } = await rideTo('assigned');
  assert.equal(typeof quote.routePolyline, 'string');
  assert.ok(quote.routePolyline.length > 0);
  assert.equal(ride.routePolyline, quote.routePolyline);
  const mine = expect(await call('GET', `/rides/${ride.id}`, { token: s.accessToken }), 200);
  assert.equal(mine.routePolyline, quote.routePolyline);
  const theirs = expect(await call('GET', '/driver/rides/current', { token: d.accessToken }), 200);
  assert.equal(theirs.routePolyline, quote.routePolyline);
});
