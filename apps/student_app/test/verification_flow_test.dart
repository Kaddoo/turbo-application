import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/app.dart';
import 'package:student_app/src/core/token_store.dart';
import 'package:student_app/src/features/verification/draft.dart';
import 'package:student_app/src/features/verification/photo_capturer.dart';

import 'support/fake_server.dart';

/// A real 1x1 PNG, so image widgets decode it.
final _png = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

class FakeCapturer implements PhotoCapturer {
  final taken = <DocKind>[];

  @override
  Future<Uint8List?> capture(BuildContext context, DocKind kind) async {
    taken.add(kind);
    return Uint8List.fromList(_png);
  }
}

FakeServer signedInServer({String verification = 'not_submitted', Map<String, Object?>? state}) {
  final server = FakeServer()
    ..on('GET /app-config', body: appConfig())
    ..on('GET /legal', body: legal)
    ..on('POST /auth/refresh', body: tokens(refresh: 'refresh-2'))
    ..on('GET /me', body: student(verification: verification));
  if (state != null) server.on('GET /me/verification', body: state);
  var n = 0;
  server.onCall('POST /uploads', (r) {
    n++;
    return (
      status: 201,
      body: {
        'uploadId': '0190a1b2-0000-7e4f-8a5b-00000000000$n',
        'uploadUrl': 'https://storage.test/u/$n',
        'method': 'PUT',
        'headers': {'x-test': 'yes'},
        'expiresAt': '2026-11-01T10:00:00Z',
      },
      headers: <String, String>{},
    );
  });
  for (var i = 1; i <= 8; i++) {
    server.on('PUT https://storage.test/u/$i', status: 200, body: null);
  }
  return server;
}

Future<void> boot(
  WidgetTester tester,
  FakeServer server, {
  FakeCapturer? capturer,
  MemoryDraftStore? drafts,
  double height = 2600,
}) async {
  tester.view.physicalSize = Size(390, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final http = Dio()..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: server.overrides(
        store: MemoryTokenStore('refresh-1'),
        extra: [
          photoCapturerProvider.overrideWithValue(capturer ?? FakeCapturer()),
          uploadHttpProvider.overrideWithValue(http),
          photoCompressorProvider.overrideWithValue((b) async => b),
          draftStoreProvider.overrideWithValue(drafts ?? MemoryDraftStore()),
        ],
      ),
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> fillDetails(WidgetTester tester) async {
  await tester.enterText(find.widgetWithText(TextField, 'Full name as on your Ghana Card'), 'Ama Mensah');
  await tester.enterText(find.widgetWithText(TextField, 'Ghana Card number'), '1234567890');
  await tester.enterText(find.widgetWithText(TextField, 'Student ID number'), 'CU/2024/0042');
  await tester.pump();
}

void main() {
  testWidgets('a new student sees the capture form, photos arrive, and submit sends the contract body', (tester) async {
    final server = signedInServer();
    server.onCall('POST /me/verification', (r) => (
          status: 201,
          body: {'status': 'pending', 'canResubmit': false},
          headers: <String, String>{},
        ));
    final capturer = FakeCapturer();
    await boot(tester, server, capturer: capturer);

    expect(find.text("Confirm you're a student"), findsOneWidget);
    expect(find.text('Only our verification team sees these. They are deleted after review.'), findsOneWidget);
    expect(find.text('Not taken yet'), findsNWidgets(4));

    await fillDetails(tester);
    expect(find.text('GHA-123456789-0'), findsOneWidget, reason: 'the number is formatted as typed');
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit')).onPressed, isNull);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Take photo').first);
      await tester.pumpAndSettle();
    }
    expect(capturer.taken, DocKind.values);
    expect(find.text('Sent'), findsNWidgets(4));
    expect(server.calls('POST /uploads'), hasLength(4));
    final first = bodyOf(server.calls('POST /uploads').first) as Map;
    expect(first['purpose'], 'ghana_card_front');
    expect(first['contentType'], 'image/jpeg');
    expect(server.calls('PUT https://storage.test/u/1').single.headers['x-test'], 'yes');
    expect(server.calls('PUT https://storage.test/u/1').single.headers['Authorization'], isNull,
        reason: 'the signed URL never gets our token');

    server.on('GET /me', body: student(verification: 'pending'));
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();

    final sent = bodyOf(server.calls('POST /me/verification').single) as Map;
    expect(sent['fullName'], 'Ama Mensah');
    expect(sent['ghanaCardNumber'], 'GHA-123456789-0');
    expect(sent['studentIdNumber'], 'CU/2024/0042');
    expect(sent['ghanaCardFrontUploadId'], endsWith('1'));
    expect(sent['selfieUploadId'], endsWith('4'));
    expect(sent.keys, hasLength(7));
  });

  testWidgets('an upload that fails offers a retry and never blocks the others', (tester) async {
    final server = signedInServer();
    server.on('PUT https://storage.test/u/1', status: 500, body: null);
    await boot(tester, server);
    await tester.tap(find.text('Take photo').first);
    await tester.pumpAndSettle();
    expect(find.text("Didn't send"), findsOneWidget);

    server.on('PUT https://storage.test/u/2', status: 200, body: null);
    await tester.tap(find.text('Try sending again'));
    await tester.pumpAndSettle();
    expect(find.text('Sent'), findsOneWidget);
  });

  testWidgets('a bad Ghana Card number is explained after typing', (tester) async {
    await boot(tester, signedInServer());
    await tester.enterText(find.widgetWithText(TextField, 'Ghana Card number'), '12345');
    await tester.pump();
    expect(find.textContaining('like GHA-123456789-0'), findsWidgets);
  });

  testWidgets('duplicate identity is explained in plain words', (tester) async {
    final server = signedInServer();
    server.on('POST /me/verification', status: 409, body: problem('duplicate_identity', 409));
    await boot(tester, server);
    await fillDetails(tester);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Take photo').first);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();
    expect(find.text('This Ghana Card is already linked to another account. Contact support.'), findsOneWidget);
  });

  testWidgets('what was typed and which photos were sent survive a restart', (tester) async {
    final drafts = MemoryDraftStore();
    final server = signedInServer();
    await boot(tester, server, drafts: drafts);
    await fillDetails(tester);
    await tester.tap(find.text('Take photo').first);
    await tester.pumpAndSettle();
    expect(drafts.value, isNotNull);
    expect(drafts.value, contains('ghanaCardFront'));

    // New app run, same saved draft.
    await tester.pumpWidget(const SizedBox());
    await boot(tester, signedInServer(), drafts: drafts);
    expect(find.text('Ama Mensah'), findsOneWidget);
    expect(find.text('GHA-123456789-0'), findsOneWidget);
    expect(find.text('Sent'), findsOneWidget);
    expect(find.text('Not taken yet'), findsNWidgets(3));
  });

  group('status', () {
    Map<String, Object?> verificationBody(String status, {String? message}) =>
        {'status': status, 'canResubmit': status == 'needs_attention', 'message': ?message};

    testWidgets('pending', (tester) async {
      await boot(tester, signedInServer(verification: 'pending', state: verificationBody('pending')), height: 800);
      expect(find.text("We're checking your documents"), findsOneWidget);
      expect(find.text('This usually takes a day. We\'ll text you.'), findsOneWidget);
    });

    testWidgets('needs attention shows the reviewer message, and Send again opens the form', (tester) async {
      final server = signedInServer(
        verification: 'needs_attention',
        state: verificationBody('needs_attention', message: 'The back of your card is blurry.'),
      );
      await boot(tester, server, height: 800);
      expect(find.text('The back of your card is blurry.'), findsOneWidget);
      await tester.tap(find.text('Send again'));
      await tester.pumpAndSettle();
      expect(find.text("Confirm you're a student"), findsOneWidget);
    });

    testWidgets('rejected shows the reason and no resubmit', (tester) async {
      await boot(
        tester,
        signedInServer(verification: 'rejected', state: verificationBody('rejected', message: 'Names do not match.')),
        height: 800,
      );
      expect(find.text('Names do not match.'), findsOneWidget);
      expect(find.text('Send again'), findsNothing);
    });

    testWidgets('approved shows a quiet check, then Continue goes home', (tester) async {
      final server = signedInServer(verification: 'pending', state: verificationBody('approved'));
      await boot(tester, server, height: 800);
      expect(find.text("You're verified"), findsOneWidget);
      server.on('GET /me', body: student(verification: 'approved'));
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text("You're verified"), findsNothing);
    });

    testWidgets('a failed check says so and can be retried', (tester) async {
      final server = signedInServer(verification: 'pending');
      server.on('GET /me/verification', status: 500, body: problem('internal', 500));
      await boot(tester, server, height: 800);
      expect(find.textContaining("couldn't check"), findsOneWidget);
    });
  });
}
