import { config } from '../config.js';
import { haversineM } from './util.js';
import { cached } from './cache.js';

// Route provider. Without a Google key we estimate: straight line x 1.3, 25 km/h. Demo only.
export async function route(p, d) {
  const key = [p.lat, p.lng, d.lat, d.lng].map((n) => n.toFixed(4)).join(',');
  return cached(`route:${key}`, 6 * 3600_000, async () => {
    if (!config.googleKey) {
      const m = Math.round(haversineM(p.lat, p.lng, d.lat, d.lng) * 1.3);
      return { distanceM: m, durationS: Math.round(m / (25000 / 3600)) };
    }
    const r = await fetch('https://routes.googleapis.com/directions/v2:computeRoutes', {
      method: 'POST',
      headers: { 'content-type': 'application/json', 'X-Goog-Api-Key': config.googleKey, 'X-Goog-FieldMask': 'routes.distanceMeters,routes.duration' },
      body: JSON.stringify({
        origin: { location: { latLng: { latitude: p.lat, longitude: p.lng } } },
        destination: { location: { latLng: { latitude: d.lat, longitude: d.lng } } },
        travelMode: 'DRIVE',
      }),
      signal: AbortSignal.timeout(4000),
    });
    if (!r.ok) return null;
    const j = await r.json();
    const rt = j.routes?.[0];
    return rt ? { distanceM: rt.distanceMeters, durationS: parseInt(rt.duration) } : null;
  });
}
