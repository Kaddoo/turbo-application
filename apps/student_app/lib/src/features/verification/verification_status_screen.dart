import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/me.dart';
import '../../l10n/app_localizations.dart';
import 'draft.dart';
import 'resubmit.dart';

/// Where the student stands. Reads the server on open, every 30 seconds while
/// visible, and when the app comes back to the front.
class VerificationStatusScreen extends ConsumerStatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  ConsumerState<VerificationStatusScreen> createState() => _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends ConsumerState<VerificationStatusScreen> with WidgetsBindingObserver {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _poll = Timer.periodic(const Duration(seconds: 30), (_) => ref.invalidate(verificationStateProvider));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(verificationStateProvider);
  }

  Future<void> _refresh() async {
    ref.invalidate(verificationStateProvider);
    try {
      await ref.read(verificationStateProvider.future);
    } catch (_) {
      // The error state shows on the screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final state = ref.watch(verificationStateProvider);

    Widget view({
      required IconData icon,
      required Color color,
      Widget? hero,
      required String title,
      String? body,
      String? note,
      Widget? action,
    }) =>
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              const SizedBox(height: TurboSpacing.xxl),
              hero ?? Icon(icon, size: TurboSizes.iconLg + TurboSpacing.xl, color: color),
              const SizedBox(height: TurboSpacing.xl),
              Semantics(header: true, liveRegion: true, child: Text(title, style: text.headlineMedium, textAlign: TextAlign.center)),
              if (body != null) ...[
                const SizedBox(height: TurboSpacing.md),
                Text(body, style: text.bodyLarge, textAlign: TextAlign.center),
              ],
              if (note != null) ...[
                const SizedBox(height: TurboSpacing.md),
                Text(note, style: text.bodyMedium, textAlign: TextAlign.center),
              ],
              if (action != null) ...[const SizedBox(height: TurboSpacing.xxl), action],
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: state.when(
          loading: () => const LoadingState(rows: 1),
          error: (_, _) => ErrorState(message: l10n.statusRefreshFailed, onRetry: _refresh),
          data: (v) => switch (v.status) {
            VerificationStatus.approved => view(
                icon: Icons.check_circle_outline,
                color: t.colors.success,
                hero: const PhotoCard(asset: 'student-campus.jpg', height: 280),
                title: l10n.statusApprovedTitle,
                body: l10n.statusApprovedBody,
                action: TurboButton(
                  label: l10n.continueAction,
                  large: true,
                  onPressed: () async {
                    await ref.read(meProvider.notifier).reload();
                    if (context.mounted) context.go('/home');
                  },
                ),
              ),
            VerificationStatus.needsAttention => view(
                icon: Icons.info_outline,
                color: t.colors.warning,
                title: l10n.statusNeedsAttentionTitle,
                body: v.message ?? l10n.statusNeedsAttentionFallback,
                action: TurboButton(
                  label: l10n.statusResubmit,
                  large: true,
                  // The typed details stay in the saved draft; only photos are retaken.
                  onPressed: () => ref.read(resubmitProvider.notifier).start(),
                ),
              ),
            VerificationStatus.rejected => view(
                icon: Icons.block,
                color: t.colors.danger,
                title: l10n.statusRejectedTitle,
                body: v.message ?? l10n.statusRejectedFallback,
                note: l10n.statusRejectedContact,
              ),
            _ => view(
                icon: Icons.schedule,
                color: t.colors.textSecondary,
                title: l10n.statusPendingTitle,
                body: l10n.statusPendingBody,
              ),
          },
        ),
      ),
    );
  }
}
