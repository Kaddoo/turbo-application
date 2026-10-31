import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/app.dart';
import 'package:student_app/src/core/token_store.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/fake_server.dart';

Future<void> boot(WidgetTester tester, FakeServer server, {String version = '1.0.0', MemoryTokenStore? store}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: server.overrides(version: version, store: store),
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

FakeServer baseServer() => FakeServer()
  ..on('GET /app-config', body: appConfig())
  ..on('GET /legal', body: legal);

void main() {
  testWidgets('an old version sees only the update screen', (tester) async {
    final server = baseServer()..on('GET /app-config', body: appConfig(ios: '2.0.0'));
    await boot(tester, server);
    expect(find.text('Please update the app'), findsOneWidget);
    expect(find.textContaining('too old'), findsOneWidget);
    expect(find.byType(TurboButton), findsNothing);
  });

  testWidgets('maintenance shows the server message and can be rechecked', (tester) async {
    final server = baseServer()..on('GET /app-config', body: appConfig(maintenance: true));
    await boot(tester, server);
    expect(find.text('Back at noon.'), findsOneWidget);
    server.on('GET /app-config', body: appConfig());
    await tester.tap(find.text('Check again'));
    await tester.pumpAndSettle();
    expect(find.text('Campus rides, paid from your wallet'), findsOneWidget);
  });

  testWidgets('a 426 from the server blocks like an old version', (tester) async {
    final server = baseServer()..on('GET /app-config', status: 426, body: problem('upgrade_required', 426));
    await boot(tester, server);
    expect(find.text('Please update the app'), findsOneWidget);
  });

  testWidgets('an offline app-config check does not block sign-in', (tester) async {
    final server = FakeServer(); // no routes: every call 404s like an unreachable server
    await boot(tester, server);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('signed out: welcome, phone, then the code screen', (tester) async {
    final server = baseServer()
      ..on('POST /auth/otp/request', status: 202, body: {'expiresInSeconds': 300, 'resendInSeconds': 30});
    await boot(tester, server);
    expect(find.text('For Central University students at Miotso'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your phone number'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '024 123 4567');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();

    final body = server.lastBody('POST /auth/otp/request') as Map;
    expect(body['phone'], '+233241234567');
    expect(body['role'], 'student');
    expect(find.text('Enter your code'), findsOneWidget);
    expect(find.textContaining('+233 24 123 4567'), findsOneWidget);
    expect(find.textContaining('Send a new code in'), findsOneWidget);
  });

  testWidgets('a short number is explained, not sent', (tester) async {
    final server = baseServer();
    await boot(tester, server);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '12345');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.textContaining('9-digit number'), findsOneWidget);
    expect(server.calls('POST /auth/otp/request'), isEmpty);
  });

  testWidgets('rate limited codes show the wait from Retry-After', (tester) async {
    final server = baseServer()
      ..on('POST /auth/otp/request', status: 429, body: problem('rate_limited', 429), headers: {'retry-after': '45'});
    await boot(tester, server);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '241234567');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.textContaining('45 s'), findsOneWidget);
  });

  Future<void> toCodeScreen(WidgetTester tester, FakeServer server) async {
    server.on('POST /auth/otp/request', status: 202, body: {'expiresInSeconds': 300, 'resendInSeconds': 30});
    await boot(tester, server);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '241234567');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
  }

  testWidgets('a wrong code is explained and the boxes clear', (tester) async {
    final server = baseServer()..on('POST /auth/otp/verify', status: 400, body: problem('otp_invalid', 400));
    await toCodeScreen(tester, server);
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();
    expect(find.textContaining("isn't right"), findsOneWidget);
    final boxes = tester.widgetList<TextField>(find.byType(TextField)).map((f) => f.controller!.text).join();
    expect(boxes, isEmpty);
  });

  testWidgets('first sign-in: terms are shown, then the same code is sent with the versions', (tester) async {
    var verifyCalls = 0;
    final server = baseServer()
      ..onCall('POST /auth/otp/verify', (r) {
        verifyCalls++;
        final body = bodyOf(r) as Map;
        return body['acceptedTermsVersion'] == null
            ? (status: 403, body: problem('terms_not_accepted', 403), headers: <String, String>{})
            : (status: 200, body: tokens(), headers: <String, String>{});
      })
      ..on('GET /me', body: student());
    final store = MemoryTokenStore();
    await toCodeScreen(tester, server);
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    expect(find.text('Before you start'), findsOneWidget);
    expect(find.text('Why we need your location'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Why we need your camera'), 200);
    expect(find.text('Why we need your camera'), findsOneWidget);

    await tester.tap(find.text('I agree'));
    await tester.pumpAndSettle();

    final second = bodyOf(server.calls('POST /auth/otp/verify').last) as Map;
    expect(second['acceptedTermsVersion'], '2026-10');
    expect(second['acceptedPrivacyVersion'], '2026-10');
    expect(second['code'], '123456');
    expect(second['clientType'], 'mobile');
    expect(verifyCalls, 2);
    expect(store, isNotNull);
  });

  testWidgets('signing in stores the refresh token and lands on home when approved', (tester) async {
    final server = baseServer()
      ..on('POST /auth/otp/verify', body: tokens())
      ..on('GET /me', body: student());
    final store = MemoryTokenStore();
    server.on('POST /auth/otp/request', status: 202, body: {'expiresInSeconds': 300, 'resendInSeconds': 30});
    await boot(tester, server, store: store);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '241234567');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    expect(await store.readRefreshToken(), 'refresh-1');
    expect(find.text('Enter your code'), findsNothing);
    expect(server.calls('GET /me'), isNotEmpty);
    expect((server.calls('GET /me').first.headers['Authorization']), 'Bearer access-1');
  });

  testWidgets('a saved session restores on start and goes to the right screen', (tester) async {
    final server = baseServer()
      ..on('POST /auth/refresh', body: tokens(refresh: 'refresh-2'))
      ..on('GET /me', body: student(verification: 'pending'));
    final store = MemoryTokenStore('refresh-1');
    await boot(tester, server, store: store);
    expect((server.lastBody('POST /auth/refresh') as Map)['refreshToken'], 'refresh-1');
    expect(await store.readRefreshToken(), 'refresh-2', reason: 'refresh tokens rotate');
    expect(find.text('Campus rides, paid from your wallet'), findsNothing);
  });

  testWidgets('a revoked saved session returns to welcome and clears storage', (tester) async {
    final server = baseServer()..on('POST /auth/refresh', status: 401, body: problem('unauthenticated', 401));
    final store = MemoryTokenStore('refresh-1');
    await boot(tester, server, store: store);
    expect(find.text('Campus rides, paid from your wallet'), findsOneWidget);
    expect(await store.readRefreshToken(), isNull);
  });

  testWidgets('no signal on start keeps the session and offers retry', (tester) async {
    final server = baseServer()..on('POST /auth/refresh', status: 503, body: problem('service_unavailable', 503));
    final store = MemoryTokenStore('refresh-1');
    await boot(tester, server, store: store);
    expect(find.text('Try again'), findsOneWidget);
    expect(await store.readRefreshToken(), 'refresh-1', reason: 'a bad signal must not sign anyone out');
  });
}
