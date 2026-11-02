import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

/// Records the haptics the platform is asked for, as the names Flutter sends ("HapticFeedbackType.mediumImpact").
List<String> _record(WidgetTester tester) {
  final played = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'HapticFeedback.vibrate') played.add(call.arguments as String);
    return null;
  });
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
  return played;
}

const _selection = 'HapticFeedbackType.selectionClick';
const _light = 'HapticFeedbackType.lightImpact';
const _medium = 'HapticFeedbackType.mediumImpact';
const _heavy = 'HapticFeedbackType.heavyImpact';

void main() {
  group('haptic grammar', () {
    testWidgets('each kind plays its own vibration', (tester) async {
      final played = _record(tester);
      for (final kind in TurboHapticKind.values) {
        await TurboHaptics.play(kind);
      }
      // selection, success, confirm, completed
      expect(played, [_selection, _light, _medium, _heavy]);
    });

    testWidgets('slide to continue plays a medium tap when dragged through, and once only', (tester) async {
      final played = _record(tester);
      var continued = 0;
      await pumpTurbo(tester, SlideToContinue(label: 'Continue', onContinue: () => continued++));
      await tester.drag(find.byType(SlideToContinue), const Offset(600, 0));
      await tester.pump();
      expect(continued, 1);
      expect(played, [_medium]);
    });

    testWidgets('slide to continue also plays it when tapped', (tester) async {
      final played = _record(tester);
      await pumpTurbo(tester, SlideToContinue(label: 'Continue', onContinue: () {}));
      await tester.tap(find.byType(SlideToContinue));
      await tester.pump();
      expect(played, [_medium]);
    });

    testWidgets('a short drag that does not go through is silent', (tester) async {
      final played = _record(tester);
      await pumpTurbo(tester, SlideToContinue(label: 'Continue', onContinue: () {}));
      await tester.drag(find.byType(SlideToContinue), const Offset(20, 0));
      await tester.pump();
      expect(played, isEmpty);
    });

    testWidgets('a tappable chip plays the selection tick; a chip with no action is silent', (tester) async {
      final played = _record(tester);
      var taps = 0;
      await pumpTurbo(
        tester,
        Column(children: [
          TurboChip(label: 'All', onTap: () => taps++),
          const TurboChip(label: 'Fare locked', outline: true),
        ]),
      );
      await tester.tap(find.text('All'));
      await tester.tap(find.text('Fare locked'));
      expect(taps, 1);
      expect(played, [_selection]);
    });

    testWidgets('a segment plays the tick when the choice changes, not when the open one is tapped again', (tester) async {
      final played = _record(tester);
      final chosen = <int>[];
      await pumpTurbo(tester, TurboSegmented(labels: const ['Trips', 'Shifts'], selectedIndex: 0, onSelected: chosen.add));
      await tester.tap(find.text('Trips'));
      expect(played, isEmpty);
      await tester.tap(find.text('Shifts'));
      expect(played, [_selection]);
      expect(chosen, [0, 1]);
    });

    testWidgets('a button is silent unless it is given a haptic', (tester) async {
      final played = _record(tester);
      await pumpTurbo(
        tester,
        Column(children: [
          TurboButton(label: 'Plain', onPressed: () {}),
          TurboButton(label: 'Book', haptic: TurboHapticKind.confirm, onPressed: () {}),
        ]),
      );
      await tester.tap(find.text('Plain'));
      expect(played, isEmpty);
      await tester.tap(find.text('Book'));
      expect(played, [_medium]);
    });

    testWidgets('a disabled or loading button never plays its haptic', (tester) async {
      final played = _record(tester);
      await pumpTurbo(
        tester,
        Column(children: [
          const TurboButton(label: 'Off', haptic: TurboHapticKind.confirm, onPressed: null),
          TurboButton(label: 'Busy', haptic: TurboHapticKind.confirm, loading: true, onPressed: () {}),
        ]),
      );
      await tester.tap(find.byType(FilledButton).at(0), warnIfMissed: false);
      await tester.tap(find.byType(FilledButton).at(1), warnIfMissed: false);
      expect(played, isEmpty);
    });

    testWidgets('HapticOnShow plays once when shown and not again on rebuild', (tester) async {
      final played = _record(tester);
      Widget build(String text) => HapticOnShow(kind: TurboHapticKind.success, child: Text(text));
      await pumpTurbo(tester, build('Top-up complete'));
      await pumpTurbo(tester, build('Top-up complete, again'));
      expect(played, [_light]);
    });
  });
}
