-- Private uploads (identity documents, support attachments, statements). Bytes live in storage, never in Postgres.
CREATE TABLE uploads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL,
  owner_type text NOT NULL CHECK (owner_type IN ('student','driver','staff')),
  purpose text NOT NULL,
  content_type text NOT NULL,
  size_bytes int NOT NULL,
  storage_key text NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','stored','purged')),
  used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  stored_at timestamptz, purged_at timestamptz
);
CREATE INDEX ON uploads (owner_id, created_at DESC);

-- What the student submitted for review (contract: VerificationSubmission). Decisions stay append-only in verification_decisions.
ALTER TABLE students
  ADD COLUMN submitted_full_name text,
  ADD COLUMN front_upload_id uuid REFERENCES uploads(id),
  ADD COLUMN back_upload_id uuid REFERENCES uploads(id),
  ADD COLUMN id_upload_id uuid REFERENCES uploads(id),
  ADD COLUMN selfie_upload_id uuid REFERENCES uploads(id),
  ADD COLUMN submitted_at timestamptz,
  ADD COLUMN decided_at timestamptz,
  ADD COLUMN reason_code text,
  ADD COLUMN student_message text,
  ADD COLUMN claimed_by uuid,
  ADD COLUMN claim_expires_at timestamptz,
  ADD COLUMN documents_purged_at timestamptz;
CREATE INDEX ON students (verification_status, submitted_at);
ALTER TABLE verification_decisions ADD COLUMN reason_code text;
