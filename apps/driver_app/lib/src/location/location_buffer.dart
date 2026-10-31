import 'tracked_point.dart';

/// Holds points that have not reached the API yet. Oldest first. Anything older
/// than [maxAge] is dropped: a position from ten minutes ago helps nobody.
class LocationBuffer {
  LocationBuffer({
    this.maxAge = const Duration(minutes: 10),
    this.maxBatch = 20,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration maxAge;

  /// The contract allows at most 20 points per request.
  final int maxBatch;
  final DateTime Function() _now;
  final List<TrackedPoint> _points = [];

  int get length => _points.length;
  bool get isEmpty => _points.isEmpty;

  void add(TrackedPoint point) => _points.add(point);

  /// Drops points older than [maxAge]. Returns how many were dropped.
  int dropStale() {
    final cutoff = _now().subtract(maxAge);
    final before = _points.length;
    _points.removeWhere((p) => p.recordedAt.isBefore(cutoff));
    return before - _points.length;
  }

  /// The oldest points, up to one request's worth. Not removed until sent.
  List<TrackedPoint> peekBatch() => List.unmodifiable(_points.take(maxBatch));

  void removeFirst(int count) => _points.removeRange(0, count.clamp(0, _points.length));
}
