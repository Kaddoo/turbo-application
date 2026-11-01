import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:driver_app/src/app.dart';
import 'package:driver_app/src/core/token_store.dart';
import 'package:driver_app/src/features/duty/connectivity.dart';
import 'package:driver_app/src/features/duty/location_sharing.dart';
import 'package:driver_app/src/features/duty/readiness.dart';
import 'package:driver_app/src/features/map/map_view.dart';
import 'package:driver_app/src/features/ride/position.dart';
import 'package:driver_app/src/location/location_access.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:driver_app/src/location/tracked_point.dart';

import 'fake_server.dart';

class FakeReadiness implements ReadinessSource {
  FakeReadiness({
    this.access = DriverLocationAccess.always,
    this.percent = 80,
    this.charging = false,
    this.isOnline = true,
    this.notificationsOn = true,
  });

  DriverLocationAccess access;
  int percent;
  bool charging;
  bool isOnline;
  bool notificationsOn;
  int locationAsked = 0;
  int settingsOpened = 0;

  @override
  Future<DriverLocationAccess> location() async => access;

  @override
  Future<({int percent, bool charging})> battery() async => (percent: percent, charging: charging);

  @override
  Future<bool> online() async => isOnline;

  @override
  Future<bool> notifications() async => notificationsOn;

  @override
  Future<void> requestLocation() async {
    locationAsked++;
    access = DriverLocationAccess.whileInUse;
  }

  @override
  Future<void> openSettings() async => settingsOpened++;

  @override
  Future<bool> requestNotifications() async => notificationsOn = true;
}

class FakePosition implements PositionReader {
  FakePosition([this.point]);

  GeoPoint? point;

  @override
  Future<GeoPoint?> current() async => point;
}

/// A position source tests can push fixes into.
class FakePositions {
  final controller = StreamController<TrackedPoint>.broadcast();
  int started = 0;

  Stream<TrackedPoint> call({required String title, required String text}) {
    started++;
    return controller.stream;
  }
}

FakeServer driverServer({bool onDuty = false, String? currentRideId}) => FakeServer()
  ..on('GET /app-config', body: appConfig())
  ..on('GET /legal', body: legal)
  ..on('POST /auth/refresh', body: tokens(refresh: 'refresh-2'))
  ..on('GET /driver/profile', body: driverProfile(onDuty: onDuty, currentRideId: currentRideId))
  ..on('GET /me/sessions', body: {'items': []})
  ..on('PUT /driver/location', status: 204, body: null);

Future<void> bootDriver(
  WidgetTester tester,
  FakeServer server, {
  FakeReadiness? readiness,
  FakePositions? positions,
  bool signedIn = true,
  bool online = true,
  FakePosition? position,
  Size size = const Size(390, 900),
  List<Override> extra = const [],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        ...server.overrides(store: MemoryTokenStore(signedIn ? 'refresh-1' : null)),
        readinessSourceProvider.overrideWithValue(readiness ?? FakeReadiness()),
        positionSourceProvider.overrideWithValue((positions ?? FakePositions()).call),
        onlineProvider.overrideWith((_) => Stream.value(online)),
        mapBuilderProvider.overrideWithValue((context, spec) => const SizedBox.expand(key: Key('map'))),
        positionReaderProvider.overrideWithValue(position ?? FakePosition(GeoPoint(lat: 5.7203, lng: 0.0757))),
        ...extra,
      ],
      child: const App(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}
