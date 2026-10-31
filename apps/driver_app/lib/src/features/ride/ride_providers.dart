import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/profile.dart';
import '../../core/providers.dart';
import 'position.dart';

/// The offer window: the driver must accept within this long of being assigned.
/// Decision D8; the server reassigns when it runs out.
const ackWindow = Duration(seconds: 45);
const rideEvery = Duration(seconds: 4);

/// Metres from the pickup beyond which "I've arrived" asks for confirmation.
const arrivedRadiusMeters = 300.0;

bool isOnDuty(ProfileState? s) => s is ProfileLoaded && s.profile.dutyStatus == DriverProfileDutyStatusEnum.onDuty;

/// The ride the driver has now, or null. Asked again every few seconds while on
/// duty; a failed ask keeps the last answer.
final currentRideProvider = FutureProvider<DriverRide?>((ref) async {
  final profile = ref.watch(profileProvider).value;
  if (!isOnDuty(profile)) return null;
  final timer = Timer(rideEvery, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  try {
    return (await ref.read(clientProvider).api.getDriverApi().getCurrentDriverRide()).data;
  } catch (e) {
    final p = problemOf(e);
    if (p.status == 404 || p.status == 204) return null;
    throw p;
  }
});

/// How a ride ended, once it is no longer current.
enum RideOutcome { completed, cancelled, passed }

Future<({RideOutcome outcome, DriverRide? ride})> resolveOutcome(TurboClient client, String rideId) async {
  try {
    final list = (await client.api.getDriverApi().listDriverRides()).data!.data;
    final match = list.where((r) => r.id == rideId).firstOrNull;
    if (match?.status == RideStatus.completed) return (outcome: RideOutcome.completed, ride: match);
    if (match?.status == RideStatus.cancelled) return (outcome: RideOutcome.cancelled, ride: match);
  } catch (_) {
    // Fall through: not knowing is treated as passed on.
  }
  return (outcome: RideOutcome.passed, ride: null);
}

double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
  const earth = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1), dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) + math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * earth * math.asin(math.min(1, math.sqrt(a)));
}

/// Everything the driver can do to a ride. Each call throws [ApiProblem].
class DriverRideActions {
  DriverRideActions(this.ref);

  final Ref ref;

  DriverApi get _api => ref.read(clientProvider).api.getDriverApi();

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      ref.invalidate(currentRideProvider);
      return result;
    } catch (e) {
      throw problemOf(e);
    }
  }

  Future<void> acknowledge(String id) => _run(() => _api.acknowledgeRide(id: id));

  Future<void> decline(String id, DeclineRequestReasonCodeEnum reason) =>
      _run(() => _api.declineRide(id: id, declineRequest: DeclineRequest(reasonCode: reason)));

  Future<GeoPoint?> position() => ref.read(positionReaderProvider).current();

  Future<void> arrived(String id, GeoPoint at) => _run(() => _api.markArrived(id: id, tripLocation: TripLocation(location: at)));

  Future<void> start(String id, String pin) => _run(() => _api.startRide(id: id, startRequest: StartRequest(pin: pin)));

  Future<void> complete(String id, GeoPoint at) => _run(() => _api.completeRide(id: id, tripLocation: TripLocation(location: at)));

  Future<void> noShow(String id) => _run(() => _api.reportRiderNoShow(id: id));

  Future<void> message(String id, QuickMessageCode code) async {
    try {
      await ref.read(clientProvider).api.getRidesApi().sendRideMessage(id: id, quickMessageSend: QuickMessageSend(code: code));
    } catch (e) {
      throw problemOf(e);
    }
  }
}

final driverRideActionsProvider = Provider<DriverRideActions>(DriverRideActions.new);
