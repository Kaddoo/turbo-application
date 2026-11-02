import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'ride_test.dart' show ride, rideList;
import 'support/home_harness.dart';

void main() {
  group('activity', () {
    testWidgets('lists rides and the chips filter them', (tester) async {
      final done = ride('completed')..['dropoff'] = {'point': {'lat': 5.75, 'lng': 0.07}, 'label': 'Library'};
      final gone = ride('cancelled')..['dropoff'] = {'point': {'lat': 5.75, 'lng': 0.07}, 'label': 'Hostel C'};
      final server = homeServer()..on('GET /rides', body: rideList([done, gone]));
      await bootHome(tester, server);
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Hostel C'), findsOneWidget);

      await tester.tap(find.widgetWithText(InkWell, 'Completed').first);
      await tester.pumpAndSettle();
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Hostel C'), findsNothing);
    });

    testWidgets('each ride row has a taxi picture, in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = homeServer()..on('GET /rides', body: rideList([ride('completed'), ride('cancelled')]));
      await bootHome(tester, server, size: const Size(390, 1800));
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.byType(TurboArtImage), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no rides yet: a picture, the words, and a Book a ride button that goes home', (tester) async {
      final server = homeServer()..on('GET /rides', body: rideList([]));
      await bootHome(tester, server);
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('Your rides will appear here.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Book a ride'));
      await tester.pumpAndSettle();
      expect(find.text('Where to?'), findsOneWidget);
    });
  });
}
