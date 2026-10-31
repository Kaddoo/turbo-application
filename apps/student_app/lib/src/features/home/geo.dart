import 'dart:math' as math;

import 'package:turbo_api/turbo_api.dart';

/// Straight-line distance in metres between two points (haversine).
double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
  const earth = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1), dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * earth * math.asin(math.min(1, math.sqrt(a)));
}

/// The active pickup point closest to a position, or null if there are none.
PickupPoint? nearestPickupPoint(Iterable<PickupPoint> points, double lat, double lng) {
  PickupPoint? best;
  var bestDistance = double.infinity;
  for (final p in points.where((p) => p.isActive)) {
    final d = distanceMeters(lat, lng, p.point.lat.toDouble(), p.point.lng.toDouble());
    if (d < bestDistance) {
      bestDistance = d;
      best = p;
    }
  }
  return best;
}

/// A pickup point as the `Location` the quote endpoint wants.
Location locationOfPickup(PickupPoint p) =>
    Location(point: p.point, label: p.name, pickupPointId: p.id);

/// `[south, west, north, east]` around a boundary polygon, or null.
List<double>? boundingBox(GeoJsonPolygon? polygon) {
  final rings = polygon?.coordinates;
  if (rings == null || rings.isEmpty) return null;
  double? south, west, north, east;
  for (final position in rings.first) {
    // GeoJSON positions are [longitude, latitude].
    final lng = position[0].toDouble(), lat = position[1].toDouble();
    south = south == null ? lat : math.min(south, lat);
    north = north == null ? lat : math.max(north, lat);
    west = west == null ? lng : math.min(west, lng);
    east = east == null ? lng : math.max(east, lng);
  }
  return south == null ? null : [south, west!, north!, east!];
}
