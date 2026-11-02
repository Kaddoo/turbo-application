import 'package:driver_app/src/location/location_access.dart';
import 'package:driver_app/src/location/tracked_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_server.dart';
import 'support/harness.dart';

Future<void> settle(WidgetTester tester, [int times = 6]) async {
  for (var i = 0; i < times; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

TrackedPoint fix([DateTime? at]) => TrackedPoint(latitude: 5.72, longitude: 0.0757, recordedAt: at ?? DateTime.now());

void main() {
  group('start-up gate', () {
    testWidgets('an old version sees only the update screen', (tester) async {
      final server = driverServer()..on('GET /app-config', body: appConfig(ios: '9.0.0'));
      await bootDriver(tester, server);
      await settle(tester);
      expect(find.text('Please update the app'), findsOneWidget);
    });

    testWidgets('maintenance shows the server message', (tester) async {
      final server = driverServer()..on('GET /app-config', body: appConfig(maintenance: true));
      await bootDriver(tester, server);
      await settle(tester);
      expect(find.text('Back at noon.'), findsOneWidget);
    });
  });

  group('sign-in', () {
    testWidgets('a driver signs in with role driver', (tester) async {
      final server = driverServer()
        ..on('POST /auth/otp/request', status: 202, body: {'expiresInSeconds': 300, 'resendInSeconds': 30})
        ..on('POST /auth/otp/verify', body: tokens());
      await bootDriver(tester, server, signedIn: false);
      await settle(tester);
      expect(find.text('Drive for campus', findRichText: true), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await settle(tester);
      await tester.enterText(find.byType(TextField), '020 000 0001');
      await tester.tap(find.text('Send code'));
      await settle(tester);
      expect((bodyOf(server.calls('POST /auth/otp/request').single) as Map)['role'], 'driver');
      expect(server.calls('POST /auth/otp/request').single.headers['Idempotency-Key'], isNotEmpty);
      await tester.enterText(find.byType(TextField).first, '123456');
      await settle(tester);
      final verify = bodyOf(server.calls('POST /auth/otp/verify').single) as Map;
      expect(verify['role'], 'driver');
      expect(verify['clientType'], 'mobile');
      expect(find.text('Hello, Kofi'), findsOneWidget);
    });

    testWidgets('a number that is not a driver is told so', (tester) async {
      final server = driverServer()
        ..on('POST /auth/otp/request', status: 202, body: {'expiresInSeconds': 300, 'resendInSeconds': 30})
        ..on('POST /auth/otp/verify', status: 403, body: problem('forbidden', 403));
      await bootDriver(tester, server, signedIn: false);
      await settle(tester);
      await tester.tap(find.text('Continue'));
      await settle(tester);
      await tester.enterText(find.byType(TextField), '024 123 4567');
      await tester.tap(find.text('Send code'));
      await settle(tester);
      await tester.enterText(find.byType(TextField).first, '123456');
      await settle(tester);
      expect(find.text("This number isn't registered as a driver. Contact your supervisor."), findsOneWidget);
    });
  });

  group('off duty', () {
    testWidgets('shows who you are, the vehicle and the readiness checklist', (tester) async {
      await bootDriver(tester, driverServer());
      await settle(tester);
      expect(find.text('Hello, Kofi'), findsOneWidget);
      expect(find.text('Silver Toyota Corolla · GR-4821-24'), findsOneWidget);
      expect(find.text('Before you go on duty'), findsOneWidget);
      expect(find.text('Ready to go'), findsOneWidget);
      expect(find.text('Ready'), findsNWidgets(4));
      expect(find.text('Documents checked when you go on duty'), findsOneWidget);
    });

    for (final (name, ok) in [('ready', true), ('blocked', false)]) {
      testWidgets('the readiness tiles lay out in dark mode at 200% text when $name', (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        final readiness = ok ? FakeReadiness() : FakeReadiness(access: DriverLocationAccess.whileInUse, percent: 12, notificationsOn: false, isOnline: false);
        await bootDriver(tester, driverServer(), readiness: readiness, size: const Size(360, 800));
        await settle(tester);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('failures say what is wrong, with a fix where one exists', (tester) async {
      final readiness = FakeReadiness(access: DriverLocationAccess.whileInUse, percent: 12, notificationsOn: false, isOnline: false);
      await bootDriver(tester, driverServer(), readiness: readiness);
      await settle(tester);
      expect(find.text('Ready'), findsNothing);
      expect(find.text('Open Settings'), findsOneWidget);
      await tester.tap(find.text('Open Settings'));
      await settle(tester);
      expect(readiness.settingsOpened, 1);
      // The headline names the one thing in the way.
      expect(find.text('Location set to Always'), findsOneWidget);
      expect(find.text('Ready to go'), findsNothing);
      // Battery has no fix: the driver must charge the phone. It says so with a word, not only a colour.
      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('12%'), findsOneWidget);
      expect(find.text('Needs attention'), findsNWidgets(2));
      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('charging counts even when the battery is low', (tester) async {
      await bootDriver(tester, driverServer(), readiness: FakeReadiness(percent: 8, charging: true));
      await settle(tester);
      expect(find.text('Ready'), findsNWidgets(4));
    });

    testWidgets('going on duty sends the request, starts sharing and shows the waiting screen', (tester) async {
      final server = driverServer()..on('PUT /driver/duty', body: driverProfile(onDuty: true));
      final positions = FakePositions();
      await bootDriver(tester, server, positions: positions);
      await settle(tester);
      expect(positions.started, 0, reason: 'no sharing while off duty');
      await tester.tap(find.text('Go on duty'));
      await settle(tester);
      expect((bodyOf(server.calls('PUT /driver/duty').single) as Map)['onDuty'], true);
      expect(find.text('On duty. Waiting for a ride.'), findsOneWidget);
      expect(positions.started, 1);

      positions.controller.add(fix());
      await settle(tester);
      final body = bodyOf(server.calls('PUT /driver/location').first) as Map;
      expect(body['points'], hasLength(1));
      expect(body['points'][0]['point']['lat'], 5.72);
    });

    testWidgets('an expired document keeps the driver off the road, in plain words', (tester) async {
      final server = driverServer()..on('PUT /driver/duty', status: 409, body: problem('document_expired', 409));
      await bootDriver(tester, server);
      await settle(tester);
      await tester.tap(find.text('Go on duty'));
      await settle(tester);
      expect(find.text('A document has expired. Contact your supervisor.'), findsOneWidget);
      expect(find.text('Go on duty'), findsOneWidget);
    });

    testWidgets('a lost connection is not reported as a refusal', (tester) async {
      final server = driverServer();
      await bootDriver(tester, server);
      await settle(tester);
      await tester.tap(find.text('Go on duty'));
      await settle(tester);
      // No route: the fake answers 404, which reads as a failure, not a code.
      expect(find.text('Go on duty'), findsOneWidget);
    });
  });

  group('dark and large text', () {
    for (final onDuty in [false, true]) {
      testWidgets('home ${onDuty ? 'on' : 'off'} duty lays out in dark mode at 200% text', (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        await bootDriver(tester, driverServer(onDuty: onDuty));
        await settle(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('on duty', () {
    testWidgets('the app opens straight into sharing when the server says on duty', (tester) async {
      final positions = FakePositions();
      await bootDriver(tester, driverServer(onDuty: true), positions: positions);
      await settle(tester);
      expect(find.text('On duty. Waiting for a ride.'), findsOneWidget);
      expect(find.text('Go off duty'), findsWidgets);
      expect(positions.started, 1);
    });

    testWidgets('going off duty asks first, then stops sharing at once', (tester) async {
      final server = driverServer(onDuty: true)..on('PUT /driver/duty', body: driverProfile());
      final positions = FakePositions();
      await bootDriver(tester, server, positions: positions);
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Go off duty'));
      await settle(tester);
      expect(find.text('Go off duty?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Go off duty').last);
      await settle(tester);
      expect((bodyOf(server.calls('PUT /driver/duty').single) as Map)['onDuty'], false);
      expect(find.text('Go on duty'), findsOneWidget);
      final before = server.calls('PUT /driver/location').length;
      positions.controller.add(fix());
      await settle(tester, 40);
      expect(server.calls('PUT /driver/location').length, before, reason: 'no pings once off duty');
    });

    testWidgets('cannot go off duty during a ride, and is told why', (tester) async {
      final server = driverServer(onDuty: true)..on('PUT /driver/duty', status: 409, body: problem('driver_has_active_ride', 409));
      await bootDriver(tester, server);
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Go off duty'));
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Go off duty').last);
      await settle(tester);
      expect(find.text("You can't go off duty during a ride."), findsOneWidget);
    });

    testWidgets('a stalled position is flagged in red words, not hidden', (tester) async {
      await bootDriver(tester, driverServer(onDuty: true));
      await settle(tester);
      expect(find.text("Your location isn't being shared. Open the app."), findsNothing);
      await tester.pump(const Duration(seconds: 35));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Your location isn't being shared. Open the app."), findsOneWidget);
    });

    testWidgets('no connection shows a persistent banner', (tester) async {
      await bootDriver(tester, driverServer(onDuty: true), online: false);
      await settle(tester);
      expect(find.textContaining("You're offline"), findsOneWidget);
    });
  });

  testWidgets('a suspended account sees a blocking message', (tester) async {
    final server = driverServer()..on('GET /driver/profile', body: driverProfile(status: 'suspended'));
    await bootDriver(tester, server);
    await settle(tester);
    expect(find.text('Your account is suspended'), findsOneWidget);
  });
}
