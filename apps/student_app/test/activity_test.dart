import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
