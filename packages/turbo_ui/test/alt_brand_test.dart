import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'fixtures/alt_brand.dart';
import 'support/helpers.dart';

/// Proves a rebrand needs no widget change: the same widgets, built with a
/// different [BrandTokens], pick up its colours, radius, font and name.
void main() {
  Widget sample() => Column(
        children: [
          const Wordmark(),
          TurboButton(label: 'Pay', onPressed: () {}),
          const TurboCard(child: Text('Card')),
          const StatusChip(label: 'On duty', icon: Icons.check),
        ],
      );

  testWidgets('theme carries the alt brand', (tester) async {
    await pumpTurbo(tester, sample(), brand: altBrand, brightness: Brightness.dark);
    final theme = Theme.of(tester.element(find.byType(Wordmark)));
    expect(theme.extension<TurboTheme>()!.brand.appName, 'Zippa');
    expect(theme.colorScheme.primary, altBrand.dark.accent);
    expect(theme.textTheme.bodyLarge!.fontFamily, 'Georgia');
  });

  testWidgets('wordmark shows the alt name, not the Turbo one', (tester) async {
    await pumpTurbo(tester, sample(), brand: altBrand);
    expect(find.text('Zippa'), findsOneWidget);
    expect(find.text(turboBrand.wordmark), findsNothing);
  });

  testWidgets('button fill and shape come from the alt brand', (tester) async {
    await pumpTurbo(tester, sample(), brand: altBrand, brightness: Brightness.light);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final fill = button.style!.backgroundColor!.resolve({});
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(fill, altBrand.light.accent);
    expect((shape.borderRadius as BorderRadius).topLeft.x, altBrand.radiusFull);
  });

  testWidgets('card radius comes from the alt brand', (tester) async {
    await pumpTurbo(tester, sample(), brand: altBrand);
    final ink = tester.widget<Ink>(find.descendant(of: find.byType(TurboCard), matching: find.byType(Ink)));
    final decoration = ink.decoration! as BoxDecoration;
    expect((decoration.borderRadius! as BorderRadius).topLeft.x, altBrand.radiusCard);
    expect(decoration.color, altBrand.dark.surface);
  });

  testWidgets('same widgets restyle: colours differ between brands', (tester) async {
    await pumpTurbo(tester, sample(), brand: turboBrand);
    final a = tester.widget<FilledButton>(find.byType(FilledButton)).style!.backgroundColor!.resolve({});
    await pumpTurbo(tester, sample(), brand: altBrand);
    await tester.pumpAndSettle();
    final b = tester.widget<FilledButton>(find.byType(FilledButton)).style!.backgroundColor!.resolve({});
    expect(a, isNot(b));
  });

  testWidgets('gallery builds with the alt brand', (tester) async {
    await pumpTurbo(tester, const TurboGalleryScreen(brand: altBrand));
    expect(tester.takeException(), isNull);
    expect(find.text('Zippa'), findsOneWidget);
  });
}
