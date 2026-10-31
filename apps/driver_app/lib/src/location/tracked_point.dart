/// One GPS fix, before it is turned into the contract's `DriverLocationPoint`.
class TrackedPoint {
  const TrackedPoint({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    this.accuracyMeters,
    this.headingDegrees,
    this.speedMps,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double? accuracyMeters;
  final double? headingDegrees;
  final double? speedMps;
}
