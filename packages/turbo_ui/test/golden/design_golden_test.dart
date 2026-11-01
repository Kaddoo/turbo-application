import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../support/helpers.dart';

/// Golden sheets for the components added for the design kit, laid out like the sections of `design/Turbo-components.pdf`.
Widget _pad(List<Widget> children) => Padding(
      padding: const EdgeInsets.all(TurboSpacing.screen),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );

const _g = SizedBox(height: TurboSpacing.md);

Widget _buttons() => _pad([
      TurboButton(label: 'Book for GH₵35.00', onPressed: () {}),
      _g,
      TurboButton(label: 'Back home', variant: TurboButtonVariant.secondary, onPressed: () {}),
      _g,
      TurboButton(label: 'Share trip', variant: TurboButtonVariant.light, onPressed: () {}),
      _g,
      TurboButton(label: 'Cancel ride', variant: TurboButtonVariant.destructive, onPressed: () {}),
      _g,
      TurboButton(label: 'Report a problem', variant: TurboButtonVariant.outline, onPressed: () {}),
      _g,
      TurboButton(label: 'Not now', variant: TurboButtonVariant.text, onPressed: () {}),
      _g,
      const TurboButton(label: 'Send code', onPressed: null),
      _g,
      TurboButton(label: 'Go on duty', driver: true, onPressed: () {}),
      _g,
      TurboButton(label: 'Call 112 now', variant: TurboButtonVariant.sos, onPressed: () {}),
      _g,
      SlideToContinue(label: 'Continue', onContinue: () {}),
      _g,
      Wrap(spacing: TurboSpacing.sm, runSpacing: TurboSpacing.sm, children: [
        TurboIconButton(icon: Icons.arrow_back, label: 'Back', onPressed: () {}),
        TurboIconButton(icon: Icons.add, label: 'Add', tone: TurboIconTone.lime, onPressed: () {}),
        TurboIconButton(icon: Icons.share, label: 'Share', tone: TurboIconTone.light, onPressed: () {}),
        TurboIconButton(icon: Icons.warning_amber, label: 'SOS', tone: TurboIconTone.sos, onPressed: () {}),
        const TurboAvatar(name: 'Ama'),
        const TurboAvatar(name: 'Kofi', rounded: true),
      ]),
    ]);

Widget _controls() => _pad([
      Wrap(spacing: TurboSpacing.sm, runSpacing: TurboSpacing.sm, children: [
        TurboChip(label: 'All', selected: true, onTap: () {}),
        TurboChip(label: 'Top-ups', onTap: () {}),
        TurboChip(label: 'Rides', onTap: () {}),
        const TurboChip(label: 'Fare locked', outline: true),
      ]),
      _g,
      const Wrap(spacing: TurboSpacing.sm, runSpacing: TurboSpacing.sm, children: [
        StatusChip(label: 'Completed', icon: Icons.check, tone: StatusTone.success),
        StatusChip(label: 'Pending', icon: Icons.schedule, tone: StatusTone.warning),
        StatusChip(label: 'Expired', icon: Icons.close, tone: StatusTone.danger),
        StatusChip(label: 'Cancelled', icon: Icons.remove),
      ]),
      _g,
      TurboSegmented(labels: const ['Trips', 'Shifts', 'Hours', 'Salary'], selectedIndex: 0, onSelected: (_) {}),
      _g,
      Row(children: [Switch(value: true, onChanged: (_) {}), const SizedBox(width: TurboSpacing.lg), Switch(value: false, onChanged: (_) {})]),
      _g,
      const TurboTextField(label: 'Full name on the Ghana Card'),
      _g,
      const TurboTextField(label: 'Phone number', prefixText: '+233 ', errorText: 'Enter all 9 digits after +233'),
      _g,
      const OtpField(),
      _g,
      const TurboBanner(message: 'This is a record. Payment is made by your employer outside the app.', icon: Icons.info_outline),
      _g,
      const TurboBanner(title: 'Kofi has arrived', message: 'Look for plate GR 4821-24.', icon: Icons.check, tone: StatusTone.success),
      _g,
      const TurboBanner(title: "You're offline", message: 'Last updated 19:32.', icon: Icons.wifi_off, tone: StatusTone.warning),
      _g,
      const TurboBanner(message: "This number isn't registered. Contact your supervisor.", icon: Icons.error_outline, tone: StatusTone.danger),
    ]);

Widget _trip() => _pad([
      Row(children: [
        const Expanded(child: BentoTile(label: 'Wallet', title: 'GH₵120.00', money: true, tone: BentoTone.lime, trailing: Icon(Icons.savings_outlined))),
        const SizedBox(width: TurboSpacing.sm),
        const Expanded(child: BentoTile(label: 'Safety', title: 'SOS and trip sharing', trailing: Icon(Icons.shield_outlined))),
      ]),
      _g,
      const TurboCard(selected: true, child: Text('Main Gate  ·  Nearest')),
      _g,
      const InnerPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your start PIN'), SizedBox(height: TurboSpacing.md), TripPin(digits: '4827')])),
      _g,
      const InnerPanel(child: TripPin(digits: '48', current: true)),
      _g,
      TurboKeypad(onDigit: (_) {}, onDelete: () {}, deleteLabel: 'Delete'),
      _g,
      MessageComposer(controller: TextEditingController(), hint: 'Write a reply', sendLabel: 'Send', onSend: () {}),
    ]);

void main() {
  final sheets = <String, (Widget Function(), double)>{'buttons': (_buttons, 1000), 'controls': (_controls, 1300), 'trip': (_trip, 1050)};
  for (final brightness in Brightness.values) {
    for (final e in sheets.entries) {
      testWidgets('design ${e.key} ${brightness.name}', (tester) async {
        await pumpTurbo(tester, RepaintBoundary(child: e.value.$1()), brightness: brightness, size: Size(390, e.value.$2), reduceMotion: true);
        await expectLater(find.byType(RepaintBoundary).first, matchesGoldenFile('design_${e.key}_${brightness.name}.png'));
      });
    }
  }
  testWidgets('design bar dark', (tester) async {
    await pumpTurbo(
      tester,
      RepaintBoundary(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingNavBar(selectedIndex: 1, onSelected: (_) {}, items: const [
            FloatingNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
            FloatingNavItem(icon: Icons.history, selectedIcon: Icons.history, label: 'Activity'),
            FloatingNavItem(icon: Icons.account_balance_wallet_outlined, selectedIcon: Icons.account_balance_wallet, label: 'Wallet'),
            FloatingNavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profile'),
          ]),
        ),
      ),
      size: const Size(390, 140),
      reduceMotion: true,
    );
    await expectLater(find.byType(RepaintBoundary).first, matchesGoldenFile('design_bar_dark.png'));
  });
}
