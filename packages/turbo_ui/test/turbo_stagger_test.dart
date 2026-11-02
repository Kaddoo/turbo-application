import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

Widget host({bool reduced = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Column(
          children: [
            for (var i = 0; i < 3; i++) TurboStagger(index: i, child: SizedBox(key: Key('row$i'), height: 20, width: 20)),
          ],
        ),
      ),
    );

double opacityOf(WidgetTester tester, int i) => tester
    .widget<Opacity>(find.ancestor(of: find.byKey(Key('row$i')), matching: find.byType(Opacity)))
    .opacity;

void main() {
  testWidgets('each row comes in a little after the one before, then all rest', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacityOf(tester, 0), greaterThan(opacityOf(tester, 2)));
    await tester.pump(const Duration(milliseconds: 500));
    for (var i = 0; i < 3; i++) {
      expect(opacityOf(tester, i), 1);
    }
  });

  testWidgets('with reduced motion the rows are simply there', (tester) async {
    await tester.pumpWidget(host(reduced: true));
    expect(find.byType(Opacity), findsNothing);
    expect(find.byKey(const Key('row2')), findsOneWidget);
  });

  testWidgets('an empty state shows a 3D picture instead of an icon', (tester) async {
    await pumpTurbo(tester, const EmptyState(art: TurboArt.calendar, message: 'Nothing here'));
    expect(find.byType(TurboArtImage), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });
}
