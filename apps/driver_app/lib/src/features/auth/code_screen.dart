import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/auth_draft.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../core/session.dart';
import '../../l10n/app_localizations.dart';

class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key});

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  final _otp = GlobalKey<OtpFieldState>();
  Timer? _timer;
  int _wait = 0;
  String _code = '';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _wait = ref.read(authDraftProvider).resendInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_wait > 0 && mounted) setState(() => _wait--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify([String? code]) async {
    final l10n = AppLocalizations.of(context);
    final phone = ref.read(authDraftProvider).phone;
    final value = code ?? _code;
    if (phone == null || value.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await ref.read(clientProvider).api.getAuthApi().verifyOtp(
            otpVerify: OtpVerify(
              phone: phone,
              code: value,
              role: OtpVerifyRoleEnum.driver,
              clientType: OtpVerifyClientTypeEnum.mobile,
            ),
          );
      await ref.read(sessionProvider.notifier).signedIn(response.data!);
      ref.read(authDraftProvider.notifier).reset();
    } catch (e) {
      final problem = problemOf(e);
      if (problem.code == ProblemCode.termsNotAccepted.value && mounted) {
        final draft = ref.read(authDraftProvider);
        ref.read(authDraftProvider.notifier).set(draft.copyWith(pendingCode: value));
        context.go('/terms');
      } else if (mounted) {
        // Clear first: clearing reports a change, which would wipe the error.
        _otp.currentState?.clear();
        setState(() => _error = problemMessage(l10n, problem));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final phone = ref.read(authDraftProvider).phone;
    if (phone == null) return;
    setState(() => _error = null);
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final response = await ref.read(clientProvider).api.getAuthApi().requestOtp(
            // A new key for every tap, so a retry of one tap cannot send a second code but a deliberate resend still works.
            idempotencyKey: IdempotencyKey().value,
            otpRequest: OtpRequest(phone: phone, role: OtpRequestRoleEnum.driver, deviceId: deviceId),
          );
      if (mounted) setState(() => _wait = response.data?.resendInSeconds ?? 30);
      _otp.currentState?.clear();
    } catch (e) {
      final problem = problemOf(e);
      if (mounted) {
        setState(() {
          _error = problemMessage(l10n, problem);
          if (problem.retryAfter != null) _wait = problem.retryAfter!.inSeconds;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = ref.watch(authDraftProvider).phone;
    return AuthLayout(
      title: l10n.codeTitle,
      accent: l10n.codeTitleAccent,
      lead: phone == null ? null : l10n.codeSentTo(displayPhone(phone)),
      icon: Icons.vpn_key_outlined,
      onBack: () => context.go('/phone'),
      action: TurboButton(
        label: l10n.codeVerify,
        driver: true,
        loading: _busy,
        onPressed: _code.length == 6 ? _verify : null,
      ),
      children: [
        OtpField(
          key: _otp,
          errorText: _error,
          enabled: !_busy,
          onChanged: (c) => setState(() {
            _code = c;
            _error = null;
          }),
          onCompleted: _verify,
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(TurboSizes.minTap, TurboSizes.minTap)),
              onPressed: _busy ? null : () => context.go('/phone'),
              child: Text(l10n.codeWrongNumber),
            ),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(TurboSizes.minTap, TurboSizes.minTap)),
              onPressed: _wait > 0 || _busy ? null : _resend,
              child: Text(_wait > 0 ? l10n.codeResendIn(_wait) : l10n.codeResend),
            ),
          ],
        ),
      ],
    );
  }
}
