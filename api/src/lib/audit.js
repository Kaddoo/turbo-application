export const auditStaff = (c, staffId, action, target, data) =>
  c.query('INSERT INTO audit_log (actor_type,actor_id,action,target,data) VALUES ($1,$2,$3,$4,$5)',
    ['staff', staffId, action, target, data ? JSON.stringify(data) : null]);
