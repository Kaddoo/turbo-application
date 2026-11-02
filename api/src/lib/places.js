import { q } from '../db.js';
import { config } from '../config.js';
import { getArea } from './settings.js';
import { inPolygon, isUuid } from './util.js';
import { location } from '../views.js';

// Place search for the drop-off screen. Official pickup points come first (they are ours, free, and always inside the area); the map
// provider's places follow when a key is set and Places is allowed for it. If the provider refuses or is slow, the answer is the pickup
// points alone: search never fails because of Google. Ids: "pp_<uuid>" for a pickup point, "g_<provider id>" for a provider place.
const LOG = { warned: false };
const warnOnce = (msg) => { if (!LOG.warned) { LOG.warned = true; console.warn(`places: ${msg}`); } };

function bounds(polygon) {
  const ring = polygon?.coordinates?.[0];
  if (!ring?.length) return null;
  const lngs = ring.map((p) => p[0]), lats = ring.map((p) => p[1]);
  return { low: { latitude: Math.min(...lats), longitude: Math.min(...lngs) }, high: { latitude: Math.max(...lats), longitude: Math.max(...lngs) } };
}

export async function autocomplete(text, sessionToken) {
  const term = String(text ?? '').trim();
  if (term.length < 2) return [];
  const like = `%${term.replace(/[%_\\]/g, '\\$&')}%`;
  const { rows } = await q(`SELECT id, name, landmark FROM pickup_points WHERE deleted_at IS NULL AND active AND (name ILIKE $1 OR landmark ILIKE $1) ORDER BY name LIMIT 5`, [like]);
  const items = rows.map((p) => ({ placeId: `pp_${p.id}`, label: p.name, landmark: p.landmark ?? null, isPickupPoint: true }));
  if (!config.googleKey) return items;
  try {
    const area = await getArea();
    const rect = bounds(area.polygon);
    const r = await fetch('https://places.googleapis.com/v1/places:autocomplete', {
      method: 'POST',
      headers: { 'content-type': 'application/json', 'X-Goog-Api-Key': config.googleKey },
      body: JSON.stringify({ input: term, includedRegionCodes: ['gh'], ...(sessionToken && { sessionToken }), ...(rect && { locationRestriction: { rectangle: rect } }) }),
      signal: AbortSignal.timeout(3000),
    });
    if (!r.ok) { warnOnce(`autocomplete answered ${r.status}`); return items; }
    for (const s of (await r.json()).suggestions ?? []) {
      const p = s.placePrediction;
      if (!p?.placeId || items.length >= 10) continue;
      items.push({ placeId: `g_${p.placeId}`, label: String(p.structuredFormat?.mainText?.text ?? p.text?.text ?? '').slice(0, 120),
        landmark: p.structuredFormat?.secondaryText?.text?.slice(0, 120) ?? null, isPickupPoint: false });
    }
  } catch (e) { warnOnce(`autocomplete failed: ${e.message}`); }
  return items.filter((i) => i.label);
}

// The Location for a chosen suggestion, or null when unknown or outside the service area.
export async function resolve(placeId, sessionToken) {
  if (placeId.startsWith('pp_')) {
    const id = placeId.slice(3);
    if (!isUuid(id)) return null;
    const { rows: [p] } = await q(`SELECT id, name, landmark, lat, lng FROM pickup_points WHERE id=$1 AND deleted_at IS NULL AND active`, [id]);
    return p ? location(p.lat, p.lng, p.name, { pickupPointId: p.id, ...(p.landmark && { landmark: p.landmark.slice(0, 120) }) }) : null;
  }
  if (!placeId.startsWith('g_') || !config.googleKey || !/^[A-Za-z0-9_-]{10,200}$/.test(placeId.slice(2))) return null;
  try {
    const url = `https://places.googleapis.com/v1/places/${placeId.slice(2)}${sessionToken ? `?sessionToken=${encodeURIComponent(sessionToken)}` : ''}`;
    const r = await fetch(url, { headers: { 'X-Goog-Api-Key': config.googleKey, 'X-Goog-FieldMask': 'displayName,location,formattedAddress' }, signal: AbortSignal.timeout(3000) });
    if (!r.ok) return null;
    const p = await r.json();
    const { latitude: lat, longitude: lng } = p.location ?? {};
    if (typeof lat !== 'number' || typeof lng !== 'number') return null;
    const area = await getArea();
    if (!area.polygon || !inPolygon(lat, lng, area.polygon)) return null;
    return location(lat, lng, String(p.displayName?.text ?? p.formattedAddress ?? '').slice(0, 120) || undefined, p.formattedAddress ? { landmark: p.formattedAddress.slice(0, 120) } : {});
  } catch { return null; }
}
