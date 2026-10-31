// Builds src/components/hero/placesData.json: the campus places the hero map
// drives between and the rides that link them, routed on the streets already
// in mapData.json (campus) and regionData.json (out to Miotso Junction).
// Place positions are from OpenStreetMap (© OpenStreetMap contributors, ODbL).
//
//   node scripts/map/places.mjs
import { readFileSync, writeFileSync } from "node:fs";

const ORIGIN = [5.7688, 0.0838]; // Central University, Miotso (same frame as mapData.json)
const KX = 111320 * Math.cos((ORIGIN[0] * Math.PI) / 180);
const KZ = 110540;
const project = (lat, lon) => [(lon - ORIGIN[1]) * KX, -(lat - ORIGIN[0]) * KZ];

const MAX_TRIP = 18000; // metres: no ride is longer than 18 km
const ROAD_RADIUS = 6000; // only streets this close to campus are used for routing

/** Places on the map, in ride order (the loop returns to the first). */
const PLACES = [
  { id: "trinity-hall", name: "Trinity Hall", at: [5.77008, 0.08134] },
  { id: "cafeteria", name: "Cafeteria", at: [5.7685, 0.08384] },
  { id: "block-c", name: "Block C", at: [5.77079, 0.08195] },
  { id: "city-escape", name: "City Escape", at: [5.75894, 0.07655] },
  { id: "sunset", name: "Sunset", at: [5.75577, 0.08376] },
  { id: "miotso-junction", name: "Miotso Junction", at: [5.76647, 0.06189] },
];

const root = new URL("../../src/components/hero/", import.meta.url);
const map = JSON.parse(readFileSync(new URL("mapData.json", root), "utf8"));
const region = JSON.parse(readFileSync(new URL("regionData.json", root), "utf8"));

const near = (l) => {
  for (let i = 0; i < l.length; i += 2) if (Math.hypot(l[i], l[i + 1]) < ROAD_RADIUS) return true;
  return false;
};
const lines = [
  ...map.roads.map((r) => r.n.flatMap((n) => [map.nodes[2 * n], map.nodes[2 * n + 1]])),
  ...Object.values(region.roads).flat().filter(near),
];

// Street graph; points within 2 m are the same junction (the two exports round differently).
const key = (x, z) => `${Math.round(x / 2)},${Math.round(z / 2)}`;
const xy = new Map();
const adj = new Map();
for (const l of lines) {
  for (let i = 0; i < l.length; i += 2) {
    const k = key(l[i], l[i + 1]);
    xy.set(k, [l[i], l[i + 1]]);
    if (i === 0) continue;
    const a = key(l[i - 2], l[i - 1]);
    if (a === k) continue;
    const w = Math.hypot(l[i] - l[i - 2], l[i + 1] - l[i - 1]);
    for (const [u, v] of [[a, k], [k, a]]) {
      if (!adj.has(u)) adj.set(u, []);
      adj.get(u).push([v, w]);
    }
  }
}

const snap = ([x, z]) => {
  let best = null;
  let bestD = Infinity;
  for (const k of adj.keys()) {
    const [p, q] = xy.get(k);
    const d = Math.hypot(p - x, q - z);
    if (d < bestD) [best, bestD] = [k, d];
  }
  return best;
};

const shortest = (from, to) => {
  const dist = new Map([[from, 0]]);
  const prev = new Map();
  const open = [[0, from]];
  while (open.length) {
    open.sort((a, b) => a[0] - b[0]);
    const [d, u] = open.shift();
    if (u === to) break;
    if (d > dist.get(u)) continue;
    for (const [v, w] of adj.get(u) ?? []) {
      if (d + w < (dist.get(v) ?? Infinity)) {
        dist.set(v, d + w);
        prev.set(v, u);
        open.push([d + w, v]);
      }
    }
  }
  if (!dist.has(to)) throw new Error(`no road from ${from} to ${to}`);
  const path = [to];
  while (path[0] !== from) path.unshift(prev.get(path[0]));
  return path;
};

const r1 = (v) => Math.round(v * 10) / 10;
const stops = PLACES.map(({ id, name, at }) => {
  const [x, z] = project(...at);
  return { id, name, x: r1(x), z: r1(z), node: snap([x, z]) };
});

const rides = stops.map((a, i) => {
  const b = stops[(i + 1) % stops.length];
  const pts = [[a.x, a.z], ...shortest(a.node, b.node).map((k) => xy.get(k)), [b.x, b.z]];
  let len = 0;
  for (let j = 1; j < pts.length; j++) len += Math.hypot(pts[j][0] - pts[j - 1][0], pts[j][1] - pts[j - 1][1]);
  if (len > MAX_TRIP) throw new Error(`${a.id} -> ${b.id} is ${Math.round(len)} m, over ${MAX_TRIP}`);
  console.log(`${a.name} -> ${b.name}: ${(len / 1000).toFixed(1)} km`);
  return { from: a.id, to: b.id, p: pts.flat().map(r1) };
});

writeFileSync(
  new URL("placesData.json", root),
  JSON.stringify({ stops: stops.map(({ node, ...s }) => s), rides }),
);
