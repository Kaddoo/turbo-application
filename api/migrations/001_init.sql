CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  role text NOT NULL CHECK (role IN ('student','driver')),
  phone text NOT NULL UNIQUE,
  first_name text, last_name text,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','suspended')),
  terms_version text, terms_accepted_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE students (
  user_id uuid PRIMARY KEY REFERENCES users(id),
  verification_status text NOT NULL DEFAULT 'not_submitted'
    CHECK (verification_status IN ('not_submitted','pending','approved','needs_attention','rejected')),
  student_id_number text, ghana_card_hash text UNIQUE, ghana_card_enc text,
  no_show_count int NOT NULL DEFAULT 0
);

CREATE TABLE verification_decisions (  -- append-only
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id),
  decision text NOT NULL, note text, decided_by uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE drivers (
  user_id uuid PRIMARY KEY REFERENCES users(id),
  active boolean NOT NULL DEFAULT true,
  on_duty boolean NOT NULL DEFAULT false,
  vehicle_make text, vehicle_model text, vehicle_color text, plate text
);

CREATE TABLE staff_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE, password_hash text NOT NULL, name text,
  role text NOT NULL CHECK (role IN ('super_admin','finance','verifier','dispatcher','support')),
  failed_logins int NOT NULL DEFAULT 0, locked_until timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE refresh_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL, subject_id uuid NOT NULL, subject_type text NOT NULL,
  token_hash text NOT NULL UNIQUE, used_at timestamptz, revoked_at timestamptz,
  expires_at timestamptz NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON refresh_tokens (family_id);

CREATE TABLE otp_challenges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone text NOT NULL, ip text, code_hash text NOT NULL,
  attempts int NOT NULL DEFAULT 0, consumed_at timestamptz,
  expires_at timestamptz NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON otp_challenges (phone, created_at DESC);
CREATE INDEX ON otp_challenges (ip, created_at DESC);

CREATE TABLE settings (key text PRIMARY KEY, value jsonb NOT NULL, updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE fare_bands (upto_meters int PRIMARY KEY, fare_pesewas bigint NOT NULL CHECK (fare_pesewas % 100 = 0));
CREATE TABLE service_area (id int PRIMARY KEY DEFAULT 1 CHECK (id = 1), polygon jsonb, version int NOT NULL DEFAULT 0);
CREATE TABLE pickup_points (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, landmark text,
  lat double precision NOT NULL, lng double precision NOT NULL, active boolean NOT NULL DEFAULT true
);

-- Latest point per driver. UNLOGGED: losing it in a crash is harmless.
CREATE UNLOGGED TABLE driver_presence (
  driver_id uuid PRIMARY KEY, lat double precision NOT NULL, lng double precision NOT NULL,
  heading real, speed real, seen_at timestamptz NOT NULL DEFAULT now(),
  last_sampled_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON driver_presence (seen_at);
CREATE TABLE driver_locations (  -- sampled history
  id bigserial PRIMARY KEY, driver_id uuid NOT NULL, ride_id uuid,
  lat double precision NOT NULL, lng double precision NOT NULL, recorded_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON driver_locations (driver_id, recorded_at DESC);

CREATE TABLE wallets (
  student_id uuid PRIMARY KEY REFERENCES students(user_id),
  balance_pesewas bigint NOT NULL DEFAULT 0,
  reserved_pesewas bigint NOT NULL DEFAULT 0,
  CONSTRAINT wallet_sane CHECK (balance_pesewas >= reserved_pesewas AND reserved_pesewas >= 0)
);

CREATE TABLE quotes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id),
  pickup_lat double precision NOT NULL, pickup_lng double precision NOT NULL, pickup_label text,
  drop_lat double precision NOT NULL, drop_lng double precision NOT NULL, drop_label text,
  distance_m int NOT NULL, duration_s int NOT NULL, fare_pesewas bigint NOT NULL,
  expires_at timestamptz NOT NULL, used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON quotes (student_id, created_at DESC);

CREATE TABLE rides (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id),
  driver_id uuid REFERENCES drivers(user_id),
  status text NOT NULL CHECK (status IN ('searching','assigned','driver_arrived','in_progress','completed','cancelled')),
  pickup_lat double precision NOT NULL, pickup_lng double precision NOT NULL, pickup_label text,
  drop_lat double precision NOT NULL, drop_lng double precision NOT NULL, drop_label text,
  distance_m int NOT NULL, duration_s int NOT NULL, fare_pesewas bigint NOT NULL,
  pin text, pin_attempts int NOT NULL DEFAULT 0,
  flags text[] NOT NULL DEFAULT '{}',
  cancel_by text, cancel_reason text,
  ack_deadline timestamptz, acked_at timestamptz,
  requested_at timestamptz NOT NULL DEFAULT now(),
  assigned_at timestamptz, arrived_at timestamptz, started_at timestamptz,
  completed_at timestamptz, cancelled_at timestamptz,
  complete_lat double precision, complete_lng double precision,
  rating int CHECK (rating BETWEEN 1 AND 5), rating_comment text
);
-- Invariants 1 and 2: at most one active ride per student and per driver.
CREATE UNIQUE INDEX one_active_ride_per_student ON rides (student_id)
  WHERE status IN ('searching','assigned','driver_arrived','in_progress');
CREATE UNIQUE INDEX one_active_ride_per_driver ON rides (driver_id)
  WHERE driver_id IS NOT NULL AND status IN ('assigned','driver_arrived','in_progress');
CREATE INDEX ON rides (status, requested_at);
CREATE INDEX ON rides (student_id, requested_at DESC);
CREATE INDEX ON rides (driver_id, requested_at DESC);

CREATE TABLE ride_events (  -- append-only
  id bigserial PRIMARY KEY, ride_id uuid NOT NULL REFERENCES rides(id),
  type text NOT NULL, actor_type text NOT NULL, actor_id uuid, data jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON ride_events (ride_id, id);
CREATE TABLE ride_declines (  -- append-only
  id bigserial PRIMARY KEY, ride_id uuid NOT NULL REFERENCES rides(id),
  driver_id uuid NOT NULL, reason text NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON ride_declines (ride_id);

CREATE TABLE holds (
  ride_id uuid PRIMARY KEY REFERENCES rides(id), student_id uuid NOT NULL,
  amount_pesewas bigint NOT NULL, status text NOT NULL DEFAULT 'open' CHECK (status IN ('open','charged','released')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ledger_entries (  -- append-only
  id bigserial PRIMARY KEY, student_id uuid NOT NULL REFERENCES students(user_id),
  type text NOT NULL CHECK (type IN ('topup','ride_hold','ride_release','ride_charge','refund','adjustment','provider_reversal')),
  amount_pesewas bigint NOT NULL,      -- effect on balance (signed)
  reserved_delta bigint NOT NULL DEFAULT 0,  -- effect on reserved (signed)
  ride_id uuid, ref text, note text, created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON ledger_entries (student_id, id DESC);
CREATE UNIQUE INDEX one_refund_charge_hold ON ledger_entries (ride_id, type) WHERE type IN ('ride_hold','ride_release','ride_charge');

CREATE TABLE topups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','succeeded','failed','abandoned')),
  amount_pesewas bigint NOT NULL, amount_received_pesewas bigint,
  channel text NOT NULL DEFAULT 'mobile_money', network text,
  reference text NOT NULL UNIQUE, validation text, flagged boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(), completed_at timestamptz
);
CREATE INDEX ON topups (student_id, created_at DESC);
CREATE INDEX ON topups (status, created_at);

CREATE TABLE provider_events (  -- append-only, dedupe key
  id bigserial PRIMARY KEY, provider text NOT NULL, reference text NOT NULL, outcome text NOT NULL,
  payload jsonb, created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (provider, reference, outcome)
);

CREATE TABLE wallet_adjustments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), student_id uuid NOT NULL REFERENCES students(user_id),
  amount_pesewas bigint NOT NULL, reason_code text NOT NULL, note text,
  status text NOT NULL DEFAULT 'applied' CHECK (status IN ('pending','applied','rejected')),
  requested_by uuid NOT NULL, decided_by uuid, created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE idempotency_keys (
  scope text NOT NULL, key text NOT NULL, request_hash text NOT NULL,
  status_code int, response jsonb, created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (scope, key)
);

CREATE TABLE audit_log (  -- append-only
  id bigserial PRIMARY KEY, actor_type text NOT NULL, actor_id uuid, action text NOT NULL,
  target text, data jsonb, created_at timestamptz NOT NULL DEFAULT now()
);

CREATE FUNCTION forbid_change() RETURNS trigger AS $$ BEGIN RAISE EXCEPTION '% is append-only', TG_TABLE_NAME; END $$ LANGUAGE plpgsql;
CREATE TRIGGER ledger_append_only BEFORE UPDATE OR DELETE ON ledger_entries FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER events_append_only BEFORE UPDATE OR DELETE ON ride_events FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER audit_append_only BEFORE UPDATE OR DELETE ON audit_log FOR EACH ROW EXECUTE FUNCTION forbid_change();
CREATE TRIGGER decisions_append_only BEFORE UPDATE OR DELETE ON verification_decisions FOR EACH ROW EXECUTE FUNCTION forbid_change();
