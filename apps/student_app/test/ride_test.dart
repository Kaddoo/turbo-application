import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/features/safety/sos.dart';

import 'support/fake_server.dart';
import 'support/home_harness.dart';

const rideId = '0190a1b2-0000-7e4f-8a5b-0000000a0001';

Map<String, Object?> ride(
  String status, {
  String? pin,
  bool driver = false,
  Map<String, Object?>? cancellation,
  Map<String, Object?>? payment,
  String? startedAt,
  String? completedAt,
}) =>
    {
      'id': rideId,
      'status': status,
      'pickup': {'point': {'lat': 5.74, 'lng': 0.066}, 'label': 'Main gate', 'pickupPointId': pickupA['id']},
      'dropoff': {'point': {'lat': 5.75, 'lng': 0.07}, 'label': 'Hostel block', 'pickupPointId': pickupB['id']},
      'routeDistanceMeters': 9400,
      'routePolyline': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
      'farePesewas': 3500,
      'pin': pin,
      'pickupEtaSeconds': 240,
      if (driver) 'driver': {'id': '0190a1b2-0000-7e4f-8a5b-0000000d0001', 'firstName': 'Kofi'},
      if (driver) 'vehicle': {'make': 'Toyota', 'model': 'Corolla', 'colour': 'Silver', 'plateNumber': 'GR-4821-24'},
      'payment': payment ?? {'status': 'held', 'heldPesewas': 3500, 'chargedPesewas': 0, 'refundedPesewas': 0},
      'cancellation': cancellation,
      'requestedAt': DateTime.now().toUtc().toIso8601String(),
      'startedAt': startedAt,
      'completedAt': completedAt,
    };

Map<String, Object?> rideList(List<Map<String, Object?>> rides) => {
      'data': rides,
      'page': {'nextCursor': null, 'hasMore': false},
    };

FakeServer rideServer({String status = 'searching'}) {
  final s = homeServer()
    ..on('POST /rides/quote', body: quote())
    ..on('GET /rides', body: rideList([]))
    ..on('POST /rides', status: 201, body: ride('searching'))
    ..on('GET /rides/$rideId', body: ride(status))
    ..on('GET /rides/$rideId/tracking', body: {
      'rideStatus': status,
      'driverLocation': {'point': {'lat': 5.741, 'lng': 0.067}, 'recordedAt': DateTime.now().toUtc().toIso8601String()},
      'etaSeconds': 300,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    })
    ..on('GET /rides/$rideId/messages', body: {'items': []});
  return s;
}

Future<void> bookFromHome(WidgetTester tester) async {
  await tester.tap(find.text('Hostel'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Book for GH₵35.00'));
  await tester.pumpAndSettle();
}

void main() {
  group('booking', () {
    testWidgets('books with an idempotency key and opens the searching screen', (tester) async {
      final server = rideServer();
      await bootHome(tester, server);
      await bookFromHome(tester);
      final request = server.calls('POST /rides').single;
      expect((bodyOf(request) as Map)['quoteId'], '0190a1b2-0000-7e4f-8a5b-0000000000d4');
      expect(request.headers['Idempotency-Key'], isNotEmpty);
      expect(find.text('Finding your driver'), findsOneWidget);
      expect(find.text('Fare is held'), findsOneWidget);
      expect(find.text('GH₵35.00'), findsOneWidget);
      expect(find.text('Pickup: Main gate'), findsOneWidget);
      expect(find.text('Cancel ride'), findsOneWidget);
    });

    testWidgets('a retry after a lost connection reuses the key, so it books once', (tester) async {
      final server = rideServer()..on('POST /rides', status: 503, body: problem('internal', 503));
      await bootHome(tester, server);
      await bookFromHome(tester);
      server.on('POST /rides', status: 201, body: ride('searching'));
      await tester.tap(find.text('Book for GH₵35.00'));
      await tester.pumpAndSettle();
      final calls = server.calls('POST /rides').toList();
      expect(calls, hasLength(2));
      expect(calls[1].headers['Idempotency-Key'], calls[0].headers['Idempotency-Key']);
      expect(find.text('Finding your driver'), findsOneWidget);
    });

    testWidgets('already riding opens the ride that is running', (tester) async {
      final server = rideServer(status: 'assigned')
        ..on('POST /rides', status: 409, body: problem('active_ride_exists', 409))
        ..on('GET /rides', body: rideList([ride('assigned', pin: '4827', driver: true)]));
      // The list is read on the home screen too, so home opens it straight away.
      await bootHome(tester, server);
      expect(find.text('Your driver is on the way'), findsOneWidget);
    });

    testWidgets('a wallet that came up short is explained and the price re-read', (tester) async {
      final server = rideServer()..on('POST /rides', status: 409, body: problem('insufficient_balance', 409));
      await bootHome(tester, server);
      await bookFromHome(tester);
      expect(find.text("Your wallet doesn't have enough for this ride. Top up and try again."), findsOneWidget);
      expect(server.calls('POST /rides/quote').length, 2);
    });
  });

  group('ride screens', () {
    Future<void> open(WidgetTester tester, FakeServer server) async {
      server.on('GET /rides', body: rideList([ride(
        'searching',
      )]));
      await bootHome(tester, server);
    }

    testWidgets('the road from the server is handed to the map', (tester) async {
      final server = rideServer();
      server.on('GET /rides', body: rideList([ride('searching')]));
      final specs = await bootHome(tester, server);
      expect(specs.last.route, '_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    });

    testWidgets('driver assigned: PIN digit by digit, plate, driver and the pickup', (tester) async {
      final server = rideServer(status: 'assigned')
        ..on('GET /rides/$rideId', body: ride('assigned', pin: '4827', driver: true));
      await open(tester, server);
      server.on('GET /rides', body: rideList([ride('assigned', pin: '4827', driver: true)]));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Your start PIN'), findsOneWidget);
      for (final d in ['4', '8', '2', '7']) {
        expect(find.text(d), findsOneWidget);
      }
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Digit 1: 4'), findsOneWidget);
      expect(find.bySemanticsLabel('Digit 4: 7'), findsOneWidget);
      handle.dispose();
      expect(find.text('GR-4821-24'), findsOneWidget);
      expect(find.text('Kofi'), findsOneWidget);
      expect(find.text('Silver Toyota Corolla'), findsOneWidget);
      expect(find.text('Pickup: Main gate'), findsOneWidget);
      expect(find.text('About 5 min away'), findsOneWidget);
    });

    testWidgets('driver assigned lays out in dark mode and at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = rideServer(status: 'assigned')
        ..on('GET /rides/$rideId', body: ride('assigned', pin: '4827', driver: true));
      await open(tester, server);
      server.on('GET /rides', body: rideList([ride('assigned', pin: '4827', driver: true)]));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Your start PIN'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('quick messages are sent, and a message from the driver is shown', (tester) async {
      final server = rideServer(status: 'assigned')
        ..on('GET /rides/$rideId', body: ride('assigned', pin: '4827', driver: true))
        ..on('POST /rides/$rideId/messages', status: 201, body: null)
        ..on('GET /rides/$rideId/messages', body: {
          'items': [
            {'from': 'driver', 'code': 'on_my_way', 'sentAt': DateTime.now().toUtc().toIso8601String()},
          ],
        });
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Kofi: On my way'), findsOneWidget);
      await tester.tap(find.text("I'm here"));
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('POST /rides/$rideId/messages').single) as Map)['code'], 'im_here');
    });

    testWidgets('driver arrived says so clearly', (tester) async {
      final server = rideServer(status: 'driver_arrived')
        ..on('GET /rides/$rideId', body: ride('driver_arrived', pin: '4827', driver: true));
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Your driver has arrived'), findsOneWidget);
    });

    testWidgets('cancelling asks for a reason and sends it', (tester) async {
      final server = rideServer()
        ..on('POST /rides/$rideId/cancel', body: ride('cancelled', cancellation: {
          'by': 'student',
          'reasonCode': 'student_changed_mind',
          'cancelledAt': DateTime.now().toUtc().toIso8601String(),
        }, payment: {'status': 'released', 'heldPesewas': 0, 'chargedPesewas': 0, 'refundedPesewas': 0}));
      await open(tester, server);
      await tester.tap(find.text('Cancel ride'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel this ride?'), findsOneWidget);
      expect(find.text("It's free to cancel before you're in the car."), findsOneWidget);
      await tester.tap(find.text('I changed my mind'));
      await tester.pump();
      server.on('GET /rides/$rideId', body: ride('cancelled', cancellation: {
        'by': 'student',
        'reasonCode': 'student_changed_mind',
        'cancelledAt': DateTime.now().toUtc().toIso8601String(),
      }, payment: {'status': 'released', 'heldPesewas': 0, 'chargedPesewas': 0, 'refundedPesewas': 0}));
      await tester.tap(find.widgetWithText(FilledButton, 'Cancel ride').last);
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('POST /rides/$rideId/cancel').single) as Map)['reasonCode'], 'student_changed_mind');
      expect(find.text('You cancelled this ride'), findsOneWidget);
      expect(find.text("You haven't been charged."), findsOneWidget);
    });

    testWidgets('in trip: fare locked, SOS, share, no cancel', (tester) async {
      final server = rideServer(status: 'in_progress')
        ..on('GET /rides/$rideId', body: ride('in_progress', driver: true, startedAt: '2026-10-31T10:00:00Z'));
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('On your way'), findsOneWidget);
      expect(find.text('Fare locked at GH₵35.00'), findsOneWidget);
      expect(find.text('Hold for SOS'), findsOneWidget);
      expect(find.text('Share trip'), findsOneWidget);
      expect(find.text('Cancel ride'), findsNothing);
      expect(find.text('Need to stop the ride? Contact support from Safety.'), findsOneWidget);
    });

    Future<void> inTrip(WidgetTester tester, FakeServer server) async {
      server.on('GET /rides/$rideId', body: ride('in_progress', driver: true, startedAt: '2026-10-31T10:00:00Z'));
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }

    testWidgets('SOS needs a full three-second hold; letting go sooner sends nothing', (tester) async {
      final server = rideServer(status: 'in_progress')..on('POST /safety/sos', status: 201, body: {
            'id': '0190a1b2-0000-7e4f-8a5b-0000000b0001',
            'type': 'sos',
            'status': 'open',
            'createdAt': DateTime.now().toUtc().toIso8601String(),
          });
      await inTrip(tester, server);
      final gesture = await tester.startGesture(tester.getCenter(find.text('Hold for SOS')));
      await tester.pump(const Duration(seconds: 1));
      await gesture.up();
      await tester.pump(const Duration(seconds: 3));
      expect(server.calls('POST /safety/sos'), isEmpty);

      final hold = await tester.startGesture(tester.getCenter(find.text('Hold for SOS')));
      await tester.pump(); // the animation clock starts on the first frame
      await tester.pump(const Duration(seconds: 3, milliseconds: 200));
      await hold.up();
      await tester.pumpAndSettle();
      final body = bodyOf(server.calls('POST /safety/sos').single) as Map;
      expect(body['rideId'], rideId);
      expect(body['location']['lat'], 5.7405);
      expect(find.text('Help has been alerted'), findsOneWidget);
    });

    testWidgets('if SOS cannot be sent, the emergency number is offered at once', (tester) async {
      final server = rideServer(status: 'in_progress')..on('POST /safety/sos', status: 503, body: problem('internal', 503));
      await inTrip(tester, server);
      final hold = await tester.startGesture(tester.getCenter(find.text('Hold for SOS')));
      await tester.pump(); // the animation clock starts on the first frame
      await tester.pump(const Duration(seconds: 3, milliseconds: 200));
      await hold.up();
      await tester.pumpAndSettle();
      expect(find.text("We couldn't send the alert"), findsOneWidget);
      expect(find.text('Call $emergencyNumber'), findsOneWidget);
    });

    testWidgets('done: fare, distance and time, receipt, and a rating that is sent', (tester) async {
      final server = rideServer(status: 'completed')
        ..on('GET /rides/$rideId', body: ride('completed', driver: true, startedAt: '2026-10-31T10:00:00Z', completedAt: '2026-10-31T10:14:00Z',
            payment: {'status': 'charged', 'heldPesewas': 0, 'chargedPesewas': 3500, 'refundedPesewas': 0}))
        ..on('POST /rides/$rideId/rating', status: 204, body: null)
        ..on('GET /rides/$rideId/receipt', body: {
          'rideId': rideId,
          'receiptNumber': 'R-0001',
          'issuedAt': '2026-10-31T10:14:00Z',
          'lines': [{'label': 'Fare', 'amountPesewas': 3500}],
          'totalPesewas': 3500,
        });
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text("You've arrived"), findsOneWidget);
      expect(find.text('GH₵35.00'), findsOneWidget);
      expect(find.text('9.4 km · 14 min'), findsOneWidget);
      expect(find.text('How was your ride with Kofi?'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Send rating')).onPressed, isNull);
      await tester.tap(find.bySemanticsLabel('4'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Send rating'));
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('POST /rides/$rideId/rating').single) as Map)['stars'], 4);
      expect(find.text('Thanks. Your rating was sent.'), findsOneWidget);

      await tester.tap(find.text('View receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Receipt R-0001'), findsOneWidget);
    });

    for (final c in [
      ('no_driver_available', 'system', "We couldn't find a driver", 'Try again'),
      ('driver_unavailable', 'driver', "Your driver couldn't make it", 'Back to home'),
      ('rider_no_show', 'driver', "The driver couldn't find you", 'Back to home'),
      ('service_issue', 'admin', 'We had to cancel this ride', 'Back to home'),
    ]) {
      testWidgets('cancelled (${c.$1}) explains and offers the right next step', (tester) async {
        final cancelled = ride('cancelled', cancellation: {
          'by': c.$2,
          'reasonCode': c.$1,
          'cancelledAt': DateTime.now().toUtc().toIso8601String(),
        }, payment: {'status': 'released', 'heldPesewas': 0, 'chargedPesewas': 0, 'refundedPesewas': 0});
        final server = rideServer(status: 'cancelled')..on('GET /rides/$rideId', body: cancelled);
        await open(tester, server);
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        expect(find.text(c.$3), findsOneWidget);
        expect(find.text("You haven't been charged."), findsOneWidget);
        expect(find.text(c.$4), findsWidgets);
      });
    }

    testWidgets('a refund shows the exact amount put back', (tester) async {
      final server = rideServer(status: 'cancelled')
        ..on('GET /rides/$rideId', body: ride('cancelled', cancellation: {
          'by': 'admin',
          'reasonCode': 'admin_decision',
          'cancelledAt': DateTime.now().toUtc().toIso8601String(),
        }, payment: {'status': 'refunded', 'heldPesewas': 0, 'chargedPesewas': 3500, 'refundedPesewas': 3500}));
      await open(tester, server);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('GH₵35.00 was put back in your wallet.'), findsOneWidget);
    });
  });
}
