import { q } from '../db.js';
import * as storage from '../lib/storage.js';

// D5: identity documents are deleted N days after a final decision; the decision record stays.
export async function purgeDocuments(days) {
  const rows = (await q(`SELECT s.user_id, array_remove(ARRAY[s.front_upload_id,s.back_upload_id,s.id_upload_id,s.selfie_upload_id], NULL) AS ids
      FROM students s WHERE s.documents_purged_at IS NULL AND s.decided_at IS NOT NULL AND s.verification_status IN ('approved','rejected')
       AND s.decided_at < now() - make_interval(days => $1) LIMIT 100`, [days])).rows;
  for (const { user_id, ids } of rows) {
    const { rows: ups } = await q(`SELECT id,storage_key FROM uploads WHERE id = ANY($1) AND status='stored'`, [ids]);
    for (const u of ups) await storage.remove(u.storage_key);
    await q(`UPDATE uploads SET status='purged', purged_at=now() WHERE id = ANY($1)`, [ids]);
    await q('UPDATE students SET documents_purged_at=now() WHERE user_id=$1', [user_id]);
  }
  return rows.length;
}
