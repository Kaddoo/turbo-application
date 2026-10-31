import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flow.dart';
import 'gate.dart';
import 'profile.dart';
import 'session.dart';

/// Combines gate, session and profile into one step for the router.
final flowProvider = Provider<FlowStep>((ref) {
  final gate = ref.watch(gateProvider);
  final session = ref.watch(sessionProvider);
  final profile = ref.watch(profileProvider);
  final signedIn = session.value?.status == SessionStatus.signedIn;
  final value = profile.value;
  return computeStep(
    FlowInputs(
      gateLoading: gate.isLoading && !gate.hasValue,
      gate: gate.value,
      sessionLoading: session.isLoading && !session.hasValue,
      sessionError: session.hasError && !session.hasValue,
      signedIn: signedIn,
      profileLoading: signedIn && profile.isLoading && !profile.hasValue,
      profileError: signedIn && profile.hasError && !profile.hasValue,
      termsRequired: value is ProfileTermsRequired,
      suspended: value is ProfileSuspended,
    ),
  );
});
