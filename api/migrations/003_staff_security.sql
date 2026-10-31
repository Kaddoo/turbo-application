-- Staff accounts: MFA, invite/reset tokens, deactivation. Spec 01 / audit F-02.
ALTER TABLE staff_users
  ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS mfa_secret_enc text,          -- AES-256-GCM, confirmed secret
  ADD COLUMN IF NOT EXISTS mfa_pending_enc text,         -- secret shown at enrolment, not yet confirmed
  ADD COLUMN IF NOT EXISTS mfa_confirmed_at timestamptz,
  ADD COLUMN IF NOT EXISTS mfa_last_step bigint,         -- last accepted TOTP step: a code works once
  ADD COLUMN IF NOT EXISTS invite_pending boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS last_login_at timestamptz;

CREATE TABLE IF NOT EXISTS staff_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id uuid NOT NULL REFERENCES staff_users(id) ON DELETE CASCADE,
  purpose text NOT NULL CHECK (purpose IN ('invite','reset','enroll')),
  token_hash text NOT NULL UNIQUE,
  expires_at timestamptz NOT NULL, used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS staff_tokens_staff ON staff_tokens (staff_id, purpose);
