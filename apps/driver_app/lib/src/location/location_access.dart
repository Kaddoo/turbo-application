import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

import 'tracked_point.dart';

/// How much the driver has allowed. Only [always] is enough for a locked screen.
enum DriverLocationAccess { always, whileInUse, denied, deniedForever, servicesOff }

DriverLocationAccess _map(LocationPermission p) => switch (p) {
      LocationPermission.always => DriverLocationAccess.always,
      LocationPermission.whileInUse => DriverLocationAccess.whileInUse,
      LocationPermission.deniedForever => DriverLocationAccess.deniedForever,
      _ => DriverLocationAccess.denied,
    };

Future<DriverLocationAccess> checkLocationAccess() async {
  if (!await Geolocator.isLocationServiceEnabled()) return DriverLocationAccess.servicesOff;
  return _map(await Geolocator.checkPermission());
}

/// Asks for "while using", then for "always". iOS shows the upgrade prompt on
/// the second request, and only once, so a second `whileInUse` result means the
/// person must change it in Settings.
Future<DriverLocationAccess> requestLocationAccess() async {
  if (!await Geolocator.isLocationServiceEnabled()) return DriverLocationAccess.servicesOff;
  var p = await Geolocator.checkPermission();
  if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
  if (p == LocationPermission.whileInUse) p = await Geolocator.requestPermission();
  return _map(p);
}

Future<bool> openLocationSettings() => Geolocator.openAppSettings();

/// Background-capable position stream. [notificationTitle] and
/// [notificationText] are the Android foreground-service notification; the
/// caller supplies them so the product name comes from the brand layer.
Stream<TrackedPoint> backgroundPositions({
  required String notificationTitle,
  required String notificationText,
  Duration interval = const Duration(seconds: 5),
}) {
  final LocationSettings settings = Platform.isIOS
      ? AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.automotiveNavigation,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: false,
          showBackgroundLocationIndicator: true,
          allowBackgroundLocationUpdates: true,
        )
      : AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          intervalDuration: interval,
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationTitle: notificationTitle,
            notificationText: notificationText,
            enableWakeLock: true,
            setOngoing: true,
          ),
        );
  return Geolocator.getPositionStream(locationSettings: settings).map(
    (p) => TrackedPoint(
      latitude: p.latitude,
      longitude: p.longitude,
      recordedAt: p.timestamp,
      accuracyMeters: p.accuracy,
      headingDegrees: p.heading >= 0 ? p.heading : null,
      speedMps: p.speed >= 0 ? p.speed : null,
    ),
  );
}
