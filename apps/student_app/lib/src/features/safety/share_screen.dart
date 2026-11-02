import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../ride/ride_providers.dart';
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
    final ride = ref.watch(rideProvider(widget.rideId)).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareTitle)),
      body: SafeArea(
        child: shared != null
            ? ListView(
                padding: const EdgeInsets.all(TurboSpacing.xl),
                children: [
                  const SizedBox(height: TurboSpacing.xl),
                  const Center(child: HeroIcon(art: TurboArt.checkMarkButton)),
                  const SizedBox(height: TurboSpacing.xl),
                  Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(l10n.shareSent, style: text.headlineMedium, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: TurboSpacing.md),
                  Text(l10n.shareSentBody, style: text.bodyLarge, textAlign: TextAlign.center),
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
                        art: TurboArt.bustsInSilhouette,
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
                                Semantics(header: true, child: Text(l10n.shareChoose, style: text.titleSmall)),
                                const SizedBox(height: TurboSpacing.md),
                                // Contacts are chips with their picture; tap to choose who follows.
                                Wrap(
                                  spacing: TurboSpacing.sm,
                                  runSpacing: TurboSpacing.sm,
                                  children: [
                                    for (final c in list)
                                      TurboChip(
                                        label: c.name,
                                        leading: TurboAvatar(name: c.name, small: true),
                                        selected: _chosen.contains(c.id),
                                        onTap: () => setState(() => _chosen.contains(c.id) ? _chosen.remove(c.id) : _chosen.add(c.id)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: TurboSpacing.md),
                                // What the contacts will see: the trip, over a photo.
                                PhotoCard(
                                  asset: 'trip-status-intersection.jpg',
                                  height: 160 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.sharePreviewTitle, style: text.labelLarge),
                                      if (ride != null) ...[
                                        const SizedBox(height: TurboSpacing.xs),
                                        Text('${ride.pickup.label ?? ''} → ${ride.dropoff.label ?? ''}', style: text.titleMedium),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: TurboSpacing.sm),
                                Text(l10n.sharePreviewBody, style: text.bodyMedium),
                                if (_error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: TurboSpacing.md),
                                    child: Semantics(
                                      liveRegion: true,
                                      child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(TurboSpacing.lg),
                            child: TurboButton(
                              label: _chosen.isEmpty ? l10n.shareSend : l10n.shareSendTo(_chosen.length),
                              loading: _busy,
                              onPressed: _chosen.isEmpty ? null : _send,
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
