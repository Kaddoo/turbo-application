/**
 * Read-only access to the Turbo API (no tokens). Every call can fail; callers
 * get `null` and must render a fallback. Requests are memoised so sections
 * that need the same endpoint share one request.
 */

export type FareBand = {
  /** Upper bound of the band, inclusive, in metres. */
  maxDistanceMeters: number;
  /** Price in pesewas (GH₵1 = 100 pesewas). */
  fareMinor: number;
};

export type PickupPoint = { id: string; name: string };

export type ServiceArea = {
  fareBands: FareBand[];
  maxTripDistanceMeters: number | null;
  pickupPoints: PickupPoint[];
  operatingHours: string | null;
};

export type LegalDoc = { url: string | null; version: string | null; updatedAt: string | null };
export type Legal = { terms: LegalDoc; privacy: LegalDoc };

export type AppConfig = { maintenance: boolean; maintenanceMessage: string | null };

const BASE = (process.env.PUBLIC_API_BASE_URL || "").replace(/\/$/, "");
const TIMEOUT_MS = 6000;
const cache = new Map<string, Promise<unknown | null>>();

function getJson(path: string): Promise<unknown | null> {
  if (!BASE || typeof window === "undefined") return Promise.resolve(null);
  let p = cache.get(path);
  if (!p) {
    const ctrl = new AbortController();
    const timer = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
    p = fetch(`${BASE}${path}`, { signal: ctrl.signal, headers: { Accept: "application/json" } })
      .then((r) => (r.ok ? r.json() : null))
      .catch(() => null)
      .finally(() => clearTimeout(timer));
    cache.set(path, p);
  }
  return p;
}

const num = (v: unknown): number | null =>
  typeof v === "number" && Number.isFinite(v) ? v : typeof v === "string" && v.trim() !== "" && Number.isFinite(+v) ? +v : null;
const str = (v: unknown): string | null => (typeof v === "string" && v.trim() ? v : null);
const obj = (v: unknown): Record<string, unknown> => (v && typeof v === "object" ? (v as Record<string, unknown>) : {});

function parseBand(raw: unknown): FareBand | null {
  const b = obj(raw);
  const max = num(b.maxDistanceMeters) ?? num(b.upToMeters) ?? num(b.maxMeters);
  const minor = num(b.fareMinor) ?? num(b.amountMinor) ?? num(b.pesewas);
  const major = num(b.fare) ?? num(b.price) ?? num(b.amount);
  const fare = minor ?? (major != null ? Math.round(major * 100) : null);
  return max != null && fare != null && max > 0 && fare >= 0 ? { maxDistanceMeters: max, fareMinor: fare } : null;
}

export async function getServiceArea(): Promise<ServiceArea | null> {
  const raw = await getJson("/service-area");
  if (!raw) return null;
  const d = obj(raw);
  const fareBands = (Array.isArray(d.fareBands) ? d.fareBands : [])
    .map(parseBand)
    .filter((b): b is FareBand => b !== null)
    .sort((a, b) => a.maxDistanceMeters - b.maxDistanceMeters);
  const pickupPoints = (Array.isArray(d.pickupPoints) ? d.pickupPoints : [])
    .map((p, i): PickupPoint | null => {
      if (typeof p === "string") return { id: String(i), name: p };
      const o = obj(p);
      const name = str(o.name) ?? str(o.label);
      return name ? { id: str(o.id) ?? String(i), name } : null;
    })
    .filter((p): p is PickupPoint => p !== null);
  const hours = d.operatingHours;
  const operatingHours =
    str(hours) ??
    (obj(hours).open && obj(hours).close ? `${obj(hours).open}–${obj(hours).close}` : null);
  return {
    fareBands,
    maxTripDistanceMeters: num(d.maxTripDistanceMeters),
    pickupPoints,
    operatingHours,
  };
}

function parseDoc(raw: unknown): LegalDoc {
  const o = obj(raw);
  return { url: str(o.url), version: str(o.version), updatedAt: str(o.updatedAt) ?? str(o.updated_at) };
}

export async function getLegal(): Promise<Legal | null> {
  const raw = await getJson("/legal");
  if (!raw) return null;
  const d = obj(raw);
  return { terms: parseDoc(d.terms), privacy: parseDoc(d.privacy) };
}

export async function getAppConfig(): Promise<AppConfig | null> {
  const raw = await getJson("/app-config");
  if (!raw) return null;
  const d = obj(raw);
  const m = obj(d.maintenance);
  const maintenance = d.maintenance === true || m.active === true || m.enabled === true;
  return { maintenance, maintenanceMessage: str(m.message) ?? str(d.maintenanceMessage) };
}

export const formatCedis = (minor: number) =>
  `GH₵${(minor / 100).toLocaleString("en-GH", { minimumFractionDigits: minor % 100 ? 2 : 0, maximumFractionDigits: 2 })}`;

export const formatKm = (m: number) => `${(m / 1000).toLocaleString("en-GH", { maximumFractionDigits: 1 })} km`;
