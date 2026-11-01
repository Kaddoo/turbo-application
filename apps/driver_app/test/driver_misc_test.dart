import 'package:driver_app/src/features/push/push_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_server.dart';
import 'support/harness.dart';

Future<void> settle(WidgetTester tester, [int times = 8]) async {
  for (var i = 0; i < times; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

Map<String, Object?> page(List<Object?> items) => {'data': items, 'page': {'nextCursor': null, 'hasMore': false}};

FakeServer base() => driverServer()
  ..on('GET /driver/rides/current', status: 204, body: null)
  ..on('GET /driver/rides', body: page([]));

Future<void> openMe(WidgetTester tester, FakeServer server) async {
  await bootDriver(tester, server);
  // A tall phone, so every row of Me sits above the floating bar.
  tester.view.physicalSize = const Size(390, 1800);
  addTearDown(tester.view.reset);
  await settle(tester);
  await tester.tap(find.bySemanticsLabel('Me'));
  await settle(tester);
}

void main() {
  test('a tapped push goes to the right screen', () {
    expect(pushRoute({'type': 'ride_offer'}), '/home');
    expect(pushRoute({'type': 'ride_cancelled_driver'}), '/home');
    expect(pushRoute({'type': 'support_reply', 'ticketId': 't1'}), '/support/t1');
    expect(pushRoute({'type': 'document_expiring'}), '/me');
    expect(pushRoute({'type': 'unknown'}), isNull);
  });

  group('Help and records', () {
    testWidgets('help tab: SOS first, then topics to report', (tester) async {
      await bootDriver(tester, base());
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('Help'));
      await settle(tester);
      expect(find.text('Hold for SOS'), findsOneWidget);
      expect(find.text('Report an issue'), findsOneWidget);
      for (final topic in ['Vehicle', 'Student behaviour', 'App problem', 'Safety']) {
        expect(find.text(topic), findsOneWidget);
      }
    });

    testWidgets('records: the four views are one control, in dark mode and at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = base()
        ..on('GET /driver/shifts', body: page([]))
        ..on('GET /driver/attendance', body: page([]));
      await bootDriver(tester, server);
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('Trips'));
      await settle(tester);
      expect(find.text('Records'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Shifts'));
      await settle(tester);
      expect(find.text('No shifts scheduled. Your supervisor sets these.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Me', () {
    testWidgets('shows the driver, the vehicle and the rows for records', (tester) async {
      await openMe(tester, base());
      expect(find.text('Kofi Mensah'), findsOneWidget);
      expect(find.text('+233 20 000 0001'), findsOneWidget);
      expect(find.text('GR-4821-24'), findsOneWidget);
      expect(find.text('Shifts'), findsOneWidget);
      expect(find.text('Salary history'), findsOneWidget);
      // Drivers cannot delete their account in the app.
      expect(find.textContaining('Delete'), findsNothing);
    });

    testWidgets('trips: empty then a list', (tester) async {
      final server = base();
      await bootDriver(tester, server);
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('Trips'));
      await settle(tester);
      expect(find.text('No trips yet.'), findsOneWidget);
    });

    testWidgets('shifts: empty teaches who sets them', (tester) async {
      final server = base()..on('GET /driver/shifts', body: page([]));
      await openMe(tester, server);
      await tester.tap(find.text('Shifts'));
      await settle(tester);
      expect(find.text('No shifts scheduled. Your supervisor sets these.'), findsOneWidget);
    });

    testWidgets('shifts: a scheduled shift with its times', (tester) async {
      final server = base()
        ..on('GET /driver/shifts', body: page([
          {'id': '0190a1b2-0000-7e4f-8a5b-0000000f0001', 'driverId': '0190a1b2-0000-7e4f-8a5b-0000000d0001', 'startsAt': '2026-11-02T06:00:00Z', 'endsAt': '2026-11-02T14:00:00Z', 'status': 'scheduled'},
        ]));
      await openMe(tester, server);
      await tester.tap(find.text('Shifts'));
      await settle(tester);
      expect(find.text('06:00 – 14:00'), findsOneWidget);
      expect(find.text('Scheduled'), findsOneWidget);
    });

    testWidgets('attendance shows times, minutes, a correction note and a way to ask', (tester) async {
      final server = base()
        ..on('GET /driver/attendance', body: page([
          {
            'id': '0190a1b2-0000-7e4f-8a5b-0000000f0002',
            'driverId': '0190a1b2-0000-7e4f-8a5b-0000000d0001',
            'date': '2026-11-02',
            'clockInAt': '2026-11-02T06:02:00Z',
            'clockOutAt': '2026-11-02T14:00:00Z',
            'minutesWorked': 478,
            'status': 'corrected',
            'correctionNote': 'Phone died',
          },
        ]));
      await openMe(tester, server);
      await tester.tap(find.text('Attendance'));
      await settle(tester);
      expect(find.text('In 06:02'), findsOneWidget);
      expect(find.text('478 min worked'), findsOneWidget);
      expect(find.text('Corrected by staff: Phone died'), findsOneWidget);
      expect(find.text('Think something is wrong?'), findsOneWidget);
    });

    testWidgets('salary is a record with the amount, and says payment is outside the app', (tester) async {
      final server = base()
        ..on('GET /driver/salary-payments', body: page([
          {
            'id': '0190a1b2-0000-7e4f-8a5b-0000000f0003',
            'driverId': '0190a1b2-0000-7e4f-8a5b-0000000d0001',
            'periodStart': '2026-10-01',
            'periodEnd': '2026-10-31',
            'amountPesewas': 250000,
            'method': 'bank_transfer',
            'reference': 'BT-77',
            'paidAt': '2026-11-01T09:00:00Z',
          },
        ]));
      await openMe(tester, server);
      await tester.tap(find.text('Salary history'));
      await settle(tester);
      expect(find.text('GH₵2,500.00'), findsOneWidget);
      expect(find.text('Reference BT-77'), findsOneWidget);
      expect(find.textContaining('Payment is made by your employer outside the app.'), findsOneWidget);
    });

    testWidgets('a failed list offers to try again', (tester) async {
      final server = base()..on('GET /driver/shifts', status: 503, body: problem('internal', 503));
      await openMe(tester, server);
      await tester.tap(find.text('Shifts'));
      await settle(tester);
      // Reads are retried twice with a short wait before the error shows.
      await tester.pump(const Duration(seconds: 3));
      await settle(tester);
      expect(find.textContaining("couldn't load this"), findsOneWidget);
    });
  });

  group('support', () {
    testWidgets('a driver reports an issue with a topic and a message', (tester) async {
      final server = base()
        ..on('GET /support/tickets', body: page([]))
        ..on('POST /support/tickets', status: 201, body: {
          'id': '0190a1b2-0000-7e4f-8a5b-0000000e0001',
          'category': 'vehicle',
          'status': 'open',
          'subject': 'Vehicle',
          'createdAt': '2026-11-01T10:00:00Z',
          'updatedAt': '2026-11-01T10:00:00Z',
          'messages': [],
        });
      await openMe(tester, server);
      await tester.tap(find.text('Help and support'));
      await settle(tester);
      await tester.tap(find.text('Report an issue').last);
      await settle(tester);
      await tester.tap(find.text('Vehicle'));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, 'The left tyre is soft.');
      await tester.tap(find.widgetWithText(FilledButton, 'Send'));
      await settle(tester);
      final body = bodyOf(server.calls('POST /support/tickets').single) as Map;
      expect(body['category'], 'vehicle');
      expect(body['message'], 'The left tyre is soft.');
    });
  });
}
