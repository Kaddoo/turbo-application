-- driver_presence is updated every ~5 s per driver. An index on seen_at would stop HOT updates
-- (heap-only tuples) and bloat the table. It holds one row per driver, so a seq scan is cheaper anyway.
DROP INDEX IF EXISTS driver_presence_seen_at_idx;
ALTER TABLE driver_presence SET (fillfactor = 50, autovacuum_vacuum_scale_factor = 0.01, autovacuum_vacuum_threshold = 50);
