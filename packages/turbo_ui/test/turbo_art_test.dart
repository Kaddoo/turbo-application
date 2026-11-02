import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

void main() {
  testWidgets('every 3D picture is bundled and loads', (tester) async {
    await pumpTurbo(tester, Wrap(children: [for (final a in TurboArt.values) TurboArtImage(a, size: 24)]));
    await tester.runAsync(() async {
      for (final a in TurboArt.values) {
        await precacheImage(a.image, tester.element(find.byType(Wrap)));
      }
    });
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsNWidgets(TurboArt.values.length));
  });

  testWidgets('HeroIcon with art is hidden from screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpTurbo(tester, const HeroIcon(art: TurboArt.key));
    expect(find.bySemanticsLabel(RegExp('.')), findsNothing);
    handle.dispose();
  });
}
