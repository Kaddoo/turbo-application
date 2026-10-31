-- Transactional outbox for push notifications. A row is written in the SAME transaction as the event that causes it, so a rolled-back
-- booking never sends a push; the worker delivers rows afterwards (with retries), so no request ever waits on Google.
CREATE TABLE notifications (
  id bigserial PRIMARY KEY,
  user_id uuid NOT NULL, user_type text NOT NULL CHECK (user_type IN ('user','staff')),
  kind text NOT NULL, title text NOT NULL, body text NOT NULL, data jsonb NOT NULL DEFAULT '{}',
  priority smallint NOT NULL DEFAULT 5,                       -- 10 = time-critical (ride offers, SOS), 1 = bulk (announcements)
  dedupe_key text,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','sent','failed','skipped')),
  attempts int NOT NULL DEFAULT 0, next_attempt_at timestamptz NOT NULL DEFAULT now(), last_error text,
  created_at timestamptz NOT NULL DEFAULT now(), sent_at timestamptz,
  expires_at timestamptz NOT NULL                              -- a ride offer that arrives 5 minutes late is worse than none
);
CREATE UNIQUE INDEX notifications_dedupe_uq ON notifications (dedupe_key) WHERE dedupe_key IS NOT NULL;
CREATE INDEX notifications_due_idx ON notifications (priority DESC, id) WHERE status = 'pending';
CREATE INDEX notifications_user_idx ON notifications (user_id, created_at DESC);
ALTER TABLE devices ADD COLUMN failures int NOT NULL DEFAULT 0, ADD COLUMN last_error text;
