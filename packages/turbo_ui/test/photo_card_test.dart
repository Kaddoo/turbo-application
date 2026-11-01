import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  for (final mode in Brightness.values) {
    testWidgets('PhotoCard shows its text over the photo at 200% in $mode and hides the picture from readers', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpTurbo(
        tester,
        const PhotoCard(asset: 'trip-status-trotro.jpg', height: 140, child: Text('Main Gate → China Mall')),
        brightness: mode,
        textScale: 2,
      );
      expect(find.text('Main Gate → China Mall'), findsOneWidget);
      expect(find.bySemanticsLabel('Main Gate → China Mall'), findsOneWidget);
      handle.dispose();
    });
  }
}
