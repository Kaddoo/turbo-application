import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/driver_gaps.dart';
import '../../l10n/app_localizations.dart';

/// Calls the supervisor. Drawn only when a number is known (CR-6), so it never
/// shows a button that goes nowhere.
class CallSupervisorButton extends ConsumerWidget {
  const CallSupervisorButton({super.key, this.driver = false});

  final bool driver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = ref.watch(supervisorPhoneProvider).value;
    if (phone == null) return const SizedBox.shrink();
    return TurboButton(
      label: AppLocalizations.of(context).callSupervisor,
      driver: driver,
      variant: TurboButtonVariant.secondary,
      onPressed: () => launchUrl(Uri(scheme: 'tel', path: phone)),
    );
  }
}
