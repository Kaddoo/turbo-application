import { q } from '../db.js';
import { getSettings, getFareBands, getArea } from '../lib/settings.js';
import { spec } from '../lib/contract.js';
import { point } from '../views.js';

// The same document the public GET /service-area returns; staff PUT /admin/service-area returns it too.
export async function serviceAreaView() {
  const [a, s, bands, pts] = await Promise.all([getArea(), getSettings(), getFareBands(),
    q('SELECT id,name,lat,lng,active FROM pickup_points WHERE deleted_at IS NULL ORDER BY name')]);
  return {
    version: a.version, boundary: a.polygon ?? null,
    pickupPoints: pts.rows.map((p) => ({ id: p.id, name: p.name, point: point(p.lat, p.lng), isActive: p.active })),
    maxTripDistanceMeters: s.maxTripDistanceMeters,
    fareBands: bands.map((b) => ({ upToMeters: b.upto_meters, farePesewas: b.fare_pesewas })),
    ...(s.operatingHours && { operatingHours: s.operatingHours }),
  };
}

// Internal-only settings (like how long we keep identity photos) are not part of the contract's Settings document.
const PUBLIC_KEYS = Object.keys(spec.components.schemas.Settings.properties);
export const publicSettings = (s) => Object.fromEntries(PUBLIC_KEYS.filter((k) => s[k] !== undefined).map((k) => [k, s[k]]));
