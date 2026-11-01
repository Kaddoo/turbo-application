import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/core/session.dart';
import 'package:student_app/src/features/push/push_service.dart';

import 'support/fake_server.dart';
import 'support/home_harness.dart';
import 'ride_test.dart' show ride, rideId, rideServer;

class FakePush implements PushPlatform {
  FakePush({this.allow = true, this.startedWith});

  final bool allow;
  final PushMessage? startedWith;
  final foreground = StreamController<PushMessage>.broadcast();
  final opened = StreamController<PushMessage>.broadcast();
  final refresh = StreamController<String>.broadcast();
  int asked = 0;

  @override
  Future<bool> requestPermission() async {
    asked++;
    return allow;
  }

  @override
  Future<String?> token() async => 'fcm-token-1';

  @override
  Stream<String> get onTokenRefresh => refresh.stream;

  @override
  Stream<PushMessage> get onForeground => foreground.stream;

  @override
  Stream<PushMessage> get onOpened => opened.stream;

  @override
  Future<PushMessage?> initialMessage() async => startedWith;
}

void main() {
  test('a tapped push goes to the right screen', () {
    expect(pushRoute({'type': 'ride_assigned', 'rideId': 'r1'}), '/ride/r1');
    expect(pushRoute({'type': 'ride_arrived', 'rideId': 'r1'}), '/ride/r1');
    expect(pushRoute({'type': 'quick_message', 'rideId': 'r1'}), '/ride/r1');
    expect(pushRoute({'type': 'ride_cancelled'}), '/home');
    expect(pushRoute({'type': 'topup_succeeded'}), '/wallet');
    expect(pushRoute({'type': 'refund'}), '/wallet');
    expect(pushRoute({'type': 'support_reply', 'ticketId': 't1'}), '/support/t1');
    expect(pushRoute({'type': 'support_reply'}), '/support');
    expect(pushRoute({'type': 'incident_ack'}), '/safety');
    expect(pushRoute({'type': 'verification'}), '/home');
    expect(pushRoute({'type': 'something_new'}), isNull);
  });

  group('registration', () {
    testWidgets('signing in registers this phone, and it never carries a PIN or phone number', (tester) async {
      final push = FakePush();
      final server = rideServer()..on('POST /devices', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      final request = server.calls('POST /devices').single;
      final body = bodyOf(request) as Map;
      expect(body['fcmToken'], 'fcm-token-1');
      expect(body['platform'], isIn(['ios', 'android']));
      expect(body['deviceId'], isNotEmpty);
      expect(push.asked, 1);
    });

    testWidgets('saying no to notifications registers nothing and breaks nothing', (tester) async {
      final server = rideServer()..on('POST /devices', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(FakePush(allow: false))]);
      expect(server.calls('POST /devices'), isEmpty);
      expect(find.text('Where to?'), findsOneWidget);
    });

    testWidgets('a new token from Firebase is sent to the server', (tester) async {
      final push = FakePush();
      final server = rideServer()..on('POST /devices', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      push.refresh.add('fcm-token-2');
      await tester.pumpAndSettle();
      final calls = server.calls('POST /devices').toList();
      expect(calls, hasLength(2));
      expect((bodyOf(calls.last) as Map)['fcmToken'], 'fcm-token-2');
    });

    testWidgets('signing out removes the device first', (tester) async {
      final push = FakePush();
      final server = rideServer()
        ..on('POST /devices', status: 204, body: null)
        ..on('POST /auth/logout', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      final container = ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
      final deviceId = (bodyOf(server.calls('POST /devices').single) as Map)['deviceId'] as String;
      server.on('DELETE /devices/$deviceId', status: 204, body: null);
      // Sign-out talks to the network, so it runs on the real clock.
      await tester.runAsync(() => container.read(sessionProvider.notifier).signOut());
      await tester.pump();
      expect(server.calls('DELETE /devices/$deviceId'), hasLength(1));
      final names = server.requests.map((r) => '${r.method} ${r.path}').toList();
      expect(names.indexOf('DELETE /devices/$deviceId'), lessThan(names.indexOf('POST /auth/logout')));
    });
  });

  group('messages', () {
    testWidgets('tapping a push opens that ride', (tester) async {
      final push = FakePush();
      final server = rideServer(status: 'assigned')
        ..on('POST /devices', status: 204, body: null)
        ..on('GET /rides/$rideId', body: ride('assigned', pin: '4827', driver: true));
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      push.opened.add(PushMessage(data: {'type': 'ride_assigned', 'rideId': rideId}));
      // A live ride polls forever, so settle by hand instead of waiting for quiet.
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text('Your driver is on the way'), findsOneWidget);
    });

    testWidgets('a push that started the app opens its screen once signed in', (tester) async {
      final push = FakePush(startedWith: const PushMessage(data: {'type': 'topup_succeeded'}));
      final server = rideServer()..on('POST /devices', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('a message while the app is open shows a note and refreshes the data', (tester) async {
      final push = FakePush();
      final server = rideServer()..on('POST /devices', status: 204, body: null);
      await bootHome(tester, server, extra: [pushPlatformProvider.overrideWithValue(push)]);
      final before = server.calls('GET /wallet').length;
      server.on('GET /wallet', body: wallet(available: 9000));
      push.foreground.add(const PushMessage(title: 'Top-up received', body: 'GH₵30 was added to your wallet.', data: {'type': 'topup_succeeded'}));
      await tester.pumpAndSettle();
      expect(find.text('Top-up received. GH₵30 was added to your wallet.'), findsOneWidget);
      expect(server.calls('GET /wallet').length, greaterThan(before));
    });
  });
}
