import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../location/location_access.dart';
import '../push/push_service.dart';

/// What the phone can tell us before a shift. Behind an interface so tests need
/// no hardware.
abstract class ReadinessSource {
  Future<DriverLocationAccess> location();
  Future<({int percent, bool charging})> battery();
  Future<bool> online();
  Future<bool> notifications();
  Future<void> requestLocation();
  Future<void> openSettings();
  Future<bool> requestNotifications();
}

class DeviceReadinessSource implements ReadinessSource {
  DeviceReadinessSource(this._push);

  final PushPlatform? _push;

  @override
  Future<DriverLocationAccess> location() => checkLocationAccess();

  @override
  Future<({int percent, bool charging})> battery() async {
    final b = Battery();
    final level = await b.batteryLevel;
    final state = await b.batteryState;
    return (percent: level, charging: state == BatteryState.charging || state == BatteryState.full);
  }

  @override
  Future<bool> online() async {
    final r = await Connectivity().checkConnectivity();
    return r.any((c) => c != ConnectivityResult.none);
  }

  @override
  Future<bool> notifications() async => await _push?.notificationsEnabled() ?? false;

  @override
  Future<void> requestLocation() async {
    await requestLocationAccess();
  }

  @override
  Future<void> openSettings() async {
    await openLocationSettings();
  }

  @override
  Future<bool> requestNotifications() async => await _push?.requestPermission() ?? false;
}

final readinessSourceProvider = Provider<ReadinessSource>((ref) => DeviceReadinessSource(ref.watch(pushPlatformProvider)));

@immutable
class Readiness {
  const Readiness({required this.location, required this.batteryPercent, required this.charging, required this.online, required this.notifications});

  final DriverLocationAccess location;
  final int batteryPercent;
  final bool charging;
  final bool online;
  final bool notifications;

  bool get locationOk => location == DriverLocationAccess.always;
  bool get batteryOk => batteryPercent > 20 || charging;
  bool get allOk => locationOk && batteryOk && online && notifications;
}

/// Read again whenever the screen asks (on open, on resume, after a fix).
final readinessProvider = FutureProvider.autoDispose<Readiness>((ref) async {
  final s = ref.read(readinessSourceProvider);
  final b = await s.battery();
  return Readiness(
    location: await s.location(),
    batteryPercent: b.percent,
    charging: b.charging,
    online: await s.online(),
    notifications: await s.notifications(),
  );
});
