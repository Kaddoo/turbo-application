import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  for (final mode in Brightness.values) {
    testWidgets('card list row lays out and taps at 200% text in $mode', (tester) async {
      var taps = 0;
      await pumpTurbo(
        tester,
        TurboListRow(card: true, title: 'Ashaiman China Mall', subtitle: 'Ashaiman, 9.4 km', leading: const Icon(Icons.place), onTap: () => taps++),
        brightness: mode,
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TurboListRow)).height, greaterThanOrEqualTo(TurboSizes.minTap));
      await tester.tap(find.text('Ashaiman China Mall'));
      expect(taps, 1);
    });
  }
}
