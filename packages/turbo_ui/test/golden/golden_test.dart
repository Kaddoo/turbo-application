import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../support/helpers.dart';

/// Golden sheets for the core components, light and dark. A rebrand changes
/// these images; review the diff, then run `flutter test --update-goldens`.
Widget _controls() => Padding(
      padding: const EdgeInsets.all(TurboSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wordmark(),
          const SizedBox(height: TurboSpacing.lg),
          TurboButton(label: 'Book for GH₵35.00', onPressed: () {}),
          const SizedBox(height: TurboSpacing.sm),
          TurboButton(label: 'Cancel ride', variant: TurboButtonVariant.secondary, onPressed: () {}),
          const SizedBox(height: TurboSpacing.sm),
          TurboButton(label: 'Delete', variant: TurboButtonVariant.destructive, onPressed: () {}),
          const SizedBox(height: TurboSpacing.sm),
          const TurboButton(label: 'Disabled', onPressed: null),
          const SizedBox(height: TurboSpacing.lg),
          const TurboTextField(label: 'Phone number', helper: 'Helper text'),
          const SizedBox(height: TurboSpacing.sm),
          const TurboTextField(label: 'Ghana Card', errorText: 'Enter the number on the card.'),
          const SizedBox(height: TurboSpacing.lg),
          const OtpField(),
        ],
      ),
    );

Widget _content() => Padding(
      padding: const EdgeInsets.all(TurboSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MoneyText(3500),
          const SizedBox(height: TurboSpacing.md),
          const Wrap(spacing: TurboSpacing.sm, children: [
            StatusChip(label: 'On duty', icon: Icons.check_circle_outline, tone: StatusTone.success),
            StatusChip(label: 'Expiring', icon: Icons.warning_amber, tone: StatusTone.warning),
            StatusChip(label: 'Expired', icon: Icons.error_outline, tone: StatusTone.danger),
          ]),
          const SizedBox(height: TurboSpacing.md),
          const TurboCard(child: Text('Pickup at the main gate')),
          const SizedBox(height: TurboSpacing.sm),
          TurboListRow(title: 'Wallet top-up', subtitle: '12 Oct, 14:05', trailing: const MoneyText(5000), onTap: () {}),
          const SizedBox(height: TurboSpacing.md),
          const TurboMapContainer(height: 120),
          const SizedBox(height: TurboSpacing.md),
          const TurboTimeline(entries: [
            TimelineEntry(title: 'Ride requested', status: TimelineStatus.done, detail: '14:02'),
            TimelineEntry(title: 'Driver arrived', status: TimelineStatus.current),
            TimelineEntry(title: 'Trip complete', status: TimelineStatus.upcoming),
          ]),
        ],
      ),
    );

Widget _states() => Column(
      children: [
        const Expanded(child: LoadingState(rows: 1)),
        Expanded(child: EmptyState(icon: Icons.directions_car_outlined, message: 'Your rides will appear here.', actionLabel: 'Book a ride', onAction: () {})),
        Expanded(child: ErrorState(onRetry: () {})),
      ],
    );

void main() {
  final sheets = <String, Widget Function()>{
    'controls': _controls,
    'content': _content,
    'states': _states,
  };
  for (final brightness in Brightness.values) {
    for (final entry in sheets.entries) {
      testWidgets('${entry.key} ${brightness.name}', (tester) async {
        await pumpTurbo(
          tester,
          RepaintBoundary(child: entry.value()),
          brightness: brightness,
          size: Size(390, entry.key == 'controls' ? 1050 : 900),
          reduceMotion: true,
        );
        await expectLater(
          find.byType(RepaintBoundary).first,
          matchesGoldenFile('${entry.key}_${brightness.name}.png'),
        );
      });
    }
  }
}
