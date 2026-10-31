ALTER TABLE pickup_points ADD COLUMN deleted_at timestamptz;
-- AuditEntry.id is a UUID in the contract (the table is append-only; adding a column with a default is allowed).
ALTER TABLE audit_log ADD COLUMN public_id uuid NOT NULL DEFAULT gen_random_uuid();
CREATE UNIQUE INDEX audit_public_id_uq ON audit_log (public_id);
CREATE INDEX audit_action_idx ON audit_log (action text_pattern_ops, id DESC);
CREATE INDEX audit_target_idx ON audit_log (target, id DESC);
