ALTER TABLE topups ADD COLUMN IF NOT EXISTS last_checked_at timestamptz;
CREATE INDEX IF NOT EXISTS topups_reconcile ON topups (status, last_checked_at) WHERE status IN ('pending','abandoned');
