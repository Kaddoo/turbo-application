CREATE TABLE trusted_contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES students(user_id),
  name text NOT NULL, phone text NOT NULL, relationship text,
  created_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE INDEX ON trusted_contacts (student_id) WHERE deleted_at IS NULL;

CREATE TABLE trip_shares (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ride_id uuid NOT NULL REFERENCES rides(id), student_id uuid NOT NULL,
  token_hash text NOT NULL UNIQUE, contact_ids uuid[] NOT NULL,
  expires_at timestamptz NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON trip_shares (ride_id);

CREATE TABLE incidents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL CHECK (type IN ('sos','safety_report')),
  status text NOT NULL DEFAULT 'open' CHECK (status IN ('open','acknowledged','resolved')),
  reporter_id uuid NOT NULL, reporter_role text NOT NULL CHECK (reporter_role IN ('student','driver')),
  ride_id uuid REFERENCES rides(id), lat double precision, lng double precision, note text,
  created_at timestamptz NOT NULL DEFAULT now(),
  acknowledged_by uuid, acknowledged_at timestamptz, resolved_by uuid, resolved_at timestamptz, staff_note text
);
CREATE INDEX ON incidents (status, created_at DESC);
CREATE INDEX ON incidents (reporter_id, created_at DESC);

CREATE TABLE support_tickets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id), user_role text NOT NULL,
  category text NOT NULL, subject text NOT NULL, ride_id uuid REFERENCES rides(id),
  status text NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','waiting_on_user','resolved','closed')),
  assigned_to uuid REFERENCES staff_users(id),
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON support_tickets (user_id, updated_at DESC);
CREATE INDEX ON support_tickets (status, updated_at DESC);

CREATE TABLE support_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id uuid NOT NULL REFERENCES support_tickets(id),
  author text NOT NULL CHECK (author IN ('user','staff')), author_id uuid NOT NULL,
  body text NOT NULL, internal boolean NOT NULL DEFAULT false, upload_ids uuid[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON support_messages (ticket_id, created_at);
CREATE TRIGGER support_messages_append_only BEFORE UPDATE OR DELETE ON support_messages FOR EACH ROW EXECUTE FUNCTION forbid_change();
