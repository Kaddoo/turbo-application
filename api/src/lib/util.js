import crypto from 'node:crypto';
import { bad } from './errors.js';

export const sha256 = (s) => crypto.createHash('sha256').update(s).digest('hex');
export const randomToken = (n = 32) => crypto.randomBytes(n).toString('base64url');
export const randomPin = () => String(crypto.randomInt(0, 10000)).padStart(4, '0');

export function haversineM(lat1, lng1, lat2, lng2) {
  const R = 6371000, r = Math.PI / 180;
  const dLat = (lat2 - lat1) * r, dLng = (lng2 - lng1) * r;
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(lat1 * r) * Math.cos(lat2 * r) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(a));
}

// GeoJSON polygon, outer ring only. Ray casting. ring = [[lng,lat],...]
// Google encoded polyline (precision 5) of [lat, lng] pairs.
export function encodePolyline(points) {
  let out = '', pl = 0, pg = 0;
  const put = (v) => {
    let n = v < 0 ? ~(v << 1) : v << 1;
    while (n >= 0x20) { out += String.fromCharCode((0x20 | (n & 0x1f)) + 63); n >>= 5; }
    out += String.fromCharCode(n + 63);
  };
  for (const [lat, lng] of points) {
    const la = Math.round(lat * 1e5), lo = Math.round(lng * 1e5);
    put(la - pl); put(lo - pg); pl = la; pg = lo;
  }
  return out;
}

export function inPolygon(lat, lng, polygon) {
  const ring = polygon?.coordinates?.[0];
  if (!ring) return false;
  let inside = false;
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const [xi, yi] = ring[i], [xj, yj] = ring[j];
    if ((yi > lat) !== (yj > lat) && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi) inside = !inside;
  }
  return inside;
}

// "140" / "140.5" / 140.5 -> pesewas using integer maths only (no float rounding).
export function cedisToPesewas(v) {
  const m = /^(\d+)(?:\.(\d{1,2}))?$/.exec(String(v).trim());
  if (!m) throw bad('Invalid amount');
  return Number(m[1]) * 100 + Number((m[2] || '').padEnd(2, '0') || 0);
}

export function normalizePhone(p) {
  const s = String(p || '').replace(/[\s-]/g, '');
  if (/^\+233\d{9}$/.test(s)) return s;
  if (/^0\d{9}$/.test(s)) return '+233' + s.slice(1);
  return null;
}

// ---- tiny validators (keeps deps small; the contract remains the source of truth)
export const isUuid = (v) => typeof v === 'string' && /^[0-9a-f-]{36}$/i.test(v);
export const num = (v) => typeof v === 'number' && Number.isFinite(v);
export function point(v, name) {
  if (!v || !num(v.lat) || !num(v.lng) || v.lat < -90 || v.lat > 90 || v.lng < -180 || v.lng > 180)
    throw bad(`${name} must be {lat, lng}`, [{ field: name, message: 'lat/lng required' }]);
  return { lat: v.lat, lng: v.lng, label: typeof v.label === 'string' ? v.label.slice(0, 120) : null };
}
export const pageLimit = (v) => Math.min(Math.max(parseInt(v) || 20, 1), 100);
