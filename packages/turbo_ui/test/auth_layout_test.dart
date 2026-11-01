import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('AuthLayout lays out in dark and light at ${scale * 100}% text', (tester) async {
      for (final mode in Brightness.values) {
        await pumpTurbo(
          tester,
          AuthLayout(
            title: 'Sign in with your phone',
            accent: 'phone',
            lead: 'New or returning, it is the same step.',
            icon: Icons.smartphone,
            onBack: () {},
            action: TurboButton(label: 'Send code', onPressed: () {}),
            footer: const Text('By continuing you agree to the terms.'),
            children: const [TurboTextField(label: 'Phone number')],
          ),
          brightness: mode,
          textScale: scale,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Send code'), findsOneWidget);
      }
    });

    testWidgets('SystemMessage lays out at ${scale * 100}% text and keeps its action reachable', (tester) async {
      await pumpTurbo(
        tester,
        SystemMessage(
          icon: Icons.warning_amber_rounded,
          title: 'We could not start up',
          message: 'Check your connection and try again.',
          tag: const StatusChip(label: 'Offline', icon: Icons.wifi_off, tone: StatusTone.warning),
          action: TurboButton(label: 'Try again', onPressed: () {}),
        ),
        textScale: scale,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Try again'), findsOneWidget);
    });
  }

  testWidgets('AccentTitle reads as one sentence to a screen reader', (tester) async {
    await pumpTurbo(tester, const AccentTitle(text: 'Enter the code', accent: 'code'));
    expect(find.text('Enter the code', findRichText: true), findsOneWidget);
  });
}
