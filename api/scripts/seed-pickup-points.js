// Adds the campus pickup points in scripts/campus-points.json (matched by name, so it is safe to run again; an existing point is moved if its
// position or landmark changed, and a deleted one is not brought back). Refuses a point outside the service area. Dry run unless --yes.
//   node --env-file=/etc/turbo/api.env scripts/seed-pickup-points.js            show what it would do
//   node --env-file=/etc/turbo/api.env scripts/seed-pickup-points.js --yes      do it
//   ... --saved-for +233200000003 --yes    also give that student the "savedPlaces" from the file (skipped if they already have the label)
import fs from 'node:fs';
import { pool } from '../src/db.js';

const yes = process.argv.includes('--yes');
const savedFor = process.argv.includes('--saved-for') ? process.argv[process.argv.indexOf('--saved-for') + 1] : null;
const data = JSON.parse(fs.readFileSync(new URL('./campus-points.json', import.meta.url), 'utf8'));

// Ray casting on the GeoJSON ring: [lng, lat] pairs.
const inside = (ring, lat, lng) => { let r = false; for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
  const [xi, yi] = ring[i], [xj, yj] = ring[j];
  if (yi > lat !== yj > lat && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi) r = !r; } return r; };

try {
  const { rows: [area] } = await pool.query('SELECT polygon FROM service_area WHERE id=1');
  const ring = area?.polygon?.coordinates?.[0];
  for (const p of data.points) {
    if (ring && !inside(ring, p.lat, p.lng)) { console.error(`Skipping ${p.name}: outside the service area.`); continue; }
    const { rows: [have] } = await pool.query(`SELECT id, lat, lng, landmark, active FROM pickup_points WHERE lower(name)=lower($1) AND deleted_at IS NULL`, [p.name]);
    if (!have) {
      console.log(`${yes ? 'Adding' : 'Would add'} ${p.name}`);
      if (yes) await pool.query(`INSERT INTO pickup_points (name,landmark,lat,lng) VALUES ($1,$2,$3,$4)`, [p.name, p.landmark ?? null, p.lat, p.lng]);
    } else if (have.lat !== p.lat || have.lng !== p.lng || (have.landmark ?? null) !== (p.landmark ?? null)) {
      console.log(`${yes ? 'Updating' : 'Would update'} ${p.name}`);
      if (yes) await pool.query(`UPDATE pickup_points SET lat=$2, lng=$3, landmark=$4 WHERE id=$1`, [have.id, p.lat, p.lng, p.landmark ?? null]);
    } else console.log(`${p.name}: already there`);
  }
  if (savedFor) {
    const { rows: [u] } = await pool.query(`SELECT u.id FROM users u JOIN students s ON s.user_id=u.id WHERE u.phone=$1`, [savedFor]);
    if (!u) console.error('No student with that phone; saved places skipped.');
    else for (const s of data.savedPlaces ?? []) {
      const { rows: [pt] } = await pool.query(`SELECT id, name, landmark, lat, lng FROM pickup_points WHERE lower(name)=lower($1) AND deleted_at IS NULL`, [s.point]);
      if (!pt) { console.log(`Saved place ${s.label}: its point "${s.point}" is not in the database yet (run with --yes first).`); continue; }
      const { rows: [dup] } = await pool.query(`SELECT 1 FROM saved_places WHERE student_id=$1 AND lower(label)=lower($2) AND deleted_at IS NULL`, [u.id, s.label]);
      if (dup) { console.log(`Saved place ${s.label}: already there`); continue; }
      console.log(`${yes ? 'Adding' : 'Would add'} saved place ${s.label} -> ${pt.name}`);
      if (yes) await pool.query(`INSERT INTO saved_places (student_id,label,lat,lng,place_label,landmark,pickup_point_id) VALUES ($1,$2,$3,$4,$5,$6,$7)`, [u.id, s.label, pt.lat, pt.lng, pt.name, pt.landmark, pt.id]);
    }
  }
  if (!yes) console.log('Dry run. Add --yes to do it.');
} finally { await pool.end(); }
