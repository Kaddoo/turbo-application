import 'package:flutter_test/flutter_test.dart';

import 'driver_ride_test.dart' show driverRide, rideServer, settle;
import 'support/harness.dart';

void main() {
  group('screen stays on', () {
    for (final (name, status) in [('on the way to the pickup', 'assigned'), ('at the pickup', 'driver_arrived'), ('on the trip', 'in_progress')]) {
      testWidgets(name, (tester) async {
        final calls = <bool>[];
        await bootDriver(tester, rideServer(driverRide(status)), awake: (awake) async => calls.add(awake));
        await settle(tester, 12);
        expect(calls, [true]);
      });
    }

    testWidgets('not while only an offer is showing', (tester) async {
      final calls = <bool>[];
      await bootDriver(tester, rideServer(driverRide('assigned', acknowledged: false)), awake: (awake) async => calls.add(awake));
      await settle(tester, 12);
      expect(calls, isEmpty);
    });

    testWidgets('let go when the ride is over', (tester) async {
      final calls = <bool>[];
      final server = rideServer(driverRide('in_progress'));
      await bootDriver(tester, server, awake: (awake) async => calls.add(awake));
      await settle(tester, 12);
      server
        ..on('GET /driver/rides/current', status: 204, body: null)
        ..on('GET /driver/rides', body: {'data': [driverRide('completed')], 'page': {'nextCursor': null, 'hasMore': false}});
      await tester.pump(const Duration(seconds: 5));
      await settle(tester, 12);
      expect(calls, [true, false]);
    });
  });
}
