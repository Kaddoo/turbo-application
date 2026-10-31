import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/auth_draft.dart';
import '../../core/problem_messages.dart';
import '../../l10n/app_localizations.dart';
import 'safety_providers.dart';
import 'sos.dart';

/// Help one tap away: SOS, share the trip, trusted contacts, numbers to call.
class SafetyScreen extends ConsumerWidget {
  const SafetyScreen({super.key, this.rideId});

  final String? rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final contacts = ref.watch(contactsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.safetyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          children: [
            HoldToSos(rideId: rideId),
            const SizedBox(height: TurboSpacing.sm),
            Text(l10n.safetySosNote, style: text.bodySmall),
            const SizedBox(height: TurboSpacing.lg),
            TurboCard(
              onTap: rideId == null ? null : () => context.push('/ride/$rideId/share'),
              child: Row(
                children: [
                  const Icon(Icons.ios_share),
                  const SizedBox(width: TurboSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.safetyShareTrip, style: text.labelLarge),
                        if (rideId == null) Text(l10n.safetyShareNoRide, style: text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Row(
              children: [
                Expanded(child: Semantics(header: true, child: Text(l10n.safetyContacts, style: text.titleLarge))),
                if (contacts.hasValue) Text(l10n.safetyContactsCount(contacts.value!.length), style: text.bodySmall),
              ],
            ),
            const SizedBox(height: TurboSpacing.sm),
            contacts.when(
              loading: () => const LoadingState(rows: 1),
              error: (_, _) => ErrorState(message: l10n.safetyLoadFailed, onRetry: () => ref.read(contactsProvider.notifier).reload()),
              data: (list) => Column(
                children: [
                  if (list.isEmpty) Padding(
                    padding: const EdgeInsets.symmetric(vertical: TurboSpacing.md),
                    child: Text(l10n.safetyContactsEmpty, style: text.bodyMedium),
                  ),
                  for (final c in list)
                    TurboListRow(
                      title: c.name,
                      subtitle: displayPhone(c.phone),
                      leading: CircleAvatar(backgroundColor: t.colors.surface, child: Text(c.name.characters.first, style: text.labelLarge)),
                      trailing: IconButton(
                        tooltip: l10n.safetyContactRemove,
                        constraints: const BoxConstraints(minWidth: TurboSizes.minTap, minHeight: TurboSizes.minTap),
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          final ok = await showTurboConfirm(
                            context: context,
                            title: l10n.safetyContactRemoveTitle,
                            message: l10n.safetyContactRemoveBody,
                            confirmLabel: l10n.safetyContactRemove,
                            destructive: true,
                          );
                          if (ok) await ref.read(contactsProvider.notifier).remove(c.id);
                        },
                      ),
                    ),
                  const SizedBox(height: TurboSpacing.sm),
                  if (list.length < maxTrustedContacts)
                    TurboButton(
                      label: l10n.safetyAddContact,
                      variant: TurboButtonVariant.secondary,
                      icon: Icons.person_add_alt,
                      onPressed: () => showTurboSheet<void>(context: context, builder: (_) => const _AddContact()),
                    )
                  else
                    Text(l10n.safetyContactLimit, style: text.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.safetyCallForHelp, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            TurboButton(
              label: l10n.sosCall(emergencyNumber),
              variant: TurboButtonVariant.secondary,
              icon: Icons.call,
              onPressed: () => callNumber(emergencyNumber),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.safetyHowSosWorks, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            Text(l10n.safetyHowSosBody, style: text.bodyMedium),
            const SizedBox(height: TurboSpacing.lg),
            TextButton(
              onPressed: () => context.push('/support/new', extra: rideId),
              child: Text(l10n.safetyReport, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContact extends ConsumerStatefulWidget {
  const _AddContact();

  @override
  ConsumerState<_AddContact> createState() => _AddContactState();
}

class _AddContactState extends ConsumerState<_AddContact> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _relation = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _relation.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final phone = normalisePhone(_phone.text);
    if (_name.text.trim().isEmpty || phone == null) {
      setState(() => _error = l10n.safetyContactInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(contactsProvider.notifier).add(name: _name.text.trim(), phone: phone, relationship: _relation.text);
      if (mounted) Navigator.of(context).pop();
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = problemMessage(l10n, p));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TurboTextField(label: l10n.safetyContactName, controller: _name, textInputAction: TextInputAction.next),
          const SizedBox(height: TurboSpacing.md),
          TurboTextField(
            label: l10n.safetyContactPhone,
            controller: _phone,
            prefixText: '+233 ',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: TurboSpacing.md),
          TurboTextField(label: l10n.safetyContactRelation, controller: _relation),
          if (_error != null) ...[
            const SizedBox(height: TurboSpacing.md),
            Semantics(liveRegion: true, child: Text(_error!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.colors.danger))),
          ],
          const SizedBox(height: TurboSpacing.lg),
          TurboButton(label: l10n.safetyContactSave, loading: _busy, onPressed: _save),
        ],
      ),
    );
  }
}
