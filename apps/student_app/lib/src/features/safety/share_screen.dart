import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/auth_draft.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'safety_providers.dart';

/// Choose trusted contacts to follow a ride. The link works without an account
/// and stops when the ride ends.
class ShareTripScreen extends ConsumerStatefulWidget {
  const ShareTripScreen({super.key, required this.rideId});

  final String rideId;

  @override
  ConsumerState<ShareTripScreen> createState() => _ShareTripScreenState();
}

class _ShareTripScreenState extends ConsumerState<ShareTripScreen> {
  final _chosen = <String>{};
  bool _busy = false;
  String? _error;
  TripShare? _shared;

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await ref.read(clientProvider).api.getSafetyApi().shareRide(
            id: widget.rideId,
            shareCreate: ShareCreate(trustedContactIds: _chosen.toList()),
          );
      if (mounted) setState(() => _shared = response.data);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.shareFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final contacts = ref.watch(contactsProvider);
    final shared = _shared;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareTitle)),
      body: SafeArea(
        child: shared != null
            ? ListView(
                padding: const EdgeInsets.all(TurboSpacing.xl),
                children: [
                  Icon(Icons.check_circle_outline, size: TurboSizes.iconLg + TurboSpacing.xl, color: t.colors.success),
                  const SizedBox(height: TurboSpacing.lg),
                  Semantics(header: true, liveRegion: true, child: Text(l10n.shareSent, style: text.headlineMedium)),
                  const SizedBox(height: TurboSpacing.md),
                  Text(l10n.shareSentBody, style: text.bodyLarge),
                  const SizedBox(height: TurboSpacing.xl),
                  TurboButton(
                    label: l10n.shareCopy,
                    variant: TurboButtonVariant.secondary,
                    icon: Icons.link,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: shared.shareUrl));
                      if (context.mounted) showTurboToast(context, l10n.shareCopied);
                    },
                  ),
                  const SizedBox(height: TurboSpacing.md),
                  TurboButton(label: l10n.rideDone, onPressed: () => context.pop()),
                ],
              )
            : contacts.when(
                loading: () => const LoadingState(),
                error: (_, _) => ErrorState(message: l10n.safetyLoadFailed, onRetry: () => ref.read(contactsProvider.notifier).reload()),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.group_outlined,
                        message: l10n.shareNeedContact,
                        actionLabel: l10n.safetyAddContact,
                        onAction: () => context.pushReplacement('/safety', extra: widget.rideId),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(TurboSpacing.lg),
                              children: [
                                Text(l10n.shareChoose, style: text.titleLarge),
                                const SizedBox(height: TurboSpacing.md),
                                for (final c in list)
                                  CheckboxListTile(
                                    value: _chosen.contains(c.id),
                                    onChanged: (v) => setState(() => v == true ? _chosen.add(c.id) : _chosen.remove(c.id)),
                                    title: Text(c.name, style: text.bodyLarge),
                                    subtitle: Text(displayPhone(c.phone), style: text.bodySmall),
                                    activeColor: t.colors.accent,
                                    checkColor: t.colors.onAccent,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                if (_error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: TurboSpacing.md),
                                    child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger)),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(TurboSpacing.lg),
                            child: TurboButton(label: l10n.shareSend, large: true, loading: _busy, onPressed: _chosen.isEmpty ? null : _send),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
