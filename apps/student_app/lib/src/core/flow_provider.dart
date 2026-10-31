import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flow.dart';
import 'gate.dart';
import 'me.dart';
import 'session.dart';
import '../features/verification/resubmit.dart';

/// Combines gate, session and profile into one step for the router.
final flowProvider = Provider<FlowStep>((ref) {
  final gate = ref.watch(gateProvider);
  final session = ref.watch(sessionProvider);
  final me = ref.watch(meProvider);
  final signedIn = session.value?.status == SessionStatus.signedIn;
  final meValue = me.value;
  return computeStep(
    FlowInputs(
      gateLoading: gate.isLoading && !gate.hasValue,
      gate: gate.value,
      sessionLoading: session.isLoading && !session.hasValue,
      sessionError: session.hasError && !session.hasValue,
      signedIn: signedIn,
      meLoading: signedIn && me.isLoading && !me.hasValue,
      meError: signedIn && me.hasError && !me.hasValue,
      termsRequired: meValue is MeTermsRequired,
      suspended: meValue is MeSuspended,
      verification: meValue is MeLoaded ? meValue.student.verificationStatus : null,
      resubmitting: ref.watch(resubmitProvider),
    ),
  );
});
