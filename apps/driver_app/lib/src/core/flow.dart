import 'gate.dart';

/// Where the driver should be, given everything the app knows. Pure, so it can
/// be tested without widgets.
enum FlowStep { loading, bootError, updateRequired, maintenance, signedOut, terms, suspended, home }

class FlowInputs {
  const FlowInputs({
    required this.gateLoading,
    required this.gate,
    required this.sessionLoading,
    required this.sessionError,
    required this.signedIn,
    required this.profileLoading,
    required this.profileError,
    required this.termsRequired,
    required this.suspended,
  });

  final bool gateLoading;
  final GateState? gate;
  final bool sessionLoading;
  final bool sessionError;
  final bool signedIn;
  final bool profileLoading;
  final bool profileError;
  final bool termsRequired;
  final bool suspended;
}

FlowStep computeStep(FlowInputs i) {
  if (i.gateLoading) return FlowStep.loading;
  final gate = i.gate;
  if (gate?.status == GateStatus.updateRequired) return FlowStep.updateRequired;
  if (gate?.status == GateStatus.maintenance) return FlowStep.maintenance;
  if (i.sessionLoading) return FlowStep.loading;
  if (i.sessionError) return FlowStep.bootError;
  if (!i.signedIn) return FlowStep.signedOut;
  if (i.profileLoading) return FlowStep.loading;
  if (i.profileError) return FlowStep.bootError;
  if (i.termsRequired) return FlowStep.terms;
  if (i.suspended) return FlowStep.suspended;
  return FlowStep.home;
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
    FlowStep.signedOut => const ['/welcome', '/phone', '/code', '/terms'].contains(location),
    FlowStep.terms => location == '/terms',
    FlowStep.suspended => location == '/suspended',
    FlowStep.home => within('/home') ||
        within('/trips') ||
        within('/me') ||
        within('/ride') ||
        within('/support') ||
        within('/sos') ||
        within('/spike'),
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
      FlowStep.home => '/home',
    };

/// Null means stay where you are.
String? redirectFor(FlowStep step, String location) =>
    locationFitsStep(step, location) ? null : defaultLocation(step);
