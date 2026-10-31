import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/gate.dart';
import '../../core/me.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';

class _Centered extends StatelessWidget {
  const _Centered({required this.icon, required this.title, this.body, this.action});

  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: TurboSizes.iconLg, color: t.colors.textSecondary),
                const SizedBox(height: TurboSpacing.lg),
                Semantics(header: true, child: Text(title, style: text.titleLarge, textAlign: TextAlign.center)),
                if (body != null) ...[
                  const SizedBox(height: TurboSpacing.md),
                  Text(body!, style: text.bodyLarge, textAlign: TextAlign.center),
                ],
                if (action != null) ...[const SizedBox(height: TurboSpacing.xl), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    return Scaffold(
      body: SafeArea(
        child: ErrorState(
          message: '${l10n.bootErrorTitle}. ${l10n.bootErrorBody}',
          onRetry: () {
            ref.invalidate(sessionProvider);
            ref.invalidate(meProvider);
            ref.read(gateProvider.notifier).recheck();
          },
        ),
      ),
    );
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Centered(
      icon: Icons.system_update_outlined,
      title: l10n.updateRequiredTitle,
      body: l10n.updateRequiredBody(context.turbo.brand.appName),
    );
  }
}

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final message = ref.watch(gateProvider).value?.maintenanceMessage;
    return _Centered(
      icon: Icons.construction_outlined,
      title: l10n.maintenanceTitle,
      body: message ?? l10n.maintenanceBody(context.turbo.brand.appName),
      action: TurboButton(
        label: l10n.maintenanceCheckAgain,
        expand: false,
        variant: TurboButtonVariant.secondary,
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
    return _Centered(
      icon: Icons.block,
      title: l10n.problemAccountSuspended,
    );
  }
}
