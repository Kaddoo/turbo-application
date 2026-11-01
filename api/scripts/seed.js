// Demo data: boundary around Miotso <-> Ashaiman (DEMO polygon, not Turbo-approved), fare bands, staff, drivers, students.
import pg from 'pg';
import { config } from '../src/config.js';
import { hashPassword } from '../src/lib/auth.js';

if (config.env === 'production') { console.error('Refusing to seed demo data (known passwords, demo boundary) in production'); process.exit(1); }
// The demo staff have a published password. They are for a laptop only, never for a host that anyone can reach: staging and production
// use invited staff and scripts/seed-test-data.js. A public PUBLIC_URL (anything but localhost) is refused.
if (!/^https?:\/\/(localhost|127\.0\.0\.1)(:|\/|$)/.test(config.publicUrl)) { console.error(`Refusing to seed demo staff on ${config.publicUrl}: they have a known password. Use scripts/seed-test-data.js on shared hosts.`); process.exit(1); }
const c = new pg.Client({ connectionString: config.databaseUrl });
await c.connect();
await c.query(`INSERT INTO service_area (id,polygon,version) VALUES (1,$1,1) ON CONFLICT (id) DO UPDATE SET polygon=$1`,
  [JSON.stringify({ type: 'Polygon', coordinates: [[[-0.08, 5.64], [0.13, 5.64], [0.13, 5.78], [-0.08, 5.78], [-0.08, 5.64]]] })]);
await c.query(`INSERT INTO fare_bands VALUES (3000,1800),(6000,2500),(12000,3500),(18000,5000) ON CONFLICT DO NOTHING`);
await c.query(`INSERT INTO pickup_points (name,landmark,lat,lng) SELECT 'Central Gate','Main gate, Miotso',5.7203,0.0757 WHERE NOT EXISTS (SELECT 1 FROM pickup_points)`);
const staff = [['admin@turbo.test', 'super_admin'], ['finance@turbo.test', 'finance'], ['finance2@turbo.test', 'finance'], ['verifier@turbo.test', 'verifier'], ['dispatch@turbo.test', 'dispatcher'], ['hr@turbo.test', 'hr'], ['support@turbo.test', 'support']];
for (const [email, role] of staff)
  await c.query(`INSERT INTO staff_users (email,password_hash,name,role) VALUES ($1,$2,$3,$4) ON CONFLICT DO NOTHING`, [email, await hashPassword('Turbo-demo-1'), role, role]);
const drivers = [['+233200000001', 'Kofi Mensah', 'GR-0001-26'], ['+233200000002', 'Ama Boateng', 'GR-0002-26'], ['+233200000003', 'Yaw Owusu', 'GR-0003-26']];
for (const [phone, name, plate] of drivers) {
  const [first, ...rest] = name.split(' ');
  const { rows: [u] } = await c.query(`INSERT INTO users (role,phone,first_name,last_name,full_name) VALUES ('driver',$1,$2,$3,$4)
     ON CONFLICT (phone) DO UPDATE SET first_name=$2, last_name=$3, full_name=$4 RETURNING id`, [phone, first, rest.join(' '), name]);
  await c.query(`INSERT INTO vehicles (make,model,colour,plate_number) VALUES ('Toyota','Corolla','White',$1) ON CONFLICT DO NOTHING`, [plate]);
  const { rows: [v] } = await c.query(`SELECT id FROM vehicles WHERE upper(plate_number)=upper($1) AND deleted_at IS NULL`, [plate]);
  await c.query(`INSERT INTO drivers (user_id,vehicle_id) VALUES ($1,$2) ON CONFLICT (user_id) DO UPDATE SET vehicle_id=COALESCE(drivers.vehicle_id,$2)`, [u.id, v.id]);
  // the contract stores the terms the user accepted; demo drivers have accepted the current ones
  await c.query(`UPDATE users SET terms_version='1.0', privacy_version='1.0', terms_accepted_at=now() WHERE id=$1`, [u.id]);
}
await c.end();
console.log('seeded: staff (admin, finance, finance2, verifier, dispatch, hr, support @turbo.test) password Turbo-demo-1; drivers +233200000001..3 (OTP 123456 in fixed mode)');
