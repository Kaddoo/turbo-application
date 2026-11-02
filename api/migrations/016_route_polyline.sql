-- The road from pickup to drop-off, as a Google encoded polyline, kept with the quote and copied to the ride when it is booked.
ALTER TABLE quotes ADD COLUMN route_polyline text;
ALTER TABLE rides ADD COLUMN route_polyline text;
