import 'package:clock/clock.dart';
import 'package:driver_app/src/core/driver_gaps.dart';
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
  ..on('GET /driver/rides', body: page([]))
  ..on('GET /driver/shifts', body: page([
    {'id': '0190a1b2-0000-7e4f-8a5b-0000000f0001', 'driverId': '0190a1b2-0000-7e4f-8a5b-0000000d0001', 'startsAt': '2026-11-02T07:00:00Z', 'endsAt': '2026-11-02T15:00:00Z', 'status': 'scheduled'},
  ]));

void main() {
  test('a document is valid, expiring in under 30 days, or expired', () {
    withClock(Clock.fixed(DateTime.utc(2026, 11, 2, 23)), () {
      expect(DriverDoc(DriverDocType.insurance, DateTime.utc(2026, 11, 1)).status, DocStatus.expired);
      expect(DriverDoc(DriverDocType.insurance, DateTime.utc(2026, 11, 2)).status, DocStatus.expiring);
      expect(DriverDoc(DriverDocType.insurance, DateTime.utc(2026, 12, 1)).status, DocStatus.expiring);
      expect(DriverDoc(DriverDocType.insurance, DateTime.utc(2026, 12, 2)).status, DocStatus.valid);
    });
  });

  testWidgets("without the contract fields, nothing is invented: no supervisor button, documents say they're checked on duty", (tester) async {
    await withClock(Clock.fixed(DateTime.utc(2026, 11, 2, 12)), () async {
      await bootDriver(tester, base(), size: const Size(390, 2000));
      await settle(tester);
    });
    expect(find.text('Call supervisor'), findsNothing);
    expect(find.text('Documents checked when you go on duty'), findsOneWidget);
    // The shift tile uses the real shifts endpoint.
    expect(find.text('07:00 – 15:00'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('with sample data: an expired document shows a banner, the tile and a call button (dark: $dark)', (tester) async {
      if (dark) {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
      }
      await withClock(Clock.fixed(DateTime.utc(2026, 11, 2, 12)), () async {
        await bootDriver(tester, base(), size: const Size(390, 3000), extra: [driverGapsProvider.overrideWithValue(const SampleGaps())]);
        await settle(tester);
      });
      expect(find.textContaining('Your Insurance expired on'), findsOneWidget);
      expect(find.text('Call supervisor'), findsOneWidget);
      expect(find.text('Expired'), findsWidgets);
      expect(find.text('Documents up to date'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Me lists the documents with their status and when each runs out', (tester) async {
    await withClock(Clock.fixed(DateTime.utc(2026, 11, 2, 12)), () async {
      await bootDriver(tester, base(), extra: [driverGapsProvider.overrideWithValue(const SampleGaps())]);
      tester.view.physicalSize = const Size(390, 2400);
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('Me'));
      await settle(tester);
      await tester.tap(find.text('Documents'));
      await settle(tester);
    });
    expect(find.text('Insurance'), findsOneWidget);
    expect(find.text('Roadworthy certificate'), findsOneWidget);
    expect(find.text('Expiring soon'), findsOneWidget);
    expect(find.text('Valid'), findsNWidgets(2));
    expect(find.text('Contact your supervisor to renew.'), findsOneWidget);
  });

  testWidgets('the documents page says so when the app cannot tell yet', (tester) async {
    await bootDriver(tester, base());
    tester.view.physicalSize = const Size(390, 2400);
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Me'));
    await settle(tester);
    await tester.tap(find.text('Documents'));
    await settle(tester);
    expect(find.text('Your documents will show here soon.'), findsOneWidget);
  });
}
