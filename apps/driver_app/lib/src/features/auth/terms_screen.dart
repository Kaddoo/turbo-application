import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth_draft.dart';
import '../../core/profile.dart';
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
                role: OtpVerifyRoleEnum.driver,
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
        await ref.read(profileProvider.notifier).reload();
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
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final legal = ref.watch(legalProvider);
    final appName = t.brand.appName;

    Widget section(String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: TurboSpacing.lg),
          child: TurboCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: text.labelLarge)),
                const SizedBox(height: TurboSpacing.sm),
                Text(body, style: text.bodyMedium),
              ],
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: legal.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            message: l10n.termsLoadFailed,
            onRetry: () => ref.invalidate(legalProvider),
          ),
          data: (versions) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(TurboSpacing.xl),
                  children: [
                    Semantics(header: true, child: Text(l10n.termsTitle, style: text.headlineMedium)),
                    const SizedBox(height: TurboSpacing.lg),
                    Text(l10n.termsBulletRules(appName), style: text.bodyLarge),
                    const SizedBox(height: TurboSpacing.md),
                    Text(l10n.termsBulletData, style: text.bodyLarge),
                    const SizedBox(height: TurboSpacing.xl),
                    section(l10n.termsWhyLocationTitle, l10n.termsWhyLocation),
                          Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => _open(versions.termsUrl),
                        child: Text(l10n.termsReadTerms, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => _open(versions.privacyUrl),
                        child: Text(l10n.termsReadPrivacy, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
                      ),
                    ),
                  ],
                ),
              ),
              // The one action stays in reach however long the text is.
              Padding(
                padding: const EdgeInsets.fromLTRB(TurboSpacing.xl, TurboSpacing.sm, TurboSpacing.xl, TurboSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger)),
                        ),
                      ),
                    TurboButton(label: l10n.termsAgree, driver: true, loading: _busy, onPressed: () => _agree(versions)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
