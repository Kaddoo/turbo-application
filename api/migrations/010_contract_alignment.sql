-- Brings the data model up to what openapi.yaml (0.2.1) describes. Additive: nothing is dropped.
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- ---- people
ALTER TABLE users ADD COLUMN full_name text, ADD COLUMN email text, ADD COLUMN privacy_version text;
UPDATE users SET full_name = NULLIF(trim(coalesce(first_name,'') || ' ' || coalesce(last_name,'')), '');

-- ---- vehicles are records of their own, assigned to a driver
CREATE TABLE vehicles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  make text NOT NULL, model text NOT NULL, colour text NOT NULL, plate_number text NOT NULL,
  seats int NOT NULL DEFAULT 4 CHECK (seats BETWEEN 1 AND 20),
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','maintenance','retired')),
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE UNIQUE INDEX vehicles_plate_uq ON vehicles (upper(plate_number)) WHERE deleted_at IS NULL;
ALTER TABLE drivers ADD COLUMN vehicle_id uuid REFERENCES vehicles(id), ADD COLUMN email text, ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
CREATE UNIQUE INDEX one_driver_per_vehicle ON drivers (vehicle_id) WHERE vehicle_id IS NOT NULL;
DO $$ DECLARE d record; v uuid; BEGIN
  FOR d IN SELECT user_id, vehicle_make, vehicle_model, vehicle_color, plate FROM drivers WHERE plate IS NOT NULL LOOP
    INSERT INTO vehicles (make, model, colour, plate_number) VALUES (coalesce(d.vehicle_make,'Unknown'), coalesce(d.vehicle_model,'Unknown'), coalesce(d.vehicle_color,'Unknown'), d.plate)
      ON CONFLICT DO NOTHING RETURNING id INTO v;
    IF v IS NOT NULL THEN UPDATE drivers SET vehicle_id = v WHERE user_id = d.user_id; END IF;
    v := NULL;
  END LOOP;
END $$;

CREATE TABLE driver_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid NOT NULL REFERENCES drivers(user_id),
  type text NOT NULL CHECK (type IN ('drivers_licence','ghana_card','vehicle_registration','insurance','roadworthy','other')),
  upload_id uuid NOT NULL REFERENCES uploads(id), expires_on date,
  created_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE INDEX ON driver_documents (driver_id) WHERE deleted_at IS NULL;
CREATE INDEX ON driver_documents (expires_on) WHERE deleted_at IS NULL;

-- ---- student conveniences
CREATE TABLE saved_places (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id), label text NOT NULL,
  lat double precision NOT NULL, lng double precision NOT NULL, place_label text, landmark text, pickup_point_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE INDEX ON saved_places (student_id) WHERE deleted_at IS NULL;

CREATE TABLE devices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL, user_type text NOT NULL CHECK (user_type IN ('user','staff')),
  device_id text NOT NULL, fcm_token text NOT NULL, platform text NOT NULL CHECK (platform IN ('ios','android','web')), app_version text,
  updated_at timestamptz NOT NULL DEFAULT now(), UNIQUE (user_id, device_id)
);
CREATE INDEX ON devices (fcm_token);

ALTER TABLE refresh_tokens ADD COLUMN platform text, ADD COLUMN device_name text, ADD COLUMN client_type text, ADD COLUMN last_used_at timestamptz NOT NULL DEFAULT now();
CREATE INDEX ON refresh_tokens (subject_id, subject_type) WHERE revoked_at IS NULL;

CREATE TABLE deletion_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), student_id uuid NOT NULL REFERENCES students(user_id),
  status text NOT NULL DEFAULT 'received' CHECK (status IN ('received','scheduled','completed')),
  requested_at timestamptz NOT NULL DEFAULT now(), scheduled_for timestamptz
);
CREATE UNIQUE INDEX one_open_deletion ON deletion_requests (student_id) WHERE status <> 'completed';

CREATE TABLE ride_messages (
  id bigserial PRIMARY KEY, ride_id uuid NOT NULL REFERENCES rides(id),
  from_role text NOT NULL CHECK (from_role IN ('student','driver')), code text NOT NULL, sent_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON ride_messages (ride_id, id);
CREATE TRIGGER ride_messages_append_only BEFORE UPDATE OR DELETE ON ride_messages FOR EACH ROW EXECUTE FUNCTION forbid_change();

ALTER TABLE rides ADD COLUMN cancel_reason_code text, ADD COLUMN cancel_note text, ADD COLUMN rating_tags text[];

-- ---- staff: HR role
ALTER TABLE staff_users DROP CONSTRAINT IF EXISTS staff_users_role_check;
ALTER TABLE staff_users ADD CONSTRAINT staff_users_role_check CHECK (role IN ('super_admin','finance','verifier','dispatcher','support','hr'));

-- ---- HR: shifts, attendance, salary
CREATE TABLE shifts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid NOT NULL REFERENCES drivers(user_id), starts_at timestamptz NOT NULL, ends_at timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled','in_progress','completed','missed')),
  created_by uuid, created_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz,
  CHECK (ends_at > starts_at),
  EXCLUDE USING gist (driver_id WITH =, tstzrange(starts_at, ends_at) WITH &&) WHERE (deleted_at IS NULL)
);
CREATE INDEX ON shifts (starts_at) WHERE deleted_at IS NULL;

CREATE TABLE attendance_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid NOT NULL REFERENCES drivers(user_id), shift_id uuid REFERENCES shifts(id), date date NOT NULL,
  clock_in_at timestamptz, clock_out_at timestamptz, minutes_worked int NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'present' CHECK (status IN ('present','late','absent','corrected')),
  correction_note text, corrected_by uuid, created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (driver_id, date)
);

CREATE TABLE salary_profiles (
  driver_id uuid PRIMARY KEY REFERENCES drivers(user_id), monthly_salary_pesewas bigint NOT NULL CHECK (monthly_salary_pesewas >= 0),
  pay_period text NOT NULL CHECK (pay_period IN ('weekly','biweekly','monthly')), updated_at timestamptz NOT NULL DEFAULT now(), updated_by uuid
);
CREATE TABLE salary_payments (   -- append-only: a payment record is never edited
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid NOT NULL REFERENCES drivers(user_id), period_start date NOT NULL, period_end date NOT NULL,
  amount_pesewas bigint NOT NULL CHECK (amount_pesewas > 0), method text NOT NULL CHECK (method IN ('bank_transfer','mobile_money','cash')),
  reference text, paid_at timestamptz NOT NULL, created_by uuid, created_at timestamptz NOT NULL DEFAULT now(), CHECK (period_end >= period_start)
);
CREATE INDEX ON salary_payments (driver_id, paid_at DESC);
CREATE TRIGGER salary_payments_append_only BEFORE UPDATE OR DELETE ON salary_payments FOR EACH ROW EXECUTE FUNCTION forbid_change();

-- ---- announcements, reconciliation, adjustments
CREATE TABLE announcements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), audience text NOT NULL CHECK (audience IN ('students','drivers','all')),
  title text NOT NULL, body text NOT NULL, sent_by uuid NOT NULL, recipient_count int, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE reconciliation_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), period_from date NOT NULL, period_to date NOT NULL, matched_count int NOT NULL,
  provider_total_pesewas bigint NOT NULL, our_total_pesewas bigint NOT NULL, exceptions jsonb NOT NULL DEFAULT '[]',
  statement_upload_id uuid REFERENCES uploads(id), created_by uuid, created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE wallet_adjustments DROP CONSTRAINT IF EXISTS wallet_adjustments_status_check;
UPDATE wallet_adjustments SET status = 'approved' WHERE status = 'applied';
ALTER TABLE wallet_adjustments ADD CONSTRAINT wallet_adjustments_status_check CHECK (status IN ('pending','approved','rejected'));
ALTER TABLE wallet_adjustments ADD COLUMN decided_at timestamptz, ADD COLUMN decision_note text, ADD COLUMN ledger_id bigint;
ALTER TABLE topups ADD COLUMN flag_reason text;
