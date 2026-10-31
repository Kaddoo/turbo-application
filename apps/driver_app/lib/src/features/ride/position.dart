import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turbo_api/turbo_api.dart';

/// One position, on demand: for "I've arrived", "complete" and SOS. Behind an
/// interface so tests need no GPS.
abstract class PositionReader {
  Future<GeoPoint?> current();
}

class GeolocatorPositionReader implements PositionReader {
  const GeolocatorPositionReader();

  @override
  Future<GeoPoint?> current() async {
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 8)),
      );
      return GeoPoint(lat: p.latitude, lng: p.longitude);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      return last == null ? null : GeoPoint(lat: last.latitude, lng: last.longitude);
    }
  }
}

final positionReaderProvider = Provider<PositionReader>((_) => const GeolocatorPositionReader());
