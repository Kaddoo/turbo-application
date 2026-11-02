-- The two optional notification choices a student can make (contract 0.6.0). Ride and wallet messages are not optional.
ALTER TABLE students ADD COLUMN notify_news boolean NOT NULL DEFAULT false, ADD COLUMN notify_tips boolean NOT NULL DEFAULT true;
