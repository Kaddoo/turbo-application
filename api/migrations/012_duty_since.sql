-- When the driver last went on duty (feeds attendance minutes).
ALTER TABLE drivers ADD COLUMN duty_since timestamptz;
