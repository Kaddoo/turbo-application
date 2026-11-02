import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

Widget host(int trigger, {bool reduced = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Center(child: TurboShake(trigger: trigger, child: const SizedBox(key: Key('box'), width: 40, height: 40))),
      ),
    );

double dx(WidgetTester tester) => tester.getTopLeft(find.byKey(const Key('box'))).dx;

void main() {
  testWidgets('moves sideways when the trigger changes, then settles', (tester) async {
    await tester.pumpWidget(host(0));
    final rest = dx(tester);
    await tester.pumpWidget(host(1));
    await tester.pump(const Duration(milliseconds: 30));
    expect((dx(tester) - rest).abs(), greaterThan(0));
    await tester.pump(const Duration(milliseconds: 300));
    expect(dx(tester), rest);
  });

  testWidgets('does not move with reduced motion', (tester) async {
    await tester.pumpWidget(host(0, reduced: true));
    final rest = dx(tester);
    await tester.pumpWidget(host(1, reduced: true));
    await tester.pump(const Duration(milliseconds: 30));
    expect(dx(tester), rest);
  });
}
