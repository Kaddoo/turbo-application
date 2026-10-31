import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  group('TurboButton', () {
    testWidgets('meets 44 pt, and 56 pt when large', (tester) async {
      await pumpTurbo(
        tester,
        Column(children: [
          TurboButton(label: 'Normal', onPressed: () {}),
          TurboButton(label: 'Large', large: true, onPressed: () {}),
        ]),
      );
      final sizes = tester.widgetList<FilledButton>(find.byType(FilledButton)).map((_) => 0).length;
      expect(sizes, 2);
      expect(tester.getSize(find.byType(FilledButton).at(0)).height, greaterThanOrEqualTo(44));
      expect(tester.getSize(find.byType(FilledButton).at(1)).height, greaterThanOrEqualTo(56));
    });

    testWidgets('taps, and is inert while loading', (tester) async {
      var taps = 0;
      await pumpTurbo(tester, TurboButton(label: 'Go', onPressed: () => taps++));
      await tester.tap(find.text('Go'));
      expect(taps, 1);

      await pumpTurbo(tester, TurboButton(label: 'Go', loading: true, onPressed: () => taps++));
      await tester.tap(find.byType(FilledButton));
      expect(taps, 1);
    });

    testWidgets('exposes a button semantics label', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpTurbo(tester, TurboButton(label: 'Book', onPressed: () {}));
      expect(tester.getSemantics(find.byType(FilledButton)), matchesSemantics(
        label: 'Book',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ));
      handle.dispose();
    });
  });

  group('OtpField', () {
    testWidgets('pasting a whole code fills every box and completes', (tester) async {
      String? done;
      await pumpTurbo(tester, OtpField(onCompleted: (c) => done = c));
      await tester.enterText(find.byType(TextField).first, '123456');
      await tester.pump();
      expect(done, '123456');
      final texts = tester.widgetList<TextField>(find.byType(TextField)).map((f) => f.controller!.text);
      expect(texts.join(), '123456');
    });

    testWidgets('typing advances and ignores non-digits', (tester) async {
      String last = '';
      await pumpTurbo(tester, OtpField(onChanged: (c) => last = c));
      await tester.enterText(find.byType(TextField).at(0), '4');
      await tester.enterText(find.byType(TextField).at(1), 'x');
      await tester.enterText(find.byType(TextField).at(1), '7');
      expect(last, '47');
    });

    testWidgets('every box has a spoken position', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpTurbo(tester, const OtpField());
      expect(find.bySemanticsLabel('Digit 1 of 6'), findsOneWidget);
      expect(find.bySemanticsLabel('Digit 6 of 6'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('shows the error text', (tester) async {
      await pumpTurbo(tester, const OtpField(errorText: 'Wrong code'));
      expect(find.text('Wrong code'), findsOneWidget);
    });
  });

  group('shared states', () {
    testWidgets('loading announces itself and shows skeletons', (tester) async {
      await pumpTurbo(tester, const LoadingState());
      expect(find.byType(TurboSkeleton), findsWidgets);
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    });

    testWidgets('empty teaches and offers one action', (tester) async {
      var tapped = false;
      await pumpTurbo(
        tester,
        EmptyState(
          icon: Icons.inbox,
          message: 'No transactions yet.',
          actionLabel: 'Top up',
          onAction: () => tapped = true,
        ),
      );
      expect(find.text('No transactions yet.'), findsOneWidget);
      await tester.tap(find.text('Top up'));
      expect(tapped, isTrue);
    });

    testWidgets('error says what happened and retries', (tester) async {
      var retried = false;
      await pumpTurbo(tester, ErrorState(onRetry: () => retried = true));
      expect(find.textContaining('Something went wrong'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retried, isTrue);
    });

    testWidgets('skeleton is static under reduced motion', (tester) async {
      await pumpTurbo(tester, const TurboSkeleton(width: 100), reduceMotion: true);
      await tester.pump(const Duration(seconds: 2));
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('dialogs and money', () {
    testWidgets('type-to-confirm keeps confirm off until the phrase matches', (tester) async {
      bool? result;
      await pumpTurbo(
        tester,
        Builder(
          builder: (context) => TurboButton(
            label: 'Open',
            onPressed: () async => result = await showTurboConfirm(
              context: context,
              title: 'Delete?',
              message: 'Cannot be undone.',
              confirmLabel: 'Delete',
              destructive: true,
              typeToConfirm: 'DELETE',
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(result, isNull, reason: 'dialog should still be open');
      await tester.enterText(find.byType(TextField), 'DELETE');
      await tester.pump();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('MoneyText renders pesewas as cedis', (tester) async {
      await pumpTurbo(tester, const MoneyText(3500));
      expect(find.text('GH₵35.00'), findsOneWidget);
    });
  });

  group('text scaling', () {
    for (final brightness in Brightness.values) {
      testWidgets('gallery lays out at 200% in ${brightness.name}', (tester) async {
        await pumpTurbo(
          tester,
          const TurboGalleryScreen(brand: turboBrand),
          textScale: 2,
          brightness: brightness,
        );
        await tester.pump();
        // Scroll the whole list so every section lays out at 200%.
        for (var i = 0; i < 12; i++) {
          await tester.drag(find.byType(ListView).first, const Offset(0, -700));
          await tester.pump();
        }
        expect(tester.takeException(), isNull);
      });
    }
  });
}
