// Tiny TTL cache so hot config reads (settings, fare bands, boundary) do not hit Postgres per request.
const store = new Map();
export async function cached(key, ttlMs, loader) {
  const hit = store.get(key);
  if (hit && hit.exp > Date.now()) return hit.val;
  const val = await loader();
  store.set(key, { val, exp: Date.now() + ttlMs });
  return val;
}
export const bust = (key) => (key ? store.delete(key) : store.clear());
