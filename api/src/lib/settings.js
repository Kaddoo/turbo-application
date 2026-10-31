import { q } from '../db.js';
import { cached, bust } from './cache.js';

export const DEFAULTS = {
  maxTripDistanceMeters: 18000, quoteTtlSeconds: 300, driverAckTimeoutSeconds: 45, noDriverTimeoutSeconds: 300,
  minTopupPesewas: 500, maxTopupPesewas: 50000, driverSilenceSeconds: 180, noShowWaitSeconds: 300,
  quoteLimitPerMinute: 10, adjustmentApprovalThresholdPesewas: 5000, presenceFreshSeconds: 60,
  bookingsPaused: false, pauseMessage: null, documentRetentionDays: 30, locationRetentionDays: 90, smsDailyLimit: 20000, operatingHours: null,
};

export const getSettings = () => cached('settings', 10_000, async () => {
  const { rows } = await q('SELECT key, value FROM settings');
  return { ...DEFAULTS, ...Object.fromEntries(rows.map((r) => [r.key, r.value])) };
});
export const getFareBands = () => cached('bands', 10_000, async () =>
  (await q('SELECT upto_meters, fare_pesewas FROM fare_bands ORDER BY upto_meters')).rows);
export const getArea = () => cached('area', 10_000, async () =>
  (await q('SELECT polygon, version FROM service_area WHERE id = 1')).rows[0] || { polygon: null, version: 0 });
export const bustConfig = () => bust();

// Inclusive on the upper side: exactly 3000 m is the first band.
export function fareFor(bands, meters) {
  const b = bands.find((x) => meters <= x.upto_meters);
  return b ? b.fare_pesewas : null;
}
