import 'package:turbo_api/turbo_api.dart';

import 'location_reporter.dart';
import 'tracked_point.dart';

/// Sends points through the generated client: `PUT /driver/location`.
SendPoints apiSender(TurboClient client) => (List<TrackedPoint> points) async {
      final batch = LocationBatch(
        points: [
          for (final p in points)
            DriverLocationPoint(
              point: GeoPoint(lat: p.latitude, lng: p.longitude),
              recordedAt: p.recordedAt.toUtc(),
              accuracyMeters: p.accuracyMeters,
              headingDegrees: p.headingDegrees,
              speedMps: p.speedMps,
            ),
        ],
      );
      await client.api.getDriverApi().pushLocation(locationBatch: batch);
    };
