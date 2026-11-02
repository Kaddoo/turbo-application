// Builds src/components/hero/mapData.json from an OpenStreetMap Overpass export
// (`out geom`) of the streets, buildings and land use around the Miotso campus.
// Map data © OpenStreetMap contributors, ODbL: credit is shown in the hero.
//
//   node scripts/map/campus.mjs path/to/campus.json [startX,startZ,endX,endZ]
import { readFileSync, writeFileSync } from "node:fs";

const ORIGIN = [5.7688, 0.0838]; // Central University, Miotso
const KX = 111320 * Math.cos((ORIGIN[0] * Math.PI) / 180);
const KZ = 110540;
const EXTENT = 1900; // metres from the origin kept in each direction
/** Metres east (x) and south (z) of the origin, to 0.1 m. */
const project = ({ lat, lon }) => [Math.round((lon - ORIGIN[1]) * KX * 10) / 10, Math.round(-(lat - ORIGIN[0]) * KZ * 10) / 10];

const ROADS = { trunk: "major", primary: "major", secondary: "major", tertiary: "major", unclassified: "minor", residential: "minor", service: "service", track: "service" };
const AREAS = { university: "campus", pitch: "pitch", water: "water", farmland: "field", grass: "field", meadow: "field", commercial: "commercial" };

const { elements } = JSON.parse(readFileSync(process.argv[2], "utf8"));
const nodeIndex = new Map();
const nodes = [];
const roads = [];
const buildings = [];
const areas = [];
const labels = [];

for (const el of elements) {
  if (el.type !== "way" || !el.geometry) continue;
  const t = el.tags ?? {};
  const kind = ROADS[t.highway];
  if (kind) {
    // Ways run past the export box; keep only the stretches inside it.
    let run = [];
    const flush = () => {
      if (run.length > 1) {
        roads.push({ k: kind, n: run });
        if (t.name && kind === "major") labels.push({ text: t.name, n: run });
      }
      run = [];
    };
    el.nodes.forEach((id, i) => {
      const p = project(el.geometry[i]);
      if (Math.abs(p[0]) > EXTENT || Math.abs(p[1]) > EXTENT) return flush();
      if (!nodeIndex.has(id)) {
        nodeIndex.set(id, nodes.length / 2);
        nodes.push(...p);
      }
      run.push(nodeIndex.get(id));
    });
    flush();
    continue;
  }
  const closed = el.nodes[0] === el.nodes[el.nodes.length - 1];
  if (!closed) continue;
  const ring = el.geometry.slice(0, -1).flatMap(project);
  if (t.building) {
    const levels = parseFloat(t["building:levels"]);
    buildings.push(Number.isFinite(levels) ? { p: ring, l: levels } : { p: ring });
    continue;
  }
  const area = AREAS[t.amenity] ?? AREAS[t.leisure] ?? AREAS[t.natural] ?? AREAS[t.landuse];
  if (area) areas.push({ k: area, p: ring, ...(t.name ? { name: t.name } : {}) });
}

// Keep the longest stretch of each named major road for a single label.
const named = new Map();
for (const l of labels) if (!named.has(l.text) || named.get(l.text).n.length < l.n.length) named.set(l.text, l);

// Showcase trip shared by the phone map and the first 3D ride: shortest path on
// the street graph between two points either side of campus.
const adj = new Map();
const dist = (a, b) => Math.hypot(nodes[2 * a] - nodes[2 * b], nodes[2 * a + 1] - nodes[2 * b + 1]);
for (const { k, n } of roads) {
  for (let i = 1; i < n.length; i++) {
    for (const [a, b] of [[n[i - 1], n[i]], [n[i], n[i - 1]]]) {
      if (!adj.has(a)) adj.set(a, []);
      adj.get(a).push([b, dist(a, b)]);
    }
  }
}
const nearest = (x, z) => {
  let best = -1;
  let bd = Infinity;
  for (const i of adj.keys()) {
    const d = Math.hypot(nodes[2 * i] - x, nodes[2 * i + 1] - z);
    if (d < bd) [best, bd] = [i, d];
  }
  return best;
};
function shortestPath(from, to) {
  const d = new Map([[from, 0]]);
  const prev = new Map();
  const open = new Set([from]);
  while (open.size) {
    let u = -1;
    for (const v of open) if (u < 0 || d.get(v) < d.get(u)) u = v;
    open.delete(u);
    if (u === to) break;
    for (const [v, w] of adj.get(u) ?? []) {
      const nd = d.get(u) + w;
      if (nd < (d.get(v) ?? Infinity)) {
        d.set(v, nd);
        prev.set(v, u);
        open.add(v);
      }
    }
  }
  const path = [to];
  while (path[0] !== from) {
    if (!prev.has(path[0])) return null;
    path.unshift(prev.get(path[0]));
  }
  return { path, length: d.get(to) };
}
const [sx, sz, ex, ez] = (process.argv[3] ?? "-560,620,-60,-120").split(",").map(Number);
const tour = shortestPath(nearest(sx, sz), nearest(ex, ez));
if (!tour) throw new Error("no route between the tour points");
console.log(`tour ${tour.path.length} nodes, ${Math.round(tour.length)} m`);

const out = { origin: ORIGIN, nodes, roads, buildings, areas, labels: [...named.values()], tour: tour.path };
writeFileSync(new URL("../../src/components/hero/mapData.json", import.meta.url), JSON.stringify(out));
console.log(`nodes ${nodes.length / 2}, roads ${roads.length}, buildings ${buildings.length}, areas ${areas.length}`);
