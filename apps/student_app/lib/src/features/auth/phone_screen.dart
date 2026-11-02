import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/auth_draft.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _controller = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final phone = normalisePhone(_controller.text);
    if (phone == null) {
      setState(() => _error = l10n.phoneInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final response = await ref.read(clientProvider).api.getAuthApi().requestOtp(
            // A new key for every tap, so a retry of one tap cannot send a second code but a deliberate resend still works.
            idempotencyKey: IdempotencyKey().value,
            otpRequest: OtpRequest(phone: phone, role: OtpRequestRoleEnum.student, deviceId: deviceId),
          );
      ref.read(authDraftProvider.notifier).set(
            AuthDraft(phone: phone, resendInSeconds: response.data?.resendInSeconds ?? 30),
          );
      if (mounted) context.go('/code');
    } catch (e) {
      if (mounted) setState(() => _error = problemMessage(l10n, problemOf(e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthLayout(
      title: l10n.phoneTitle,
      accent: l10n.phoneTitleAccent,
      lead: l10n.phoneLead,
      art: TurboArt.mobilePhone,
      onBack: () => context.go('/welcome'),
      action: TurboButton(label: l10n.phoneSendCode, loading: _busy, onPressed: _send),
      footer: Builder(
        builder: (context) => Text(
          l10n.phoneLegal,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
      children: [
        TurboTextField(
          label: l10n.phoneFieldLabel,
          controller: _controller,
          prefixText: '+233 ',
          helper: l10n.phoneHelper,
          errorText: _error,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')), LengthLimitingTextInputFormatter(13)],
          onChanged: (_) => setState(() => _error = null),
        ),
      ],
    );
  }
}
