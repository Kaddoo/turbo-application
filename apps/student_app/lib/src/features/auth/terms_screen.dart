import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth_draft.dart';
import '../../core/me.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';

/// Used in two places: before the first sign-in completes (the code is held
/// until the person agrees) and after sign-in when the terms version changed.
class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _agree(LegalVersions legal) async {
    final l10n = AppLocalizations.of(context);
    final draft = ref.read(authDraftProvider);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final api = ref.read(clientProvider).api;
      if (draft.pendingCode != null && draft.phone != null) {
        // First sign-in: send the held code again, now with the versions agreed.
        final response = await api.getAuthApi().verifyOtp(
              otpVerify: OtpVerify(
                phone: draft.phone!,
                code: draft.pendingCode!,
                role: OtpVerifyRoleEnum.student,
                clientType: OtpVerifyClientTypeEnum.mobile,
                acceptedTermsVersion: legal.termsVersion,
                acceptedPrivacyVersion: legal.privacyVersion,
              ),
            );
        await ref.read(sessionProvider.notifier).signedIn(response.data!);
        ref.read(authDraftProvider.notifier).reset();
      } else {
        await api.getStudentApi().acceptTerms(
              termsAcceptance: TermsAcceptance(
                termsVersion: legal.termsVersion,
                privacyVersion: legal.privacyVersion,
              ),
            );
        await ref.read(meProvider.notifier).reload();
      }
    } catch (e) {
      final problem = problemOf(e);
      if (!mounted) return;
      if (draft.pendingCode != null &&
          (problem.code == ProblemCode.otpInvalid.value || problem.code == ProblemCode.otpExpired.value)) {
        // The held code was used up or timed out; start the code step again.
        ref.read(authDraftProvider.notifier).set(draft.copyWith(clearPending: true));
        context.go('/phone');
      } else {
        setState(() => _error = problemMessage(l10n, problem));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final legal = ref.watch(legalProvider);
    final appName = context.turbo.brand.appName;
    final versions = legal.value;

    // Built inside the dark layout so text and icons take its colours.
    Widget body(BuildContext context) {
      final t = context.turbo;
      final text = Theme.of(context).textTheme;

      Widget check(String line) => Padding(
            padding: const EdgeInsets.only(bottom: TurboSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, size: TurboSizes.iconSm, color: t.colors.success),
                const SizedBox(width: TurboSpacing.md),
                Expanded(child: Text(line, style: text.bodyMedium)),
              ],
            ),
          );

      Widget why(IconData icon, String title, String line) => Padding(
            padding: const EdgeInsets.only(bottom: TurboSpacing.md),
            child: TurboCard(
              color: t.colors.surfaceRaised,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: TurboSizes.iconMd),
                  const SizedBox(width: TurboSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(header: true, child: Text(title, style: text.labelMedium)),
                        const SizedBox(height: TurboSpacing.xs),
                        Text(line, style: text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

      Widget link(String label, String url) => TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(TurboSizes.minTap, TurboSizes.minTap)),
            onPressed: () => _open(url),
            child: Text(label, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
          );

      return legal.when(
        loading: () => const LoadingState(rows: 2),
        error: (_, _) => ErrorState(
          message: l10n.termsLoadFailed,
          onRetry: () => ref.invalidate(legalProvider),
        ),
        data: (v) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            check(l10n.termsBulletRules(appName)),
            check(l10n.termsBulletData),
            const SizedBox(height: TurboSpacing.sm),
            why(Icons.place_outlined, l10n.termsWhyLocationTitle, l10n.termsWhyLocation),
            why(Icons.photo_camera_outlined, l10n.termsWhyCameraTitle, l10n.termsWhyCamera),
            Wrap(
              spacing: TurboSpacing.lg,
              children: [link(l10n.termsReadTerms, v.termsUrl), link(l10n.termsReadPrivacy, v.privacyUrl)],
            ),
          ],
        ),
      );
    }

    return AuthLayout(
      title: l10n.termsTitle,
      onBack: null,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: TurboSpacing.md),
              child: Builder(
                builder: (context) => Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.turbo.colors.danger),
                  ),
                ),
              ),
            ),
          TurboButton(
            label: l10n.termsAgree,
            large: true,
            loading: _busy,
            onPressed: versions == null ? null : () => _agree(versions),
          ),
        ],
      ),
      children: [Builder(builder: body)],
    );
  }
}
