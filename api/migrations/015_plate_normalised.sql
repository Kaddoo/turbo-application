-- A plate belongs to a physical vehicle, so two plates that differ only by case, spaces or hyphens are the same plate, and a retired
-- vehicle still owns its plate (staff reactivate that vehicle; they do not add it again).
-- plate_normalised is the plate in capitals with every character that is not a letter or digit removed. It is generated from plate_number,
-- so it can never drift, and it carries the unique index. Soft-deleted rows (deleted_at) are left out, as the old index did.
--
-- If two live vehicles already collide once normalised, this migration STOPS and lists them. Nothing is changed; staff fix the plates first.
DO $$
DECLARE c text;
BEGIN
  SELECT string_agg(norm || ' (' || n || ' vehicles: ' || ids || ')', '; ') INTO c FROM (
    SELECT regexp_replace(upper(plate_number), '[^A-Z0-9]', '', 'g') AS norm, count(*) AS n, string_agg(id::text || ' ' || status, ', ') AS ids
    FROM vehicles WHERE deleted_at IS NULL GROUP BY 1 HAVING count(*) > 1) x;
  IF c IS NOT NULL THEN RAISE EXCEPTION 'plate collisions after normalising, fix these first: %', c; END IF;
END $$;

ALTER TABLE vehicles ADD COLUMN plate_normalised text GENERATED ALWAYS AS (regexp_replace(upper(plate_number), '[^A-Z0-9]', '', 'g')) STORED;
CREATE UNIQUE INDEX vehicles_plate_normalised_uq ON vehicles (plate_normalised) WHERE deleted_at IS NULL;
DROP INDEX vehicles_plate_uq;           -- replaced by the index above, which also ignores spaces and hyphens
