// Builds src/components/hero/regionData.json: the streets within 6 km of campus
// for the hero map (run scripts/map/places.mjs after it). Routing below uses the
// Turbo
// service area (Miotso, Dawhenya, Ashaiman) from an OpenStreetMap
// Overpass export (`out geom`), plus the app's pickup points and the rides
// the hero map loops through, routed on real roads between them.
// Map data © OpenStreetMap contributors, ODbL: credit is shown in the hero.
//
//   node scripts/map/region.mjs path/to/region.json [--pairs]
import { readFileSync, writeFileSync } from "node:fs";

const ORIGIN = [5.7688, 0.0838]; // Central University, Miotso (same frame as mapData.json)
const KX = 111320 * Math.cos((ORIGIN[0] * Math.PI) / 180);
const KZ = 110540;
const project = (lat, lon) => [(lon - ORIGIN[1]) * KX, -(lat - ORIGIN[0]) * KZ];

const MAX_TRIP = 18000; // metres: no ride, and no stop from campus, is farther than 18 km

/** Pickup points in the app (public/mock-api/service-area). */
const STOPS = [
  { id: "cu-hostels", name: "CU Hostels", at: [5.7675, 0.0863] },
  { id: "cu-main-gate", name: "CU Main Gate", at: [5.77604, 0.08321] },
  { id: "miotso-junction", name: "Miotso Junction", at: [5.76647, 0.06189] },
  { id: "dawhenya", name: "Dawhenya", at: [5.76478, 0.05632] },
  { id: "ashaiman-china-mall", name: "Ashaiman China Mall", at: [5.68437, -0.024] },
];

/**
 * The loop of rides shown after the intro, each one leg between two stops and
 * under MAX_TRIP by road.
 */
const RIDES = [
  ["cu-hostels", "dawhenya"],
  ["dawhenya", "ashaiman-china-mall"],
  ["ashaiman-china-mall", "miotso-junction"],
  ["miotso-junction", "cu-main-gate"],
  ["cu-main-gate", "cu-hostels"],
];

const CLASS = {
  motorway: "major", trunk: "major", primary: "major", secondary: "major", tertiary: "major",
  motorway_link: "major", trunk_link: "major", primary_link: "major", secondary_link: "major", tertiary_link: "major",
  unclassified: "minor", residential: "minor", service: "service",
};

const { elements } = JSON.parse(readFileSync(process.argv[2], "utf8"));
const xy = new Map(); // OSM node id -> [x, z]
const adj = new Map();
const ways = [];
const water = [];
for (const el of elements) {
  if (el.type !== "way" || !el.geometry) continue;
  const t = el.tags ?? {};
  const k = CLASS[t.highway];
  if (!k) {
    if (el.nodes[0] === el.nodes[el.nodes.length - 1]) water.push(el.geometry.slice(0, -1).map((g) => project(g.lat, g.lon)));
    continue;
  }
  el.nodes.forEach((id, i) => xy.set(id, project(el.geometry[i].lat, el.geometry[i].lon)));
  ways.push({ k, ids: el.nodes });
  for (let i = 1; i < el.nodes.length; i++) {
    const [a, b] = [el.nodes[i - 1], el.nodes[i]];
    const w = Math.hypot(xy.get(a)[0] - xy.get(b)[0], xy.get(a)[1] - xy.get(b)[1]);
    for (const [u, v] of [[a, b], [b, a]]) {
      if (!adj.has(u)) adj.set(u, []);
      adj.get(u).push([v, w]);
    }
  }
}

const nearest = ([x, z]) => {
  let best = null;
  let bd = Infinity;
  for (const id of adj.keys()) {
    const [nx, nz] = xy.get(id);
    const d = (nx - x) ** 2 + (nz - z) ** 2;
    if (d < bd) [best, bd] = [id, d];
  }
  return best;
};

/** Dijkstra with a binary heap. */
function shortest(from, to) {
  const dist = new Map([[from, 0]]);
  const prev = new Map();
  const heap = [[0, from]];
  const push = (e) => {
    heap.push(e);
    for (let i = heap.length - 1; i > 0; ) {
      const p = (i - 1) >> 1;
      if (heap[p][0] <= heap[i][0]) break;
      [heap[p], heap[i]] = [heap[i], heap[p]];
      i = p;
    }
  };
  const pop = () => {
    const top = heap[0];
    const end = heap.pop();
    if (heap.length) {
      heap[0] = end;
      for (let i = 0; ; ) {
        const [l, r] = [2 * i + 1, 2 * i + 2];
        let m = i;
        if (l < heap.length && heap[l][0] < heap[m][0]) m = l;
        if (r < heap.length && heap[r][0] < heap[m][0]) m = r;
        if (m === i) break;
        [heap[m], heap[i]] = [heap[i], heap[m]];
        i = m;
      }
    }
    return top;
  };
  while (heap.length) {
    const [d, u] = pop();
    if (u === to) break;
    if (d > dist.get(u)) continue;
    for (const [v, w] of adj.get(u) ?? []) {
      const nd = d + w;
      if (nd < (dist.get(v) ?? Infinity)) {
        dist.set(v, nd);
        prev.set(v, u);
        push([nd, v]);
      }
    }
  }
  if (!dist.has(to)) return null;
  const path = [to];
  while (path[0] !== from) path.unshift(prev.get(path[0]));
  return { path, length: dist.get(to) };
}

/** Douglas–Peucker on [x, z] points. */
function simplify(pts, tol) {
  if (pts.length < 3) return pts;
  const keep = new Uint8Array(pts.length);
  keep[0] = keep[pts.length - 1] = 1;
  const stack = [[0, pts.length - 1]];
  while (stack.length) {
    const [a, b] = stack.pop();
    const [ax, az] = pts[a];
    const [bx, bz] = pts[b];
    const len = Math.hypot(bx - ax, bz - az) || 1;
    let far = -1;
    let fd = tol;
    for (let i = a + 1; i < b; i++) {
      const d = Math.abs((bx - ax) * (az - pts[i][1]) - (ax - pts[i][0]) * (bz - az)) / len;
      if (d > fd) [far, fd] = [i, d];
    }
    if (far > 0) {
      keep[far] = 1;
      stack.push([a, far], [far, b]);
    }
  }
  return pts.filter((_, i) => keep[i]);
}
const flat = (pts) => pts.flatMap(([x, z]) => [Math.round(x), Math.round(z)]);

const stops = STOPS.map((s) => {
  const node = nearest(project(...s.at));
  const [x, z] = xy.get(node);
  return { ...s, node, x: Math.round(x), z: Math.round(z) };
});
const byId = Object.fromEntries(stops.map((s) => [s.id, s]));

if (process.argv.includes("--pairs")) {
  for (const a of stops) for (const b of stops) if (a.id < b.id) console.log(`${a.name} ↔ ${b.name}: ${(shortest(a.node, b.node).length / 1000).toFixed(1)} km`);
  process.exit(0);
}

const rides = RIDES.map(([from, to]) => {
  const r = shortest(byId[from].node, byId[to].node);
  if (!r) throw new Error(`no route ${from} -> ${to}`);
  if (r.length > MAX_TRIP) throw new Error(`${from} -> ${to} is ${Math.round(r.length)} m, over ${MAX_TRIP} m`);
  console.log(`${byId[from].name} → ${byId[to].name}: ${(r.length / 1000).toFixed(1)} km`);
  return { from, to, p: flat(simplify(r.path.map((id) => xy.get(id)), 1)) };
});

// Streets near the rides keep full detail; farther out only the main roads and
// minor roads at a coarser tolerance, to keep the file small.
const along = rides.flatMap((r) => {
  const out = [];
  for (let i = 0; i < r.p.length; i += 2) out.push([r.p[i], r.p[i + 1]]);
  return out;
});
const CELL = 400;
const nearRide = new Set();
for (const [x, z] of along) {
  for (let dx = -3; dx <= 3; dx++) for (let dz = -3; dz <= 3; dz++) nearRide.add(`${Math.floor(x / CELL) + dx},${Math.floor(z / CELL) + dz}`);
}
const isNear = ([x, z]) => nearRide.has(`${Math.floor(x / CELL)},${Math.floor(z / CELL)}`);

const roads = { major: [], minor: [], service: [] };
for (const { k, ids } of ways) {
  const pts = ids.map((id) => xy.get(id));
  if (k !== "major" && !pts.some(isNear)) continue;
  roads[k].push(flat(simplify(pts, k === "major" ? 1.5 : 3)));
}

// The hero only draws streets within 6 km of campus (its places come from places.mjs).
const ROAD_RADIUS = 6000;
const nearCampus = (l) => {
  for (let i = 0; i < l.length; i += 2) if (Math.hypot(l[i], l[i + 1]) < ROAD_RADIUS) return true;
  return false;
};
for (const k of Object.keys(roads)) roads[k] = roads[k].filter(nearCampus);
const out = { roads };
writeFileSync(new URL("../../src/components/hero/regionData.json", import.meta.url), JSON.stringify(out));
const size = JSON.stringify(out).length;
console.log(`roads major ${roads.major.length}, minor ${roads.minor.length}, service ${roads.service.length}, ${(size / 1024).toFixed(0)} KB`);
