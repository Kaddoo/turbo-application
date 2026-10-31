CREATE TABLE IF NOT EXISTS worker_heartbeat (id int PRIMARY KEY CHECK (id = 1), beat_at timestamptz NOT NULL DEFAULT now(), pid int);
INSERT INTO worker_heartbeat (id) VALUES (1) ON CONFLICT DO NOTHING;
