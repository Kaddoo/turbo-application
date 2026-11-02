// Builds src/components/sections/dotMap.json: the real road network between the
// Miotso campus and Ashaiman China Mall, rasterised to a dot grid for the
// Download card. Map data © OpenStreetMap contributors, ODbL.
//
//   node scripts/map/corridor.mjs path/to/corridor.json
import { readFileSync, writeFileSync } from "node:fs";

const W = 560;
const H = 300;
const STEP = 6; // grid pitch in viewBox units
const CENTRE = [5.7266, 0.0299]; // midway between the two pins
const M_PER_UNIT = 46;
const KX = 111320 * Math.cos((CENTRE[0] * Math.PI) / 180);
const KY = 110540;
const toXY = (lat, lon) => [W / 2 + ((lon - CENTRE[1]) * KX) / M_PER_UNIT, H / 2 - ((lat - CENTRE[0]) * KY) / M_PER_UNIT];

const MAJOR = new Set(["motorway", "trunk", "primary", "secondary", "motorway_link", "trunk_link", "primary_link"]);
const cols = Math.floor(W / STEP);
const rows = Math.floor(H / STEP);
const hits = new Float32Array(cols * rows);
const major = new Uint8Array(cols * rows);

const { elements } = JSON.parse(readFileSync(process.argv[2], "utf8"));
for (const el of elements) {
  if (!el.geometry) continue;
  const isMajor = MAJOR.has(el.tags?.highway);
  for (let i = 1; i < el.geometry.length; i++) {
    const [x0, y0] = toXY(el.geometry[i - 1].lat, el.geometry[i - 1].lon);
    const [x1, y1] = toXY(el.geometry[i].lat, el.geometry[i].lon);
    const n = Math.max(1, Math.ceil(Math.hypot(x1 - x0, y1 - y0) / (STEP / 3)));
    for (let s = 0; s <= n; s++) {
      const c = Math.floor((x0 + ((x1 - x0) * s) / n) / STEP);
      const r = Math.floor((y0 + ((y1 - y0) * s) / n) / STEP);
      if (c < 0 || r < 0 || c >= cols || r >= rows) continue;
      hits[r * cols + c] += 1;
      if (isMajor) major[r * cols + c] = 1;
    }
  }
}

const round = (v) => Math.round(v * 10) / 10;
let minor = "";
let main = "";
for (let r = 0; r < rows; r++)
  for (let c = 0; c < cols; c++) {
    const i = r * cols + c;
    if (!hits[i]) continue;
    const d = `M${round(c * STEP + STEP / 2)} ${round(r * STEP + STEP / 2)}h0`;
    if (major[i]) main += d;
    else if (hits[i] >= 3) minor += d;
  }

const pin = (lat, lon) => toXY(lat, lon).map(round);
const out = { w: W, h: H, minor, major: main, from: pin(5.7688, 0.0838), to: pin(5.6844, -0.024) };
writeFileSync(new URL("../../src/components/sections/dotMap.json", import.meta.url), JSON.stringify(out));
console.log(`dots minor ${minor.split("M").length - 1}, major ${main.split("M").length - 1}, from ${out.from}, to ${out.to}`);
