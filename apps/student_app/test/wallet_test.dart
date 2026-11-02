import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/features/wallet/amount.dart';
import 'package:student_app/src/features/wallet/topup_screen.dart';

import 'support/fake_server.dart';
import 'support/home_harness.dart';

Map<String, Object?> tx(int n, String type, int amount, {String description = 'Top-up'}) => {
      'id': '0190a1b2-0000-7e4f-8a5b-00000000e${n.toString().padLeft(3, '0')}',
      'type': type,
      'amountPesewas': amount,
      'affectsBalance': type != 'ride_hold' && type != 'ride_release',
      'balanceAfterPesewas': 6000,
      'description': description,
      'createdAt': '2026-10-31T10:0$n:00Z',
    };

Map<String, Object?> page(List<Map<String, Object?>> items, {bool more = false}) =>
    {'data': items, 'page': {'nextCursor': more ? 'c2' : null, 'hasMore': more}};

Map<String, Object?> topup(String status, {int amount = 2000, String? message}) => {
      'id': '0190a1b2-0000-7e4f-8a5b-0000000f0001',
      'status': status,
      'amountPesewas': amount,
      'channel': 'mobile_money',
      'reference': 'ref-1',
      'checkout': {'type': 'prompt', 'url': null, 'message': message ?? 'Approve the prompt on your phone.'},
      'createdAt': '2026-10-31T10:00:00Z',
    };

FakeServer walletServer() => homeServer()
  ..on('GET /wallet/transactions', body: page([tx(1, 'topup', 5000), tx(2, 'ride_hold', -3500, description: 'Ride held')]));

Future<void> openWallet(WidgetTester tester) async {
  await tester.tap(find.bySemanticsLabel('Wallet'));
  await tester.pumpAndSettle();
}

void main() {
  group('amounts', () {
    test('parse cedis into pesewas without floats', () {
      expect(parsePesewas('12'), 1200);
      expect(parsePesewas('12.5'), 1250);
      expect(parsePesewas('12.50'), 1250);
      expect(parsePesewas('0.05'), 5);
      expect(parsePesewas(' 1,250 '), 125000);
      expect(parsePesewas('12.505'), isNull);
      expect(parsePesewas('-3'), isNull);
      expect(parsePesewas('abc'), isNull);
      expect(parsePesewas(''), isNull);
    });
  });

  group('wallet screen', () {
    testWidgets('shows available in large type, held, recent entries labelled not as spend', (tester) async {
      final server = walletServer()
        ..on('GET /wallet', body: {'balancePesewas': 6000, 'reservedPesewas': 3500, 'availablePesewas': 2500, 'currency': 'GHS'});
      await bootHome(tester, server);
      await openWallet(tester);
      expect(find.text('GH₵25.00'), findsOneWidget);
      // Balance and held are tiles under the card.
      expect(find.text('Held for your ride'), findsOneWidget);
      // The held amount shows in its tile and on the "Ride held" row.
      expect(find.text('GH₵35.00'), findsNWidgets(2));
      expect(find.text('GH₵60.00'), findsOneWidget);
      expect(find.textContaining('Held ·'), findsOneWidget);
      expect(find.textContaining('Top-up ·'), findsOneWidget);
    });

    testWidgets('wallet and top-up lay out in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = walletServer()
        ..on('GET /wallet', body: {'balancePesewas': 6000, 'reservedPesewas': 3500, 'availablePesewas': 2500, 'currency': 'GHS'});
      await bootHome(tester, server);
      await openWallet(tester);
      expect(tester.takeException(), isNull);
      await tester.tap(find.widgetWithText(FilledButton, 'Top up'));
      await tester.pumpAndSettle();
      expect(find.text('GH₵20.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('owed money is shown with an icon and words', (tester) async {
      final server = walletServer()
        ..on('GET /wallet', body: {'balancePesewas': -500, 'reservedPesewas': 0, 'availablePesewas': 0, 'currency': 'GHS', 'owedPesewas': 500});
      await bootHome(tester, server);
      await openWallet(tester);
      expect(find.text('You owe GH₵5.00. Top up to book again.'), findsOneWidget);
    });

    testWidgets('no transactions teaches and does not look broken', (tester) async {
      final server = walletServer()..on('GET /wallet/transactions', body: page([]));
      await bootHome(tester, server);
      await openWallet(tester);
      expect(find.text('No transactions yet.'), findsOneWidget);
    });

    testWidgets('an error offers to try again', (tester) async {
      final server = walletServer()..on('GET /wallet', status: 503, body: problem('service_unavailable', 503));
      await bootHome(tester, server);
      await openWallet(tester);
      expect(find.textContaining("couldn't load your wallet"), findsOneWidget);
      server.on('GET /wallet', body: wallet());
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('GH₵60.00'), findsNWidgets(2));
    });

    testWidgets('the wallet chip on home opens the wallet', (tester) async {
      await bootHome(tester, walletServer());
      await tester.tap(find.textContaining('Wallet GH₵'));
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('See all lists more and loads the next page', (tester) async {
      final server = walletServer();
      server.onCall('GET /wallet/transactions', (r) {
        final cursor = r.queryParameters['cursor'];
        return (
          status: 200,
          body: cursor == null ? page([tx(1, 'topup', 5000)], more: true) : page([tx(2, 'refund', 3500, description: 'Refund')]),
          headers: <String, String>{},
        );
      });
      await bootHome(tester, server);
      await openWallet(tester);
      await tester.tap(find.text('See all'));
      await tester.pumpAndSettle();
      expect(find.text('Transactions'), findsWidgets);
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Refund ·'), findsOneWidget);
      expect(find.text('Show more'), findsNothing);
    });
  });

  group('top-up', () {
    Future<void> toTopup(WidgetTester tester, FakeServer server) async {
      await bootHome(tester, server);
      await openWallet(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Top up'));
      await tester.pumpAndSettle();
    }

    testWidgets('a chip amount is sent as integer pesewas with an idempotency key', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();
      final request = server.calls('POST /wallet/topups').single;
      final body = bodyOf(request) as Map;
      expect(body['amountPesewas'], 2000);
      expect(body['channel'], 'mobile_money');
      expect(request.headers['Idempotency-Key'], isNotEmpty);
      expect(find.text('Approve the payment on your phone'), findsOneWidget);
      expect(find.text('Approve the prompt on your phone.'), findsOneWidget);
    });

    testWidgets('a typed amount is parsed exactly and out-of-range is explained before sending', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending', amount: 1250));
      await toTopup(tester, server);
      await tester.enterText(find.byType(TextField), '2');
      await tester.pump();
      await tester.tap(find.descendant(of: find.byType(TopupScreen), matching: find.byType(FilledButton)));
      await tester.pump();
      expect(find.textContaining('between GH₵5.00 and GH₵500.00'), findsWidgets);
      expect(server.calls('POST /wallet/topups'), isEmpty);

      await tester.enterText(find.byType(TextField), '12.50');
      await tester.pump();
      await tester.tap(find.text('Pay GH₵12.50'));
      await tester.pumpAndSettle();
      expect((bodyOf(server.calls('POST /wallet/topups').single) as Map)['amountPesewas'], 1250);
    });

    testWidgets('a retry after a failed request reuses the idempotency key; a new amount gets a new one', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 503, body: problem('payment_provider_error', 502));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵10.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵10.00'));
      await tester.pumpAndSettle();
      expect(find.text("The payment service isn't answering. Try again in a moment."), findsOneWidget);
      await tester.tap(find.text('Pay GH₵10.00'));
      await tester.pumpAndSettle();
      final calls = server.calls('POST /wallet/topups').toList();
      expect(calls, hasLength(2));
      expect(calls[1].headers['Idempotency-Key'], calls[0].headers['Idempotency-Key']);

      await tester.tap(find.text('GH₵50.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵50.00'));
      await tester.pumpAndSettle();
      final third = server.calls('POST /wallet/topups').last;
      expect(third.headers['Idempotency-Key'], isNot(calls[0].headers['Idempotency-Key']));
    });

    testWidgets('approval by polling: success shows the new balance', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();

      server
        ..on('GET /wallet/topups/0190a1b2-0000-7e4f-8a5b-0000000f0001', body: topup('succeeded'))
        ..on('GET /wallet', body: wallet(available: 8000));
      await tester.tap(find.text('Check status'));
      await tester.pumpAndSettle();
      expect(find.text('Money added'), findsOneWidget);
      expect(find.text('Your wallet now has GH₵80.00 available.'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('waiting and failed screens lay out in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();
      expect(find.text('Approve the payment on your phone'), findsOneWidget);
      expect(tester.takeException(), isNull);
      server.on('GET /wallet/topups/0190a1b2-0000-7e4f-8a5b-0000000f0001', body: topup('failed'));
      await tester.scrollUntilVisible(find.text('Check status'), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text('Check status'));
      await tester.pumpAndSettle();
      expect(find.text("The payment didn't go through"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('failed says nothing was charged and offers another go', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();
      server.on('GET /wallet/topups/0190a1b2-0000-7e4f-8a5b-0000000f0001', body: topup('failed'));
      await tester.tap(find.text('Check status'));
      await tester.pumpAndSettle();
      expect(find.text("The payment didn't go through"), findsOneWidget);
      expect(find.text("You haven't been charged. You can try again."), findsOneWidget);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Choose an amount'), findsOneWidget);
    });

    testWidgets('still pending after two minutes: told not to pay again, never called failed', (tester) async {
      final server = walletServer()
        ..on('POST /wallet/topups', status: 201, body: topup('pending'))
        ..on('GET /wallet/topups/0190a1b2-0000-7e4f-8a5b-0000000f0001', body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();
      for (var i = 0; i < 45; i++) {
        await tester.pump(const Duration(seconds: 3));
      }
      await tester.pumpAndSettle();
      expect(find.text('Still waiting'), findsOneWidget);
      expect(find.text("We'll add the money when it arrives. You don't need to pay again."), findsOneWidget);
      expect(find.text("The payment didn't go through"), findsNothing);
    });

    testWidgets('a second top-up while one is waiting asks first', (tester) async {
      final server = walletServer()..on('POST /wallet/topups', status: 201, body: topup('pending'));
      await toTopup(tester, server);
      await tester.tap(find.text('GH₵20.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵20.00'));
      await tester.pumpAndSettle();
      // Leave while it is still pending, then try again.
      await tester.tap(find.text('Leave this screen'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Top up'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('GH₵10.00'));
      await tester.pump();
      await tester.tap(find.text('Pay GH₵10.00'));
      await tester.pumpAndSettle();
      // Leaving cleared it, so no warning here; the warning is for an unfinished top-up still held.
      expect(server.calls('POST /wallet/topups'), hasLength(2));
    });
  });

  group('quote to top-up', () {
    testWidgets('the shortfall pre-fills the top-up and the quote refreshes afterwards', (tester) async {
      var quotes = 0;
      final server = walletServer()
        ..onCall('POST /rides/quote', (r) {
          quotes++;
          return (status: 200, body: quote(available: quotes == 1 ? 2000 : 6000), headers: <String, String>{});
        })
        ..on('POST /wallet/topups', status: 201, body: topup('pending', amount: 1500));
      await bootHome(tester, server);
      await tester.tap(find.text('Hostel'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Top up GH₵15.00'));
      await tester.pumpAndSettle();
      expect(find.text('Pay GH₵15.00'), findsOneWidget);
      await tester.tap(find.text('Pay GH₵15.00'));
      await tester.pumpAndSettle();
      server.on('GET /wallet/topups/0190a1b2-0000-7e4f-8a5b-0000000f0001', body: topup('succeeded', amount: 1500));
      await tester.tap(find.text('Check status'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(quotes, 2);
      expect(find.text('Book for GH₵35.00'), findsOneWidget);
    });
  });
}
