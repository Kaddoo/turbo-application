import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/fake_server.dart';
import 'support/home_harness.dart';

Map<String, Object?> contact(int n, String name) => {
      'id': '0190a1b2-0000-7e4f-8a5b-0000000c000$n',
      'name': name,
      'phone': '+23324111000$n',
      'relationship': null,
    };

FakeServer base() => homeServer()
  ..on('GET /rides', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}})
  ..on('GET /me/trusted-contacts', body: {'data': [contact(1, 'Akosua Mensah')]});

Map<String, Object?> ticket(String status, {List<Map<String, Object?>> messages = const []}) => {
      'id': '0190a1b2-0000-7e4f-8a5b-0000000e0001',
      'category': 'wrong_charge',
      'status': status,
      'subject': 'Charged twice',
      'createdAt': '2026-10-31T10:00:00Z',
      'updatedAt': '2026-10-31T11:00:00Z',
      'messages': messages,
    };

void main() {
  group('safety', () {
    Future<void> openSafety(WidgetTester tester, FakeServer server) async {
      await bootHome(tester, server);
      await tester.tap(find.byTooltip('Safety'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows SOS, the emergency number, contacts and how it works', (tester) async {
      await openSafety(tester, base());
      expect(find.text('Hold for SOS'), findsOneWidget);
      expect(find.text('Akosua Mensah'), findsOneWidget);
      expect(find.text('+233 24 111 0001'), findsOneWidget);
      expect(find.text('1 of 3'), findsOneWidget);
      expect(find.text('Call 112'), findsOneWidget);
      expect(find.text('How SOS works'), findsOneWidget);
    });

    testWidgets('with a campus security number: a call tile next to 112, in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = base()..on('GET /app-config', body: appConfig(securityPhone: '+233241230000'));
      await openSafety(tester, server);
      await tester.scrollUntilVisible(find.text('Campus security'), 300, scrollable: find.byType(Scrollable).first);
      expect(find.text('Campus security'), findsOneWidget);
      expect(find.text('+233 24 123 0000'), findsOneWidget);
      expect(find.text('Emergency'), findsOneWidget);
      expect(find.text('112'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('without a number the screen offers 112 only', (tester) async {
      await openSafety(tester, base());
      expect(find.text('Campus security'), findsNothing);
      expect(find.text('Call 112'), findsOneWidget);
    });

    testWidgets('share trip: pick contacts, send, in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = base()
        ..on('POST /rides/0190a1b2-0000-7e4f-8a5b-000000000001/share', status: 201, body: {
          'shareUrl': 'https://turbo.test/t/abc',
          'expiresAt': '2026-11-02T10:00:00Z',
        });
      await bootHome(tester, server);
      final ctx = tester.element(find.byType(Scaffold).first);
      GoRouter.of(ctx).go('/ride/0190a1b2-0000-7e4f-8a5b-000000000001/share');
      await tester.pumpAndSettle();
      expect(find.text('Send link'), findsOneWidget);
      // Contacts are chips, and the preview sits on a photo.
      expect(find.widgetWithText(TurboChip, 'Akosua Mensah'), findsOneWidget);
      expect(find.byType(PhotoCard), findsOneWidget);
      await tester.tap(find.text('Akosua Mensah'));
      await tester.pumpAndSettle();
      expect(find.text('Send to 1 contact'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Send to 1 contact'));
      await tester.pumpAndSettle();
      expect(find.text('Link sent'), findsOneWidget);
    });

    testWidgets('adds a contact with the number in +233 form', (tester) async {
      final server = base()..on('POST /me/trusted-contacts', status: 201, body: contact(2, 'Yaw Boateng'));
      await openSafety(tester, server);
      await tester.tap(find.text('Add a contact'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Yaw Boateng');
      await tester.enterText(fields.at(1), '020 444 1187');
      await tester.tap(find.text('Save contact'));
      await tester.pumpAndSettle();
      final body = bodyOf(server.calls('POST /me/trusted-contacts').single) as Map;
      expect(body['name'], 'Yaw Boateng');
      expect(body['phone'], '+233204441187');
    });

    testWidgets('a bad number is explained and not sent', (tester) async {
      final server = base();
      await openSafety(tester, server);
      await tester.tap(find.text('Add a contact'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Yaw');
      await tester.enterText(find.byType(TextField).at(1), '123');
      await tester.tap(find.text('Save contact'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Enter a Ghana number'), findsOneWidget);
      expect(server.calls('POST /me/trusted-contacts'), isEmpty);
    });

    testWidgets('three contacts is the limit', (tester) async {
      final server = base()..on('GET /me/trusted-contacts', body: {'data': [contact(1, 'A'), contact(2, 'B'), contact(3, 'C')]});
      await openSafety(tester, server);
      expect(find.text('Add a contact'), findsNothing);
      expect(find.text('You can add up to 3 contacts.'), findsOneWidget);
    });

    testWidgets('removing a contact asks first', (tester) async {
      final server = base()..on('DELETE /me/trusted-contacts/0190a1b2-0000-7e4f-8a5b-0000000c0001', status: 204, body: null);
      await openSafety(tester, server);
      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove this contact?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(server.calls('DELETE /me/trusted-contacts/0190a1b2-0000-7e4f-8a5b-0000000c0001'), hasLength(1));
    });
  });

  group('support', () {
    Future<void> openSupport(WidgetTester tester, FakeServer server) async {
      await bootHome(tester, server);
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Support'));
      await tester.pumpAndSettle();
    }

    testWidgets('empty list teaches', (tester) async {
      final server = base()..on('GET /support/tickets', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}});
      await openSupport(tester, server);
      expect(find.textContaining('No tickets yet'), findsOneWidget);
    });

    testWidgets('a new ticket is sent with its topic and message', (tester) async {
      final server = base()
        ..on('GET /support/tickets', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}})
        ..on('POST /support/tickets', status: 201, body: ticket('open'));
      await openSupport(tester, server);
      await tester.tap(find.text('New ticket').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wrong charge'));
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(0), 'Charged twice');
      await tester.enterText(find.byType(TextField).at(1), 'I was charged twice for the same ride.');
      await tester.tap(find.widgetWithText(FilledButton, 'Send'));
      await tester.pumpAndSettle();
      final body = bodyOf(server.calls('POST /support/tickets').single) as Map;
      expect(body['category'], 'wrong_charge');
      expect(body['subject'], 'Charged twice');
      expect(body['message'], 'I was charged twice for the same ride.');
    });

    testWidgets('the new ticket form uses the app chips and lays out in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = base()..on('GET /support/tickets', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}});
      await bootHome(tester, server, size: const Size(390, 2400));
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/support/new');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TurboChip, 'Safety'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sending without a topic or message is explained', (tester) async {
      final server = base()..on('GET /support/tickets', body: {'data': [], 'page': {'nextCursor': null, 'hasMore': false}});
      await openSupport(tester, server);
      await tester.tap(find.text('New ticket').last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Send'));
      await tester.pumpAndSettle();
      expect(find.text('Choose a topic and write a short message.'), findsOneWidget);
      expect(server.calls('POST /support/tickets'), isEmpty);
    });

    testWidgets('a ticket opens as a conversation and takes a reply; staff-only notes are hidden', (tester) async {
      final messages = [
        {'id': '0190a1b2-0000-7e4f-8a5b-0000000f0001', 'author': 'user', 'body': 'Charged twice', 'internal': false, 'createdAt': '2026-10-31T10:00:00Z'},
        {'id': '0190a1b2-0000-7e4f-8a5b-0000000f0002', 'author': 'staff', 'body': 'Checking now', 'internal': false, 'createdAt': '2026-10-31T10:30:00Z'},
        {'id': '0190a1b2-0000-7e4f-8a5b-0000000f0003', 'author': 'staff', 'body': 'Secret note', 'internal': true, 'createdAt': '2026-10-31T10:31:00Z'},
      ];
      final server = base()
        ..on('GET /support/tickets', body: {'data': [ticket('in_progress')], 'page': {'nextCursor': null, 'hasMore': false}})
        ..on('GET /support/tickets/0190a1b2-0000-7e4f-8a5b-0000000e0001', body: ticket('in_progress', messages: messages))
        ..on('POST /support/tickets/0190a1b2-0000-7e4f-8a5b-0000000e0001/messages', status: 201, body: messages.first);
      await openSupport(tester, server);
      expect(find.text('Being looked at'), findsOneWidget);
      await tester.tap(find.text('Charged twice').first);
      await tester.pumpAndSettle();
      expect(find.text('Checking now'), findsOneWidget);
      expect(find.text('Secret note'), findsNothing);
      await tester.enterText(find.byType(TextField), 'Thank you');
      await tester.tap(find.byTooltip('Send reply'));
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('POST /support/tickets/0190a1b2-0000-7e4f-8a5b-0000000e0001/messages').single) as Map)['body'], 'Thank you');
    });
  });

  group('profile', () {
    Future<void> openProfile(WidgetTester tester, FakeServer server) async {
      // Tall, so every section is on screen without scrolling.
      await bootHome(tester, server, size: const Size(390, 2000));
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
    }

    Map<String, Object?> session(int n, {bool current = false}) => {
          'id': '0190a1b2-0000-7e4f-8a5b-0000000a00$n',
          'platform': 'ios',
          'deviceName': 'Phone $n',
          'lastUsedAt': '2026-10-31T09:00:00Z',
          'current': current,
        };

    testWidgets('notification choices show the defaults, save both, and put the old one back if saving fails', (tester) async {
      final server = base()
        ..on('GET /me/sessions', body: {'items': []})
        ..on('GET /me/notification-settings', body: {'newsAndOffers': false, 'tips': true});
      await openProfile(tester, server);
      expect(find.text('News and offers'), findsOneWidget);
      expect(find.text('Messages about your rides and your wallet are always sent.'), findsOneWidget);
      bool on(String title) => tester
          .widget<Switch>(find.descendant(of: find.ancestor(of: find.text(title), matching: find.byType(InkWell)).first, matching: find.byType(Switch)))
          .value;
      expect(on('News and offers'), isFalse);
      expect(on('Tips'), isTrue);

      server.on('PUT /me/notification-settings', body: {'newsAndOffers': true, 'tips': true});
      await tester.tap(find.text('News and offers'));
      await tester.pumpAndSettle();
      final put = bodyOf(server.calls('PUT /me/notification-settings').single) as Map;
      expect(put, {'newsAndOffers': true, 'tips': true}, reason: 'the PUT replaces both choices');
      expect(on('News and offers'), isTrue);

      server.on('PUT /me/notification-settings', status: 503, body: problem('internal', 503));
      await tester.tap(find.text('Tips'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(on('Tips'), isTrue, reason: 'a failed save puts the old choice back');
      expect(find.text("We couldn't save that. Try again."), findsOneWidget);
    });

    testWidgets('the notification rows lay out in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = base()
        ..on('GET /me/sessions', body: {'items': []})
        ..on('GET /me/notification-settings', body: {'newsAndOffers': false, 'tips': true});
      await openProfile(tester, server);
      expect(find.text('News and offers'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows who you are, saved places, devices and version', (tester) async {
      final server = base()..on('GET /me/sessions', body: {'items': [session(1, current: true), session(2)]});
      await openProfile(tester, server);
      expect(find.text('Ama Mensah'), findsOneWidget);
      expect(find.text('+233 24 123 4567'), findsOneWidget);
      expect(find.text('Hostel'), findsOneWidget);
      expect(find.text('This phone'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Sign out everywhere else'), 200);
      expect(find.text('Sign out everywhere else'), findsOneWidget);
    });

    testWidgets('signing out another device and everywhere else', (tester) async {
      final server = base()
        ..on('GET /me/sessions', body: {'items': [session(1, current: true), session(2)]})
        ..on('DELETE /me/sessions/0190a1b2-0000-7e4f-8a5b-0000000a002', status: 204, body: null)
        ..on('DELETE /me/sessions', status: 204, body: null);
      await openProfile(tester, server);
      await tester.scrollUntilVisible(find.text('Sign out everywhere else'), 200);
      await tester.ensureVisible(find.text('Sign out everywhere else'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out everywhere else'));
      await tester.pumpAndSettle();
      expect(server.calls('DELETE /me/sessions'), hasLength(1));
    });

    testWidgets('the email is edited and validated', (tester) async {
      final server = base()
        ..on('GET /me/sessions', body: {'items': [session(1, current: true)]})
        ..on('PATCH /me', body: student());
      await openProfile(tester, server);
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'nope');
      await tester.tap(find.text('Save email'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'ama@example.com');
      await tester.tap(find.text('Save email'));
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('PATCH /me').single) as Map)['email'], 'ama@example.com');
    });

    testWidgets('deleting the account needs the word typed, then asks the server', (tester) async {
      final server = base()
        ..on('GET /me/sessions', body: {'items': [session(1, current: true)]})
        ..on('POST /me/deletion-request', status: 202, body: {'id': '0190a1b2-0000-7e4f-8a5b-0000000a0099', 'status': 'received', 'requestedAt': '2026-10-31T10:00:00Z'});
      await openProfile(tester, server);
      await tester.scrollUntilVisible(find.text('Delete my account'), 300);
      await tester.ensureVisible(find.text('Delete my account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete my account'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Delete').last).onPressed, isNull);
      await tester.enterText(find.byType(TextField).last, 'DELETE');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete').last);
      await tester.pumpAndSettle();
      expect(server.calls('POST /me/deletion-request'), hasLength(1));
    });
  });
}
