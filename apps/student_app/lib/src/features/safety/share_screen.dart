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
                  const SizedBox(height: TurboSpacing.xl),
                  const Center(child: BadgeIcon(icon: Icons.check)),
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
                                Semantics(header: true, child: Text(l10n.shareChoose, style: text.titleLarge)),
                                const SizedBox(height: TurboSpacing.md),
                                for (final c in list)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
                                    child: _ContactTile(
                                      name: c.name,
                                      phone: displayPhone(c.phone),
                                      selected: _chosen.contains(c.id),
                                      onChanged: (v) => setState(() => v ? _chosen.add(c.id) : _chosen.remove(c.id)),
                                    ),
                                  ),
                                const SizedBox(height: TurboSpacing.md),
                                TurboCard(
                                  color: t.colors.surface,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.sharePreviewTitle, style: text.labelLarge),
                                      const SizedBox(height: TurboSpacing.sm),
                                      Text(l10n.sharePreviewBody, style: text.bodyMedium),
                                    ],
                                  ),
                                ),
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
                              large: true,
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

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.name, required this.phone, required this.selected, required this.onChanged});

  final String name;
  final String phone;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      checked: selected,
      label: '$name, $phone',
      excludeSemantics: true,
      onTap: () => onChanged(!selected),
      child: TurboCard(
        onTap: () => onChanged(!selected),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: t.colors.background,
              child: Text(name.characters.first, style: text.labelLarge),
            ),
            const SizedBox(width: TurboSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: text.bodyLarge),
                  Text(phone, style: text.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? t.colors.textPrimary : t.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
