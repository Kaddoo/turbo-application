import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  testWidgets('a drag continues, a tap does too by default', (tester) async {
    var n = 0;
    await pumpTurbo(tester, SlideToContinue(label: 'Go', onContinue: () => n++));
    await tester.drag(find.byType(SlideToContinue), const Offset(600, 0));
    await tester.pump();
    expect(n, 1);
    await tester.tap(find.byType(SlideToContinue));
    await tester.pump();
    expect(n, 2);
  });

  testWidgets('with tapToContinue off only a drag continues', (tester) async {
    var n = 0;
    await pumpTurbo(tester, SlideToContinue(label: 'Go', tapToContinue: false, onContinue: () => n++));
    await tester.tap(find.byType(SlideToContinue));
    await tester.pump();
    expect(n, 0);
    await tester.drag(find.byType(SlideToContinue), const Offset(600, 0));
    await tester.pump();
    expect(n, 1);
  });

  testWidgets('while loading it shows a spinner and ignores a drag', (tester) async {
    var n = 0;
    await pumpTurbo(tester, SlideToContinue(label: 'Go', loading: true, onContinue: () => n++));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.drag(find.byType(SlideToContinue), const Offset(600, 0));
    await tester.pump();
    expect(n, 0);
  });
}
