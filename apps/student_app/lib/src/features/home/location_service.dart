import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turbo_api/turbo_api.dart';

enum LocationStatus { granted, denied, deniedForever, servicesOff }

class UserLocation {
  const UserLocation(this.status, [this.point]);

  final LocationStatus status;
  final GeoPoint? point;
}

/// "While using the app" location. Behind an interface so tests need no GPS.
abstract class LocationService {
  /// Reads permission without asking.
  Future<LocationStatus> status();

  /// Asks if needed, then reads one position.
  Future<UserLocation> current({bool ask = true});

  Future<void> openSettings();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  LocationStatus _map(LocationPermission p) => switch (p) {
        LocationPermission.always || LocationPermission.whileInUse => LocationStatus.granted,
        LocationPermission.deniedForever => LocationStatus.deniedForever,
        _ => LocationStatus.denied,
      };

  @override
  Future<LocationStatus> status() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationStatus.servicesOff;
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<UserLocation> current({bool ask = true}) async {
    if (!await Geolocator.isLocationServiceEnabled()) return const UserLocation(LocationStatus.servicesOff);
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && ask) permission = await Geolocator.requestPermission();
    final status = _map(permission);
    if (status != LocationStatus.granted) return UserLocation(status);
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
      );
      return UserLocation(status, GeoPoint(lat: p.latitude, lng: p.longitude));
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      return UserLocation(status, last == null ? null : GeoPoint(lat: last.latitude, lng: last.longitude));
    }
  }

  @override
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}

final locationServiceProvider = Provider<LocationService>((_) => const GeolocatorLocationService());

class UserLocationController extends AsyncNotifier<UserLocation> {
  @override
  Future<UserLocation> build() => ref.read(locationServiceProvider).current(ask: true);

  Future<void> refresh({bool ask = true}) async {
    state = await AsyncValue.guard(() => ref.read(locationServiceProvider).current(ask: ask));
  }
}

final userLocationProvider = AsyncNotifierProvider<UserLocationController, UserLocation>(UserLocationController.new);
