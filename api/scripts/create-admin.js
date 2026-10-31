// Bootstrap the first super admin. No password is typed or stored by this script: it prints a one-time invite link
// (valid 72 h) where the person sets their own password and scans the MFA QR code.
//   npm run create-admin -- you@turbo.com super_admin "Your Name"
import pg from 'pg';
import crypto from 'node:crypto';
import { config } from '../src/config.js';
import { hashPassword } from '../src/lib/auth.js';
import { sha256, randomToken } from '../src/lib/util.js';
const [email, role = 'super_admin', name] = process.argv.slice(2);
if (!email) { console.error('usage: npm run create-admin -- <email> [role] ["Full name"]'); process.exit(1); }
const c = new pg.Client({ connectionString: config.databaseUrl }); await c.connect();
const token = randomToken(32);
const { rows: [s] } = await c.query(
  `INSERT INTO staff_users (email,password_hash,name,role,invite_pending) VALUES ($1,$2,$3,$4,true)
   ON CONFLICT (email) DO UPDATE SET invite_pending=true, mfa_secret_enc=NULL, mfa_pending_enc=NULL, mfa_last_step=NULL RETURNING id`,
  [email.toLowerCase(), await hashPassword(crypto.randomBytes(32).toString('hex')), name || email, role]);
await c.query(`UPDATE staff_tokens SET used_at=now() WHERE staff_id=$1 AND purpose='invite' AND used_at IS NULL`, [s.id]);
await c.query(`INSERT INTO staff_tokens (staff_id,purpose,token_hash,expires_at) VALUES ($1,'invite',$2, now() + interval '72 hours')`, [s.id, sha256(token)]);
await c.end();
console.log(`created ${email} (${role}). Open this once, within 72 hours:\n${config.adminUrl}/accept-invite?token=${token}\n(or POST /auth/admin/invite/accept with {"token","password"})`);
