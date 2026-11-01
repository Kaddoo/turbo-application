import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/gate.dart';
import '../../core/profile.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(child: Center(child: SizedBox(width: 240, child: LoadingState(rows: 1)))),
      );
}

/// Shown when the app could not read the session or profile and has no cached
/// copy. The only action is to try again.
class BootErrorScreen extends ConsumerWidget {
  const BootErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SystemMessage(
      icon: Icons.warning_amber_rounded,
      title: l10n.bootErrorTitle,
      message: l10n.bootErrorBody,
      action: TurboButton(
        label: l10n.tryAgain,
        driver: true,
        onPressed: () {
          ref.invalidate(sessionProvider);
          ref.invalidate(profileProvider);
          ref.read(gateProvider.notifier).recheck();
        },
      ),
    );
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SystemMessage(
      icon: Icons.system_update_outlined,
      title: l10n.updateRequiredTitle,
      message: l10n.updateRequiredBody(context.turbo.brand.appName),
    );
  }
}

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final message = ref.watch(gateProvider).value?.maintenanceMessage;
    return SystemMessage(
      icon: Icons.construction_outlined,
      title: l10n.maintenanceTitle,
      message: message ?? l10n.maintenanceBody(context.turbo.brand.appName),
      action: TurboButton(
        label: l10n.maintenanceCheckAgain,
        driver: true,
        onPressed: () => ref.read(gateProvider.notifier).recheck(),
      ),
    );
  }
}

class SuspendedScreen extends StatelessWidget {
  const SuspendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SystemMessage(
      icon: Icons.lock_outline,
      title: l10n.suspendedTitle,
      message: l10n.suspendedBody,
    );
  }
}
