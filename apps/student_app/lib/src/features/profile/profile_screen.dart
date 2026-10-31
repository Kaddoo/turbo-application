import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth_draft.dart';
import '../../core/me.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';
import '../home/service_area.dart';

final sessionsProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getStudentApi().listSessions()).data!.items.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final me = ref.watch(meProvider);
    final student = switch (me.value) {
      MeLoaded(:final student) => student,
      _ => null,
    };
    final places = ref.watch(savedPlacesProvider);
    final sessions = ref.watch(sessionsProvider);
    final legal = ref.watch(legalProvider).value;
    final version = ref.watch(appVersionProvider).value;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: SafeArea(
          child: me.isLoading
              ? const LoadingState()
              : ErrorState(message: l10n.profileLoadFailed, onRetry: () => ref.read(meProvider.notifier).reload()),
        ),
      );
    }

    Future<void> run(Future<void> Function() action) async {
      try {
        await action();
      } catch (e) {
        if (context.mounted) showTurboToast(context, problemMessage(l10n, problemOf(e)));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: TurboSpacing.xxl,
                  backgroundColor: t.colors.surface,
                  child: Text((student.fullName ?? '?').characters.first, style: text.titleLarge),
                ),
                const SizedBox(width: TurboSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.fullName ?? '', style: text.titleLarge),
                      Text(displayPhone(student.phone), style: text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TurboSpacing.sm),
            Text(l10n.profileChangePhone, style: text.bodySmall),
            const SizedBox(height: TurboSpacing.lg),
            TurboCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  TurboListRow(
                    title: l10n.profileEmail,
                    trailing: Text(student.email ?? l10n.profileEmailAdd, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
                    onTap: () => showTurboSheet<void>(context: context, builder: (_) => _EmailSheet(current: student.email)),
                  ),
                  const Divider(),
                  TurboListRow(title: l10n.navActivity, leading: const Icon(Icons.receipt_long_outlined), onTap: () => context.go('/activity')),
                  const Divider(),
                  TurboListRow(title: l10n.safetyTitle, leading: const Icon(Icons.shield_outlined), onTap: () => context.push('/safety')),
                  const Divider(),
                  TurboListRow(title: l10n.supportTitle, leading: const Icon(Icons.support_agent), onTap: () => context.push('/support')),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.profileSavedPlaces, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            places.when(
              loading: () => const LoadingState(rows: 1),
              error: (_, _) => ErrorState(message: l10n.profileLoadFailed, onRetry: () => ref.invalidate(savedPlacesProvider)),
              data: (list) => list.isEmpty
                  ? Text(l10n.profileSavedPlacesEmpty, style: text.bodyMedium)
                  : Column(
                      children: [
                        for (final p in list)
                          TurboListRow(
                            title: p.label,
                            subtitle: p.location.label,
                            leading: const Icon(Icons.bookmark_border),
                            trailing: IconButton(
                              tooltip: l10n.profileRemovePlace,
                              constraints: const BoxConstraints(minWidth: TurboSizes.minTap, minHeight: TurboSizes.minTap),
                              icon: const Icon(Icons.close),
                              onPressed: () => run(() async {
                                await ref.read(clientProvider).api.getStudentApi().deleteSavedPlace(id: p.id);
                                ref.invalidate(savedPlacesProvider);
                              }),
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.profileDevices, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            sessions.when(
              loading: () => const LoadingState(rows: 1),
              error: (_, _) => ErrorState(message: l10n.profileLoadFailed, onRetry: () => ref.invalidate(sessionsProvider)),
              data: (list) => Column(
                children: [
                  for (final s in list)
                    TurboListRow(
                      title: s.current ? l10n.profileThisDevice : (s.deviceName ?? s.platform.value),
                      subtitle: l10n.profileDeviceLastUsed(DateFormat('d MMM, HH:mm').format(s.lastUsedAt.toUtc())),
                      leading: const Icon(Icons.smartphone),
                      trailing: s.current
                          ? null
                          : TextButton(
                              onPressed: () => run(() async {
                                await ref.read(clientProvider).api.getStudentApi().revokeSession(id: s.id);
                                ref.invalidate(sessionsProvider);
                              }),
                              child: Text(l10n.profileSignOutDevice),
                            ),
                    ),
                  if (list.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: TurboSpacing.sm),
                      child: TurboButton(
                        label: l10n.profileSignOutOthers,
                        variant: TurboButtonVariant.secondary,
                        onPressed: () => run(() async {
                          await ref.read(clientProvider).api.getStudentApi().revokeOtherSessions();
                          ref.invalidate(sessionsProvider);
                        }),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            TurboCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (legal != null) ...[
                    TurboListRow(
                      title: l10n.profileTerms,
                      trailing: const Icon(Icons.open_in_new, size: TurboSizes.iconSm),
                      onTap: () => launchUrl(Uri.parse(legal.termsUrl), mode: LaunchMode.externalApplication),
                    ),
                    const Divider(),
                    TurboListRow(
                      title: l10n.profilePrivacy,
                      trailing: const Icon(Icons.open_in_new, size: TurboSizes.iconSm),
                      onTap: () => launchUrl(Uri.parse(legal.privacyUrl), mode: LaunchMode.externalApplication),
                    ),
                    const Divider(),
                  ],
                  TurboListRow(title: l10n.profileVersion, trailing: Text(version ?? '', style: text.bodyMedium)),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            TurboButton(
              label: l10n.profileSignOut,
              variant: TurboButtonVariant.secondary,
              onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            ),
            const SizedBox(height: TurboSpacing.md),
            TurboButton(
              label: l10n.profileDelete,
              variant: TurboButtonVariant.destructive,
              onPressed: () async {
                final ok = await showTurboConfirm(
                  context: context,
                  title: l10n.profileDeleteTitle,
                  message: l10n.profileDeleteBody,
                  confirmLabel: l10n.profileDeleteConfirmLabel,
                  destructive: true,
                  typeToConfirm: l10n.profileDeleteConfirmLabel.toUpperCase(),
                );
                if (!ok) return;
                await run(() async {
                  await ref.read(clientProvider).api.getStudentApi().requestDeletion();
                  if (context.mounted) showTurboToast(context, l10n.profileDeleteRequested);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailSheet extends ConsumerStatefulWidget {
  const _EmailSheet({this.current});

  final String? current;

  @override
  ConsumerState<_EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends ConsumerState<_EmailSheet> {
  late final _controller = TextEditingController(text: widget.current ?? '');
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final email = _controller.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _error = l10n.profileEmailInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(clientProvider).api.getStudentApi().updateMe(studentUpdate: StudentUpdate(email: email));
      await ref.read(meProvider.notifier).reload();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = problemMessage(l10n, problemOf(e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TurboTextField(label: l10n.profileEmail, controller: _controller, keyboardType: TextInputType.emailAddress, errorText: _error),
        const SizedBox(height: TurboSpacing.lg),
        TurboButton(label: l10n.profileEmailSave, loading: _busy, onPressed: _save),
      ],
    );
  }
}
