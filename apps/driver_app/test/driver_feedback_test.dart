import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart' show TurboKeypad;
import 'package:flutter/material.dart';

import 'driver_ride_test.dart' show driverRide, rideId, rideServer, settle;
import 'support/fake_server.dart';
import 'support/harness.dart';

/// What the phone was told to do: haptics and system sounds, in order.
List<String> record(WidgetTester tester) {
  final events = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'HapticFeedback.vibrate') events.add('haptic:${call.arguments}');
    if (call.method == 'SystemSound.play') events.add('sound:${call.arguments}');
    return null;
  });
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
  return events;
}

// Android adds its own click to every tap; the grammar here is the iOS one.
final iosOnly = TargetPlatformVariant.only(TargetPlatform.iOS);

void main() {
  group('event feedback', () {
    testWidgets('a new assignment buzzes and sounds once', (tester) async {
      final events = record(tester);
      await bootDriver(tester, rideServer(driverRide('assigned', acknowledged: false)));
      await settle(tester, 12);
      expect(events.where((e) => e == 'sound:SystemSoundType.alert'), hasLength(1));
      expect(events, contains('haptic:HapticFeedbackType.mediumImpact'));
    }, variant: iosOnly);

    testWidgets('accepting is one medium buzz', (tester) async {
      final server = rideServer(driverRide('assigned', acknowledged: false))
        ..on('POST /driver/rides/$rideId/ack', body: driverRide('assigned'));
      final events = record(tester);
      await bootDriver(tester, server);
      await settle(tester, 12);
      events.clear();
      await tester.tap(find.text('Accept'));
      await settle(tester, 20);
      expect(events.where((e) => e.startsWith('haptic')), ['haptic:HapticFeedbackType.mediumImpact']);
    }, variant: iosOnly);

    testWidgets('ten seconds before the offer runs out there is one more sound, never a loop', (tester) async {
      final events = record(tester);
      await bootDriver(tester, rideServer(driverRide('assigned', acknowledged: false, assignedAt: DateTime.now().subtract(const Duration(seconds: 30)))));
      await settle(tester, 12);
      events.clear();
      await tester.pump(const Duration(seconds: 20));
      await tester.pump(const Duration(seconds: 5));
      expect(events.where((e) => e == 'sound:SystemSoundType.alert'), hasLength(1));
    }, variant: iosOnly);

    testWidgets('arriving is one light buzz', (tester) async {
      final server = rideServer(driverRide('assigned'))..on('POST /driver/rides/$rideId/arrived', body: driverRide('driver_arrived'));
      final events = record(tester);
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text("I've arrived"));
      await settle(tester, 20);
      expect(events.where((e) => e.startsWith('haptic')), ['haptic:HapticFeedbackType.lightImpact']);
    }, variant: iosOnly);

    Future<void> enterPin(WidgetTester tester, FakeServer server) async {
      await bootDriver(tester, server);
      await settle(tester, 12);
      await tester.tap(find.text('Start trip'));
      await settle(tester);
      for (final d in '4827'.split('')) {
        await tester.tap(find.descendant(of: find.byType(TurboKeypad), matching: find.text(d)));
        await tester.pump();
      }
    }

    testWidgets('a right PIN is a light buzz and a click', (tester) async {
      final server = rideServer(driverRide('driver_arrived'))..on('POST /driver/rides/$rideId/start', body: driverRide('in_progress'));
      final events = record(tester);
      await enterPin(tester, server);
      events.clear();
      await tester.tap(find.widgetWithText(FilledButton, 'Start'));
      await settle(tester, 20);
      expect(events, containsAll(['haptic:HapticFeedbackType.lightImpact', 'sound:SystemSoundType.click']));
    }, variant: iosOnly);

    testWidgets('a wrong PIN is a heavy buzz and no sound', (tester) async {
      final server = rideServer(driverRide('driver_arrived'))..on('POST /driver/rides/$rideId/start', status: 422, body: problem('invalid_pin', 422));
      final events = record(tester);
      await enterPin(tester, server);
      events.clear();
      await tester.tap(find.widgetWithText(FilledButton, 'Start'));
      await settle(tester, 20);
      expect(events, ['haptic:HapticFeedbackType.heavyImpact']);
    }, variant: iosOnly);

    testWidgets('completing the trip is one heavy buzz', (tester) async {
      final server = rideServer(driverRide('in_progress'))..on('POST /driver/rides/$rideId/complete', body: driverRide('completed'));
      final events = record(tester);
      await bootDriver(tester, server);
      await settle(tester, 12);
      events.clear();
      await tester.tap(find.text('Complete trip'));
      await settle(tester);
      await tester.tap(find.text('Yes, complete'));
      await settle(tester, 20);
      expect(events.where((e) => e.startsWith('haptic')), ['haptic:HapticFeedbackType.heavyImpact']);
    }, variant: iosOnly);

    testWidgets('going offline is a medium buzz', (tester) async {
      final events = record(tester);
      await bootDriver(tester, driverServer(onDuty: true), online: false);
      await settle(tester, 6);
      expect(events, contains('haptic:HapticFeedbackType.mediumImpact'));
    }, variant: iosOnly);
  });
}
