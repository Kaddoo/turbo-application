import 'package:turbo_api/turbo_api.dart';

import 'gate.dart';

/// Where the person should be, given everything the app knows. Pure, so it can
/// be tested without widgets.
enum FlowStep {
  loading,
  bootError,
  updateRequired,
  maintenance,
  signedOut,
  terms,
  suspended,
  verificationCapture,
  verificationStatus,
  home,
}

class FlowInputs {
  const FlowInputs({
    required this.gateLoading,
    required this.gate,
    required this.sessionLoading,
    required this.sessionError,
    required this.signedIn,
    required this.meLoading,
    required this.meError,
    required this.termsRequired,
    required this.suspended,
    required this.verification,
    this.resubmitting = false,
  });

  final bool gateLoading;
  final GateState? gate;
  final bool sessionLoading;
  final bool sessionError;
  final bool signedIn;
  final bool meLoading;
  final bool meError;
  final bool termsRequired;
  final bool suspended;
  final VerificationStatus? verification;

  /// The student chose "send again" after a needs-attention decision.
  final bool resubmitting;
}

FlowStep computeStep(FlowInputs i) {
  if (i.gateLoading) return FlowStep.loading;
  final gate = i.gate;
  if (gate?.status == GateStatus.updateRequired) return FlowStep.updateRequired;
  if (gate?.status == GateStatus.maintenance) return FlowStep.maintenance;
  if (i.sessionLoading) return FlowStep.loading;
  if (i.sessionError) return FlowStep.bootError;
  if (!i.signedIn) return FlowStep.signedOut;
  if (i.meLoading) return FlowStep.loading;
  if (i.meError) return FlowStep.bootError;
  if (i.termsRequired) return FlowStep.terms;
  if (i.suspended) return FlowStep.suspended;
  return switch (i.verification) {
    VerificationStatus.approved => FlowStep.home,
    VerificationStatus.needsAttention =>
      i.resubmitting
          ? FlowStep.verificationCapture
          : FlowStep.verificationStatus,
    VerificationStatus.pending ||
    VerificationStatus.rejected => FlowStep.verificationStatus,
    _ => FlowStep.verificationCapture,
  };
}

/// Locations that count as "already in the right place" for a step, so moving
/// around inside a stack is never undone by the redirect.
bool locationFitsStep(FlowStep step, String location) {
  bool within(String root) => location == root || location.startsWith('$root/');
  return switch (step) {
    FlowStep.loading => location == '/loading',
    FlowStep.bootError => location == '/offline',
    FlowStep.updateRequired => location == '/update',
    FlowStep.maintenance => location == '/maintenance',
    FlowStep.signedOut => const [
      '/welcome',
      '/phone',
      '/code',
      '/terms',
    ].contains(location),
    FlowStep.terms => location == '/terms',
    FlowStep.suspended => location == '/suspended',
    FlowStep.verificationCapture =>
      within('/verification') && location != '/verification/status',
    FlowStep.verificationStatus => location == '/verification/status',
    FlowStep.home =>
      within('/home') ||
          within('/wallet') ||
          within('/activity') ||
          within('/profile') ||
          within('/ride') ||
          within('/safety') ||
          within('/support') ||
          location == '/verification/status',
  };
}

String defaultLocation(FlowStep step) => switch (step) {
  FlowStep.loading => '/loading',
  FlowStep.bootError => '/offline',
  FlowStep.updateRequired => '/update',
  FlowStep.maintenance => '/maintenance',
  FlowStep.signedOut => '/welcome',
  FlowStep.terms => '/terms',
  FlowStep.suspended => '/suspended',
  FlowStep.verificationCapture => '/verification',
  FlowStep.verificationStatus => '/verification/status',
  FlowStep.home => '/home',
};

/// Null means stay where you are.
String? redirectFor(FlowStep step, String location) =>
    locationFitsStep(step, location) ? null : defaultLocation(step);
