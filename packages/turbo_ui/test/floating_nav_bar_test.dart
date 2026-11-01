import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  testWidgets('floating bar keeps its own height, names every item and reports taps', (tester) async {
    var picked = -1;
    await pumpTurbo(
      tester,
      Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: 0,
          onSelected: (i) => picked = i,
          items: const [
            FloatingNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Ride'),
            FloatingNavItem(icon: Icons.history, selectedIcon: Icons.history, label: 'Activity'),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byType(FloatingNavBar)).height, lessThan(120));
    expect(find.bySemanticsLabel('Ride'), findsOneWidget);
    for (final label in ['Ride', 'Activity']) {
      expect(tester.getSize(find.bySemanticsLabel(label)).height, greaterThanOrEqualTo(44));
    }
    await tester.tap(find.bySemanticsLabel('Activity'));
    expect(picked, 1);
  });
}
