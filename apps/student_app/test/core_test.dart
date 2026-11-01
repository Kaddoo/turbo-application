import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/core/auth_draft.dart';
import 'package:student_app/src/core/flow.dart';
import 'package:student_app/src/core/gate.dart';
import 'package:student_app/src/core/problem_messages.dart';
import 'package:student_app/src/core/semver.dart';
import 'package:student_app/src/l10n/app_localizations_en.dart';
import 'package:turbo_api/turbo_api.dart';

FlowInputs inputs({
  bool gateLoading = false,
  GateState? gate = const GateState(),
  bool sessionLoading = false,
  bool sessionError = false,
  bool signedIn = true,
  bool meLoading = false,
  bool meError = false,
  bool termsRequired = false,
  bool suspended = false,
  VerificationStatus? verification = VerificationStatus.approved,
  bool resubmitting = false,
}) =>
    FlowInputs(
      gateLoading: gateLoading,
      gate: gate,
      sessionLoading: sessionLoading,
      sessionError: sessionError,
      signedIn: signedIn,
      meLoading: meLoading,
      meError: meError,
      termsRequired: termsRequired,
      suspended: suspended,
      verification: verification,
      resubmitting: resubmitting,
    );

void main() {
  group('semver', () {
    test('compares numerically, not as text', () {
      expect(compareVersions('1.10.0', '1.9.0'), 1);
      expect(compareVersions('1.0', '1.0.0'), 0);
      expect(compareVersions('0.9.9', '1.0.0'), -1);
      expect(isOlderThan('1.2.3+4', '1.2.4'), isTrue);
      expect(isOlderThan('1.2.4', '1.2.4'), isFalse);
    });
  });

  group('flow', () {
    test('update and maintenance block everything', () {
      expect(computeStep(inputs(gate: const GateState(status: GateStatus.updateRequired))), FlowStep.updateRequired);
      expect(computeStep(inputs(gate: const GateState(status: GateStatus.maintenance))), FlowStep.maintenance);
    });

    test('an offline gate check does not block', () {
      expect(computeStep(inputs(gate: const GateState(offline: true), signedIn: false)), FlowStep.signedOut);
    });

    test('routes by verification status', () {
      expect(computeStep(inputs(verification: VerificationStatus.notSubmitted)), FlowStep.verificationCapture);
      for (final s in [VerificationStatus.pending, VerificationStatus.rejected, VerificationStatus.needsAttention]) {
        expect(computeStep(inputs(verification: s)), FlowStep.verificationStatus);
      }
      expect(computeStep(inputs(verification: VerificationStatus.approved)), FlowStep.home);
    });

    test('needs attention shows the reviewer message first, then the form on Resubmit', () {
      expect(computeStep(inputs(verification: VerificationStatus.needsAttention)), FlowStep.verificationStatus);
      expect(computeStep(inputs(verification: VerificationStatus.needsAttention, resubmitting: true)),
          FlowStep.verificationCapture);
    });

    test('terms and suspension come before verification', () {
      expect(computeStep(inputs(termsRequired: true, verification: null)), FlowStep.terms);
      expect(computeStep(inputs(suspended: true, verification: null)), FlowStep.suspended);
    });

    test('loading and errors', () {
      expect(computeStep(inputs(gateLoading: true)), FlowStep.loading);
      expect(computeStep(inputs(sessionLoading: true)), FlowStep.loading);
      expect(computeStep(inputs(sessionError: true)), FlowStep.bootError);
      expect(computeStep(inputs(meError: true)), FlowStep.bootError);
    });

    test('redirects leave people where they are inside a stack', () {
      expect(redirectFor(FlowStep.signedOut, '/code'), isNull);
      expect(redirectFor(FlowStep.signedOut, '/home'), '/welcome');
      expect(redirectFor(FlowStep.home, '/home/destination'), isNull);
      expect(redirectFor(FlowStep.home, '/phone'), '/home');
      expect(redirectFor(FlowStep.home, '/verification/status'), isNull, reason: 'approved check mark');
      expect(redirectFor(FlowStep.verificationCapture, '/verification/status'), '/verification');
      expect(redirectFor(FlowStep.verificationStatus, '/home'), '/verification/status');
    });
  });

  group('gate', () {
    AppConfig config({String ios = '1.0.0', bool maintenance = false}) => AppConfig.fromJson({
          'minVersion': {'ios': ios, 'android': '1.0.0', 'web': '1.0.0'},
          'maintenance': {'active': maintenance},
          'bookingsPaused': true,
          'pauseMessage': 'Back soon',
        });

    test('maintenance wins over version', () {
      expect(gateFrom(config(ios: '9.0.0', maintenance: true), 'ios', '1.0.0').status, GateStatus.maintenance);
    });

    test('older than the minimum needs an update', () {
      expect(gateFrom(config(ios: '1.2.0'), 'ios', '1.1.9').status, GateStatus.updateRequired);
      expect(gateFrom(config(ios: '1.2.0'), 'ios', '1.2.0').status, GateStatus.open);
    });

    test('bookings paused is carried through', () {
      final g = gateFrom(config(), 'ios', '1.0.0');
      expect(g.bookingsPaused, isTrue);
      expect(g.pauseMessage, 'Back soon');
    });
  });

  group('phone', () {
    test('normalises Ghana numbers', () {
      expect(normalisePhone('24 123 4567'), '+233241234567');
      expect(normalisePhone('024 123 4567'), '+233241234567');
      expect(normalisePhone('+233 24 123 4567'), '+233241234567');
      expect(normalisePhone('12345'), isNull);
      expect(normalisePhone(''), isNull);
    });

    test('displays as +233 24 123 4567', () {
      expect(displayPhone('+233241234567'), '+233 24 123 4567');
    });
  });

  group('problem messages', () {
    final l10n = AppLocalizationsEn();
    ApiProblem p(String code, {int? status, Duration? retry}) =>
        ApiProblem(code: code, title: 'raw server text', status: status, retryAfter: retry);

    test('switches on code and never shows server text', () {
      final m = problemMessage(l10n, p('otp_invalid'));
      expect(m, contains("isn't right"));
      expect(m, isNot(contains('raw server text')));
      expect(problemMessage(l10n, p('sms_budget_exceeded')), "We can't send codes right now. Try again soon.");
      expect(problemMessage(l10n, p('route_too_long')), contains('18 km'));
    });

    test('rate limits show the wait', () {
      expect(problemMessage(l10n, p('rate_limited', status: 429, retry: const Duration(seconds: 30))), contains('30 s'));
    });

    test('a busy server says so, with the wait when the server gives one', () {
      expect(problemMessage(l10n, p('service_busy', status: 503)), l10n.problemServiceBusy);
      expect(problemMessage(l10n, p('service_busy', status: 503, retry: const Duration(seconds: 2))), contains('2 seconds'));
      expect(problemMessage(l10n, p('service_busy', status: 503)), isNot(l10n.problemGeneric));
    });

    test('unknown codes and no connection read plainly', () {
      expect(problemMessage(l10n, p('something_new')), l10n.problemGeneric);
      expect(problemMessage(l10n, p(ApiProblem.network)), l10n.problemNetwork);
    });
  });
}
