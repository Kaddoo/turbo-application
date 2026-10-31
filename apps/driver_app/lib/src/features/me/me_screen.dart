import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth_draft.dart';
import '../../core/profile.dart';
import '../../core/providers.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';

final sessionsProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getStudentApi().listSessions()).data!.items.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final loaded = ref.watch(profileProvider).value;
    final profile = loaded is ProfileLoaded ? loaded.profile : null;
    final sessions = ref.watch(sessionsProvider);
    final legal = ref.watch(legalProvider).value;
    final version = ref.watch(appVersionProvider).value;
    if (profile == null) return const Scaffold(body: SafeArea(child: LoadingState()));
    final v = profile.vehicle;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.meTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          children: [
            Row(
              children: [
                CircleAvatar(radius: TurboSpacing.xxl, backgroundColor: t.colors.surface, child: Text(profile.fullName.characters.first, style: text.titleLarge)),
                const SizedBox(width: TurboSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName, style: text.titleLarge),
                      Text(displayPhone(profile.phone), style: text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TurboSpacing.lg),
            TurboCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (v != null) ...[
                    TurboListRow(
                      title: l10n.meVehicle,
                      subtitle: '${v.colour} ${v.make} ${v.model}',
                      leading: const Icon(Icons.directions_car_outlined),
                      trailing: Text(v.plateNumber, style: text.titleLarge),
                    ),
                    const Divider(),
                  ],
                  TurboListRow(title: l10n.meShifts, leading: const Icon(Icons.event_outlined), onTap: () => context.push('/me/shifts')),
                  const Divider(),
                  TurboListRow(title: l10n.meAttendance, leading: const Icon(Icons.schedule), onTap: () => context.push('/me/attendance')),
                  const Divider(),
                  TurboListRow(title: l10n.meSalary, leading: const Icon(Icons.payments_outlined), onTap: () => context.push('/me/salary')),
                  const Divider(),
                  TurboListRow(title: l10n.meHelp, leading: const Icon(Icons.support_agent), onTap: () => context.push('/support')),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.meDevices, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            sessions.when(
              loading: () => const LoadingState(rows: 1),
              error: (_, _) => ErrorState(message: l10n.meLoadFailed, onRetry: () => ref.invalidate(sessionsProvider)),
              data: (list) => Column(
                children: [
                  for (final s in list)
                    TurboListRow(
                      title: s.current ? l10n.meThisDevice : (s.deviceName ?? s.platform.value),
                      subtitle: l10n.meLastUsed(DateFormat('d MMM, HH:mm').format(s.lastUsedAt.toUtc())),
                      leading: const Icon(Icons.smartphone),
                      trailing: s.current
                          ? null
                          : TextButton(
                              onPressed: () async {
                                await ref.read(clientProvider).api.getStudentApi().revokeSession(id: s.id);
                                ref.invalidate(sessionsProvider);
                              },
                              child: Text(l10n.meSignOutDevice),
                            ),
                    ),
                  if (list.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: TurboSpacing.sm),
                      child: TurboButton(
                        label: l10n.meSignOutOthers,
                        variant: TurboButtonVariant.secondary,
                        onPressed: () async {
                          await ref.read(clientProvider).api.getStudentApi().revokeOtherSessions();
                          ref.invalidate(sessionsProvider);
                        },
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
                      title: l10n.meTerms,
                      trailing: const Icon(Icons.open_in_new, size: TurboSizes.iconSm),
                      onTap: () => launchUrl(Uri.parse(legal.termsUrl), mode: LaunchMode.externalApplication),
                    ),
                    const Divider(),
                    TurboListRow(
                      title: l10n.mePrivacy,
                      trailing: const Icon(Icons.open_in_new, size: TurboSizes.iconSm),
                      onTap: () => launchUrl(Uri.parse(legal.privacyUrl), mode: LaunchMode.externalApplication),
                    ),
                    const Divider(),
                  ],
                  TurboListRow(title: l10n.meVersion, trailing: Text(version ?? '', style: text.bodyMedium)),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.xl),
            // Drivers cannot delete their account here; staff handle it.
            TurboButton(label: l10n.meSignOut, variant: TurboButtonVariant.secondary, onPressed: () => ref.read(sessionProvider.notifier).signOut()),
          ],
        ),
      ),
    );
  }
}
