-- Hourly OTP budget counts rows by time only.
CREATE INDEX IF NOT EXISTS otp_challenges_created_idx ON otp_challenges (created_at DESC);
-- Per-student top-up rate and ticket rate lookups.
CREATE INDEX IF NOT EXISTS topups_student_recent_idx ON topups (student_id, created_at DESC);
CREATE INDEX IF NOT EXISTS uploads_owner_recent_idx ON uploads (owner_id, created_at DESC) WHERE status <> 'purged';
-- A single OTP/trip-share abuse trail
CREATE TABLE IF NOT EXISTS share_sms_log (
  id bigserial PRIMARY KEY, student_id uuid NOT NULL, phone text NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS share_sms_student_idx ON share_sms_log (student_id, created_at DESC);
CREATE INDEX IF NOT EXISTS share_sms_phone_idx ON share_sms_log (phone, created_at DESC);

-- 'uploading' = a PUT has claimed the slot and is writing the file
ALTER TABLE uploads DROP CONSTRAINT IF EXISTS uploads_status_check;
ALTER TABLE uploads ADD CONSTRAINT uploads_status_check CHECK (status IN ('pending','uploading','stored','purged'));
