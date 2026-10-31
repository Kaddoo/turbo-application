import 'package:flutter/material.dart';

import '../brand/brand_tokens.dart';
import '../components/confirm_dialog.dart';
import '../components/list_row.dart';
import '../components/map_container.dart';
import '../components/money_text.dart';
import '../components/otp_field.dart';
import '../components/status_chip.dart';
import '../components/timeline.dart';
import '../components/turbo_button.dart';
import '../components/turbo_card.dart';
import '../components/turbo_sheet.dart';
import '../components/turbo_skeleton.dart';
import '../components/turbo_text_field.dart';
import '../components/turbo_toast.dart';
import '../components/wordmark.dart';
import '../states/shared_states.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Developer-only screen that shows every component. English is hard-coded
/// here on purpose; it never ships to people.
class TurboGalleryScreen extends StatefulWidget {
  const TurboGalleryScreen({super.key, required this.brand});

  final BrandTokens brand;

  @override
  State<TurboGalleryScreen> createState() => _TurboGalleryScreenState();
}

class _TurboGalleryScreenState extends State<TurboGalleryScreen> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final system = MediaQuery.platformBrightnessOf(context);
    final brightness = switch (_mode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => system,
    };
    return Theme(
      data: buildTurboTheme(widget.brand, brightness),
      child: _GalleryBody(
        mode: _mode,
        onMode: (m) => setState(() => _mode = m),
      ),
    );
  }
}

class _GalleryBody extends StatelessWidget {
  const _GalleryBody({required this.mode, required this.onMode});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onMode;

  Widget _section(BuildContext context, String title, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: TurboSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: TurboSpacing.md),
            child,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: TurboSpacing.md);
    return Scaffold(
      appBar: AppBar(title: const Wordmark()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          children: [
            Wrap(
              spacing: TurboSpacing.sm,
              runSpacing: TurboSpacing.sm,
              children: [
                for (final m in ThemeMode.values)
                  TurboButton(
                    label: switch (m) {
                      ThemeMode.system => 'System',
                      ThemeMode.light => 'Light',
                      ThemeMode.dark => 'Dark',
                    },
                    variant: m == mode ? TurboButtonVariant.primary : TurboButtonVariant.secondary,
                    expand: false,
                    onPressed: () => onMode(m),
                  ),
              ],
            ),
            const SizedBox(height: TurboSpacing.xl),
            _section(
              context,
              'Buttons',
              Column(
                children: [
                  TurboButton(label: 'Book for GH₵35.00', onPressed: () {}),
                  gap,
                  TurboButton(
                    label: 'Cancel ride',
                    variant: TurboButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  gap,
                  TurboButton(
                    label: 'Delete my account',
                    variant: TurboButtonVariant.destructive,
                    onPressed: () {},
                  ),
                  gap,
                  TurboButton(label: 'Loading', loading: true, onPressed: () {}),
                  gap,
                  const TurboButton(label: 'Disabled', onPressed: null),
                  gap,
                  TurboButton(label: 'Go on duty', large: true, onPressed: () {}),
                ],
              ),
            ),
            _section(
              context,
              'Fields',
              const Column(
                children: [
                  TurboTextField(
                    label: 'Phone number',
                    prefixText: '+233 ',
                    helper: "We'll text you a 6-digit code",
                    keyboardType: TextInputType.phone,
                  ),
                  gap,
                  TurboTextField(
                    label: 'Ghana Card number',
                    errorText: 'Enter the number as shown on the card.',
                  ),
                  gap,
                  OtpField(),
                  gap,
                  OtpField(errorText: 'That code is not right. Try again.'),
                ],
              ),
            ),
            _section(
              context,
              'Money',
              const Wrap(
                spacing: TurboSpacing.xl,
                runSpacing: TurboSpacing.sm,
                children: [
                  MoneyText(3500),
                  MoneyText(125050),
                  MoneyText(-600),
                ],
              ),
            ),
            _section(
              context,
              'Status',
              const Wrap(
                spacing: TurboSpacing.sm,
                runSpacing: TurboSpacing.sm,
                children: [
                  StatusChip(label: 'On duty', icon: Icons.check_circle_outline, tone: StatusTone.success),
                  StatusChip(label: 'Expires soon', icon: Icons.warning_amber, tone: StatusTone.warning),
                  StatusChip(label: 'Expired', icon: Icons.error_outline, tone: StatusTone.danger),
                  StatusChip(label: 'Pending', icon: Icons.schedule),
                ],
              ),
            ),
            _section(
              context,
              'Cards and rows',
              Column(
                children: [
                  const TurboCard(child: Text('Pickup at the main gate')),
                  gap,
                  TurboCard(
                    onTap: () {},
                    child: const Text('Tappable card'),
                  ),
                  gap,
                  TurboListRow(
                    title: 'Wallet top-up',
                    subtitle: '12 Oct, 14:05',
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    trailing: const MoneyText(5000),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            _section(
              context,
              'Overlays',
              Column(
                children: [
                  TurboButton(
                    label: 'Open sheet',
                    variant: TurboButtonVariant.secondary,
                    onPressed: () => showTurboSheet<void>(
                      context: context,
                      builder: (_) => const Text('Sheet content'),
                    ),
                  ),
                  gap,
                  TurboButton(
                    label: 'Show toast with undo',
                    variant: TurboButtonVariant.secondary,
                    onPressed: () => showTurboToast(
                      context,
                      'Place removed',
                      undoLabel: 'Undo',
                      onUndo: () {},
                    ),
                  ),
                  gap,
                  TurboButton(
                    label: 'Confirm dialog',
                    variant: TurboButtonVariant.secondary,
                    onPressed: () => showTurboConfirm(
                      context: context,
                      title: 'Delete your account?',
                      message: 'This cannot be undone.',
                      confirmLabel: 'Delete',
                      destructive: true,
                      typeToConfirm: 'DELETE',
                    ),
                  ),
                ],
              ),
            ),
            _section(context, 'Map', const TurboMapContainer()),
            _section(
              context,
              'Timeline',
              const TurboTimeline(
                entries: [
                  TimelineEntry(title: 'Ride requested', status: TimelineStatus.done, detail: '14:02'),
                  TimelineEntry(title: 'Driver assigned', status: TimelineStatus.done, detail: '14:03'),
                  TimelineEntry(title: 'Driver arrived', status: TimelineStatus.current),
                  TimelineEntry(title: 'Trip complete', status: TimelineStatus.upcoming),
                ],
              ),
            ),
            _section(context, 'Loading', const LoadingState(rows: 2)),
            _section(
              context,
              'Empty',
              EmptyState(
                icon: Icons.directions_car_outlined,
                message: 'Your rides will appear here.',
                actionLabel: 'Book a ride',
                onAction: () {},
              ),
            ),
            _section(context, 'Error', ErrorState(onRetry: () {})),
            _section(
              context,
              'Skeleton',
              const TurboSkeleton(width: 200, height: TurboSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }
}
