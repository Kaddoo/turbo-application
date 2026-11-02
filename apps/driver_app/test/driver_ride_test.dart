import 'package:driver_app/src/features/ride/ride_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart' show TurboKeypad;

import 'support/fake_server.dart';
import 'support/harness.dart';

const rideId = '0190a1b2-0000-7e4f-8a5b-0000000a0001';

Future<void> settle(WidgetTester tester, [int times = 6]) async {
  for (var i = 0; i < times; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

Map<String, Object?> driverRide(
  String status, {
  bool acknowledged = true,
  DateTime? assignedAt,
  DateTime? noShowAt,
}) =>
    {
      'id': rideId,
      'status': status,
      'pickup': {'point': {'lat': 5.7203, 'lng': 0.0757}, 'label': 'Central Gate', 'landmark': 'By the security post'},
      'dropoff': {'point': {'lat': 5.6942, 'lng': -0.0335}, 'label': 'Ashaiman China Mall'},
      'routeDistanceMeters': 9400,
      'farePesewas': 3500,
      'pickupDistanceMeters': 1200,
      'pickupEtaSeconds': 240,
      'routeDurationSeconds': 840,
      'student': {'firstName': 'Ama'},
      'assignedAt': (assignedAt ?? DateTime.now()).toUtc().toIso8601String(),
      'acknowledgedAt': acknowledged ? DateTime.now().toUtc().toIso8601String() : null,
      'noShowAvailableAt': noShowAt?.toUtc().toIso8601String(),
    };

FakeServer rideServer(Map<String, Object?>? ride) {
  final s = driverServer(onDuty: true);
  if (ride == null) {
    s.on('GET /driver/rides/current', status: 204, body: null);
  } else {
    s.on('GET /driver/rides/current', body: ride);
  }
  s.on('GET /driver/rides', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}});
  return s;
}

void main() {
  group('dark and large text', () {
    for (final (name, ride) in [
      ('offer', driverRide('assigned', acknowledged: false)),
      ('to pickup', driverRide('assigned')),
      ('waiting at pickup', driverRide('driver_arrived', noShowAt: DateTime.now().add(const Duration(minutes: 3)))),
      ('trip', driverRide('in_progress')),
    ]) {
      testWidgets('$name lays out in dark mode at 200% text', (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        await bootDriver(tester, rideServer(ride));
        await settle(tester, 12);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('new assignment', () {
    testWidgets('takes over the screen with a countdown, the pickup, the student and the fare', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false));
      await bootDriver(tester, server);
      await settle(tester, 12);
      expect(find.text('New ride'), findsOneWidget);
      expect(find.text('Central Gate'), findsOneWidget);
      expect(find.text('By the security post'), findsOneWidget);
      expect(find.text('Ama'), findsOneWidget);
      expect(find.text('GH₵35.00'), findsOneWidget);
      expect(find.text('1.2 km'), findsOneWidget);
      expect(find.text('about 4 min'), findsOneWidget);
      expect(find.text('Student pays'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
    });

    testWidgets('the countdown counts down from 45 seconds', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false, assignedAt: DateTime.now().subtract(const Duration(seconds: 15))));
      await bootDriver(tester, server);
      await settle(tester, 12);
      final shown = tester.widgetList<Text>(find.byType(Text)).map((t) => int.tryParse(t.data ?? '')).whereType<int>().first;
      expect(shown, inInclusiveRange(25, 30));
    });

    testWidgets('Accept sends the acknowledgement and moves to the pickup', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false))
        ..on('POST /driver/rides/$rideId/ack', body: driverRide('assigned'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      server.on('GET /driver/rides/current', body: driverRide('assigned'));
      await tester.tap(find.text('Accept'));
      await settle(tester, 40);
      expect(server.calls('POST /driver/rides/$rideId/ack'), hasLength(1));
      expect(find.text('Go to the pickup'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
    });

    testWidgets('Decline asks why and sends the reason', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false))
        ..on('POST /driver/rides/$rideId/decline', status: 204, body: null);
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Decline'));
      await settle(tester);
      expect(find.text('Why are you declining?'), findsOneWidget);
      await tester.tap(find.text('Too far'));
      await settle(tester);
      expect((bodyOf(server.calls('POST /driver/rides/$rideId/decline').single) as Map)['reasonCode'], 'too_far');
    });

    testWidgets('when the ride is taken away, the driver is told without blame', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false));
      await bootDriver(tester, server);
      await settle(tester, 12);
      server.on('GET /driver/rides/current', status: 204, body: null);
      await tester.pump(const Duration(seconds: 5));
      await settle(tester, 12);
      expect(find.text('Ride passed to another driver'), findsOneWidget);
      expect(find.text('Back to waiting'), findsOneWidget);
    });
  });

  group('to the pickup', () {
    testWidgets('arriving near the pickup sends the position without a question', (tester) async {
      final server = rideServer(driverRide('assigned'))..on('POST /driver/rides/$rideId/arrived', body: driverRide('driver_arrived'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text("I've arrived"));
      await settle(tester, 20);
      final body = bodyOf(server.calls('POST /driver/rides/$rideId/arrived').single) as Map;
      expect(body['location']['lat'], 5.7203);
    });

    testWidgets('arriving far from the pickup asks first, and "no" sends nothing', (tester) async {
      final server = rideServer(driverRide('assigned'))..on('POST /driver/rides/$rideId/arrived', body: driverRide('driver_arrived'));
      await bootDriver(tester, server, position: FakePosition(GeoPoint(lat: 5.80, lng: 0.20)));
      await settle(tester, 12);
      await tester.tap(find.text("I've arrived"));
      await settle(tester, 12);
      expect(find.text('You look far from the pickup'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await settle(tester);
      expect(server.calls('POST /driver/rides/$rideId/arrived'), isEmpty);
    });

    testWidgets('quick messages go to the student', (tester) async {
      final server = rideServer(driverRide('assigned'))..on('POST /rides/$rideId/messages', status: 201, body: null);
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Running late'));
      await settle(tester);
      expect((bodyOf(server.calls('POST /rides/$rideId/messages').single) as Map)['code'], 'running_late');
    });

    testWidgets('SOS is one hold away and sends the ride and position', (tester) async {
      final server = rideServer(driverRide('assigned'))
        ..on('POST /safety/sos', status: 201, body: {
          'id': '0190a1b2-0000-7e4f-8a5b-0000000b0001',
          'type': 'sos',
          'status': 'open',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        });
      await bootDriver(tester, server);
      await settle(tester, 12);
      final hold = await tester.startGesture(tester.getCenter(find.text('Hold for SOS')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3, milliseconds: 200));
      await hold.up();
      await settle(tester, 10);
      final body = bodyOf(server.calls('POST /safety/sos').single) as Map;
      expect(body['rideId'], rideId);
      expect(find.text('Help has been alerted'), findsOneWidget);
    });
  });

  group('at the pickup', () {
    Future<void> toKeypad(WidgetTester tester, FakeServer server) async {
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Start trip'));
      await settle(tester);
    }

    Future<void> typePin(WidgetTester tester, String pin) async {
      for (final d in pin.split('')) {
        await tester.tap(find.descendant(of: find.byType(TurboKeypad), matching: find.text(d)));
        await tester.pump();
      }
    }

    testWidgets('waiting shows the student and the timer; the not-here button waits its turn', (tester) async {
      final server = rideServer(driverRide('driver_arrived', noShowAt: DateTime.now().add(const Duration(minutes: 3))));
      await bootDriver(tester, server);
      await settle(tester, 12);
      expect(find.text('Waiting for the student'), findsOneWidget);
      expect(find.text('Student: Ama'), findsOneWidget);
      expect(find.text('Start trip'), findsOneWidget);
      expect(find.text('Student not here'), findsNothing);
      expect(find.textContaining('You can mark the student as not here at'), findsOneWidget);
    });

    testWidgets('after the wait, not here confirms and says nobody is charged', (tester) async {
      final server = rideServer(driverRide('driver_arrived', noShowAt: DateTime.now().subtract(const Duration(seconds: 5))))
        ..on('POST /driver/rides/$rideId/no-show', body: driverRide('cancelled'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Student not here'));
      await settle(tester);
      expect(find.text("The ride will be cancelled. The student isn't charged and no fee applies."), findsOneWidget);
      await tester.tap(find.text('Yes, not here'));
      await settle(tester);
      expect(server.calls('POST /driver/rides/$rideId/no-show'), hasLength(1));
    });

    testWidgets('too early: the server refuses and the driver is told', (tester) async {
      final server = rideServer(driverRide('driver_arrived', noShowAt: DateTime.now().subtract(const Duration(seconds: 1))))
        ..on('POST /driver/rides/$rideId/no-show', status: 409, body: problem('no_show_too_early', 409));
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Student not here'));
      await settle(tester);
      await tester.tap(find.text('Yes, not here'));
      await settle(tester);
      expect(find.text("It's too early to mark the student as not here."), findsOneWidget);
    });

    testWidgets('the PIN keypad sends exactly four digits', (tester) async {
      final server = rideServer(driverRide('driver_arrived'))..on('POST /driver/rides/$rideId/start', body: driverRide('in_progress'));
      await toKeypad(tester, server);
      expect(find.text("Enter the student's PIN"), findsOneWidget);
      expect(find.text('Ask the student for their PIN. Never accept it by message.'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Start')).onPressed, isNull);
      await typePin(tester, '4827');
      await tester.tap(find.widgetWithText(FilledButton, 'Start'));
      await settle(tester, 20);
      expect((bodyOf(server.calls('POST /driver/rides/$rideId/start').single) as Map)['pin'], '4827');
    });

    testWidgets('a wrong PIN is explained and the boxes clear', (tester) async {
      final server = rideServer(driverRide('driver_arrived'))..on('POST /driver/rides/$rideId/start', status: 422, body: problem('invalid_pin', 422));
      await toKeypad(tester, server);
      await typePin(tester, '1111');
      await tester.tap(find.widgetWithText(FilledButton, 'Start'));
      await settle(tester, 20);
      expect(find.text("That PIN isn't right. Ask the student again."), findsOneWidget);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Start')).onPressed, isNull);
    });

    testWidgets('five wrong tries lock the start and say who to call', (tester) async {
      final server = rideServer(driverRide('driver_arrived'))..on('POST /driver/rides/$rideId/start', status: 423, body: problem('pin_locked', 423));
      await toKeypad(tester, server);
      await typePin(tester, '2222');
      await tester.tap(find.widgetWithText(FilledButton, 'Start'));
      await settle(tester, 20);
      expect(find.text('Too many tries'), findsOneWidget);
      expect(find.text('Call your supervisor.'), findsOneWidget);
    });
  });

  group('trip', () {
    testWidgets('shows the drop-off and navigation, and completes after a confirmation', (tester) async {
      final server = rideServer(driverRide('in_progress'))..on('POST /driver/rides/$rideId/complete', body: driverRide('completed'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      expect(find.text('Trip in progress'), findsOneWidget);
      expect(find.text('Drop-off: Ashaiman China Mall'), findsOneWidget);
      expect(find.text('Navigate to drop-off'), findsOneWidget);
      await tester.tap(find.text('Complete trip'));
      await settle(tester);
      expect(find.text('Only do this at the drop-off.'), findsOneWidget);
      await tester.tap(find.text('Yes, complete'));
      await settle(tester, 20);
      final body = bodyOf(server.calls('POST /driver/rides/$rideId/complete').single) as Map;
      expect(body['location']['lat'], 5.7203);
    });

    testWidgets('with no signal the completion is kept and retried until it lands', (tester) async {
      var calls = 0;
      final server = rideServer(driverRide('in_progress'))
        ..onCall('POST /driver/rides/$rideId/complete', (r) {
          calls++;
          return calls < 3
              ? (status: 503, body: problem('internal', 503), headers: <String, String>{})
              : (status: 200, body: driverRide('completed'), headers: <String, String>{});
        });
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Complete trip'));
      await settle(tester);
      await tester.tap(find.text('Yes, complete'));
      await settle(tester, 12);
      expect(find.text('Waiting for signal to finish your trip'), findsOneWidget);
      expect(find.text('Complete trip'), findsNothing);
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 5));
      }
      expect(calls, greaterThanOrEqualTo(3));
      final bodies = server.calls('POST /driver/rides/$rideId/complete').map((r) => bodyOf(r)).toList();
      expect(bodies.every((b) => (b as Map)['location']['lat'] == 5.7203), isTrue, reason: 'the same completion each time');
    });
  });

  group('after the ride', () {
    testWidgets('completed shows a calm summary and goes back to waiting', (tester) async {
      final server = rideServer(driverRide('in_progress'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      server
        ..on('GET /driver/rides/current', status: 204, body: null)
        ..on('GET /driver/rides', body: {'data': [driverRide('completed')], 'page': {'nextCursor': null, 'hasMore': false}});
      await tester.pump(const Duration(seconds: 5));
      await settle(tester, 12);
      expect(find.text('Trip complete'), findsOneWidget);
      expect(find.text('9.4 km · 14 min'), findsOneWidget);
      await tester.tap(find.text('Back to waiting'));
      await settle(tester, 12);
      expect(find.text('On duty. Waiting for a ride.'), findsOneWidget);
    });

    testWidgets('cancelled says what to do next', (tester) async {
      final server = rideServer(driverRide('assigned'));
      await bootDriver(tester, server);
      await settle(tester, 12);
      server
        ..on('GET /driver/rides/current', status: 204, body: null)
        ..on('GET /driver/rides', body: {'data': [driverRide('cancelled')], 'page': {'nextCursor': null, 'hasMore': false}});
      await tester.pump(const Duration(seconds: 5));
      await settle(tester, 12);
      expect(find.text('Ride cancelled'), findsOneWidget);
      expect(find.textContaining('Return to your waiting position.'), findsOneWidget);
    });
  });

  test('distance helper', () {
    expect(distanceMeters(5.0, 0.0, 5.01, 0.0), closeTo(1112, 5));
  });
}
