import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'support/helpers.dart';

Widget _everything() => SingleChildScrollView(
      padding: const EdgeInsets.all(TurboSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final v in TurboButtonVariant.values) ...[TurboButton(label: 'Button ${v.name}', variant: v, onPressed: () {}), const SizedBox(height: TurboSpacing.sm)],
          TurboButton(label: 'Go on duty', driver: true, onPressed: () {}),
          const SizedBox(height: TurboSpacing.sm),
          SlideToContinue(label: 'Continue', onContinue: () {}),
          const SizedBox(height: TurboSpacing.sm),
          Wrap(spacing: TurboSpacing.sm, runSpacing: TurboSpacing.sm, children: [
            TurboChip(label: 'Nearest point', selected: true, onTap: () {}),
            TurboChip(label: 'Choose point', onTap: () {}),
            const TurboChip(label: 'Fare locked', outline: true),
            const StatusChip(label: 'Completed', icon: Icons.check, tone: StatusTone.success),
          ]),
          const SizedBox(height: TurboSpacing.sm),
          TurboSegmented(labels: const ['Trips', 'Shifts', 'Hours', 'Salary'], selectedIndex: 1, onSelected: (_) {}),
          const SizedBox(height: TurboSpacing.sm),
          const TurboBanner(title: 'You are offline', message: 'The map and prices may be out of date. Last updated 19:32.', icon: Icons.wifi_off, tone: StatusTone.warning),
          const SizedBox(height: TurboSpacing.sm),
          Row(children: [
            const Expanded(child: BentoTile(label: 'Wallet', title: 'GH₵120.00', money: true, tone: BentoTone.lime, trailing: Icon(Icons.savings_outlined))),
            const SizedBox(width: TurboSpacing.sm),
            const Expanded(child: BentoTile(label: 'Safety', title: 'SOS and trip sharing', trailing: Icon(Icons.shield_outlined))),
          ]),
          const SizedBox(height: TurboSpacing.sm),
          const InnerPanel(child: TripPin(digits: '48', current: true)),
          const SizedBox(height: TurboSpacing.sm),
          TurboKeypad(onDigit: (_) {}, onDelete: () {}, deleteLabel: 'Delete'),
          const SizedBox(height: TurboSpacing.sm),
          MessageComposer(controller: TextEditingController(), hint: 'Write a reply', sendLabel: 'Send', onSend: () {}),
          const SizedBox(height: TurboSpacing.sm),
          Row(children: [
            TurboIconButton(icon: Icons.arrow_back, label: 'Back', onPressed: () {}),
            const SizedBox(width: TurboSpacing.sm),
            const TurboAvatar(name: 'Ama'),
            const SizedBox(width: TurboSpacing.sm),
            const TurboAvatar(name: 'Kofi', rounded: true, small: true),
          ]),
        ],
      ),
    );

void main() {
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('the new components lay out in ${brightness.name} at ${(scale * 100).round()}% text', (tester) async {
        await pumpTurbo(tester, _everything(), brightness: brightness, textScale: scale);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('buttons are 60 pt, the driver button is 80 pt', (tester) async {
    await pumpTurbo(tester, Column(children: [
      TurboButton(label: 'Book', onPressed: () {}),
      TurboButton(label: 'Go on duty', driver: true, onPressed: () {}),
    ]));
    expect(tester.getSize(find.widgetWithText(FilledButton, 'Book')).height, 60);
    expect(tester.getSize(find.widgetWithText(FilledButton, 'Go on duty')).height, 80);
  });

  testWidgets('the SOS button uses the emergency red, never the accent', (tester) async {
    await pumpTurbo(tester, TurboButton(label: 'Call 112 now', variant: TurboButtonVariant.sos, onPressed: () {}));
    final fill = tester.widget<FilledButton>(find.byType(FilledButton)).style!.backgroundColor!.resolve({})!;
    expect(fill, turboBrand.dark.sos);
    expect(fill, isNot(turboBrand.dark.accent));
  });

  testWidgets('a disabled primary button is the accent at 40%', (tester) async {
    await pumpTurbo(tester, const TurboButton(label: 'Send code', onPressed: null));
    final fill = tester.widget<FilledButton>(find.byType(FilledButton)).style!.backgroundColor!.resolve({WidgetState.disabled})!;
    expect(fill.a, closeTo(0.4, 0.01));
  });

  testWidgets('chips and segments report selection to assistive tech and taps', (tester) async {
    var chip = 0, seg = -1;
    await pumpTurbo(tester, Column(children: [
      TurboChip(label: 'Rides', selected: true, onTap: () => chip++),
      TurboSegmented(labels: const ['Trips', 'Shifts'], selectedIndex: 0, onSelected: (i) => seg = i),
    ]));
    final handle = tester.ensureSemantics();
    final flags = tester.getSemantics(find.bySemanticsLabel('Rides')).flagsCollection;
    expect(flags.isSelected.toString(), contains('isTrue'));
    expect(flags.isButton, isTrue);
    handle.dispose();
    await tester.tap(find.text('Rides'));
    await tester.tap(find.text('Shifts'));
    expect([chip, seg], [1, 1]);
    expect(tester.getSize(find.bySemanticsLabel('Shifts')).height, greaterThanOrEqualTo(44));
  });

  testWidgets('the trip PIN shows its digits and leaves the rest empty', (tester) async {
    await pumpTurbo(tester, const TripPin(digits: '48', current: true));
    expect(find.text('4'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.byType(AspectRatio), findsNWidgets(4));
  });

  testWidgets('the keypad sends digits and delete, and names delete for screen readers', (tester) async {
    final got = <String>[];
    var deleted = 0;
    await pumpTurbo(tester, TurboKeypad(onDigit: got.add, onDelete: () => deleted++, deleteLabel: 'Delete'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('0'));
    await tester.tap(find.bySemanticsLabel('Delete'));
    expect(got, ['4', '0']);
    expect(deleted, 1);
  });

  testWidgets('slide to continue continues on a tap and on a long drag, not on a short one', (tester) async {
    var n = 0;
    await pumpTurbo(tester, SlideToContinue(label: 'Continue', onContinue: () => n++));
    await tester.tap(find.text('Continue'));
    expect(n, 1);
    await tester.drag(find.byIcon(Icons.directions_car_outlined), const Offset(20, 0));
    await tester.pump();
    expect(n, 1, reason: 'a short drag springs back');
    await tester.drag(find.byIcon(Icons.directions_car_outlined), const Offset(300, 0));
    await tester.pump();
    expect(n, 2);
  });

  testWidgets('a banner announces itself when it is a live region', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpTurbo(tester, const TurboBanner(message: 'Wallet is short', icon: Icons.warning_amber, tone: StatusTone.warning, liveRegion: true));
    expect(tester.getSemantics(find.text('Wallet is short')).flagsCollection.isLiveRegion, isTrue);
    handle.dispose();
  });

  testWidgets('the bottom bar marks the open tab with a lime circle', (tester) async {
    await pumpTurbo(
      tester,
      Scaffold(
        bottomNavigationBar: FloatingNavBar(selectedIndex: 1, onSelected: (_) {}, items: const [
          FloatingNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Ride'),
          FloatingNavItem(icon: Icons.history, selectedIcon: Icons.history, label: 'Activity'),
        ]),
      ),
    );
    final circles = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer)).where((c) => (c.decoration as BoxDecoration?)?.color == turboBrand.dark.accent);
    expect(circles.length, 1);
  });
}
