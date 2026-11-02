import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';

bool isActiveStatus(RideStatus s) =>
    s == RideStatus.searching ||
    s == RideStatus.assigned ||
    s == RideStatus.driverArrived ||
    s == RideStatus.inProgress;

/// How often each live view asks again. Push will make this less needed.
const rideEvery = Duration(seconds: 4);
const messagesEvery = Duration(seconds: 6);

/// The student's active ride, or null. Re-reads itself while watched.
final activeRideProvider = FutureProvider.autoDispose<Ride?>((ref) async {
  final timer = Timer(const Duration(seconds: 10), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  final response = await ref.read(clientProvider).api.getRidesApi().listMyRides(limit: 5);
  for (final r in response.data!.data) {
    if (isActiveStatus(r.status)) return r;
  }
  return null;
});

/// The most recent finished ride among the latest few, or null. Shown on Home.
final lastRideProvider = FutureProvider.autoDispose<Ride?>((ref) async {
  try {
    final response = await ref.read(clientProvider).api.getRidesApi().listMyRides(limit: 5);
    for (final r in response.data!.data) {
      if (r.status == RideStatus.completed) return r;
    }
  } catch (_) {
    // A tile that cannot load simply does not show.
  }
  return null;
});

/// One ride, kept fresh every few seconds while it is active.
final rideProvider = FutureProvider.autoDispose.family<Ride, String>((ref, id) async {
  try {
    final ride = (await ref.read(clientProvider).api.getRidesApi().getRide(id: id)).data!;
    if (isActiveStatus(ride.status)) {
      final timer = Timer(rideEvery, ref.invalidateSelf);
      ref.onDispose(timer.cancel);
    }
    return ride;
  } catch (e) {
    // Keep trying: a dropped connection must never end the screen.
    final timer = Timer(rideEvery, ref.invalidateSelf);
    ref.onDispose(timer.cancel);
    throw problemOf(e);
  }
});

/// The driver's position and ETA, while there is a driver to follow.
final trackingProvider = FutureProvider.autoDispose.family<Tracking?, String>((ref, id) async {
  final ride = ref.watch(rideProvider(id)).value;
  if (ride == null || !(ride.status == RideStatus.assigned || ride.status == RideStatus.driverArrived || ride.status == RideStatus.inProgress)) {
    return null;
  }
  final timer = Timer(rideEvery, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  try {
    return (await ref.read(clientProvider).api.getRidesApi().getRideTracking(id: id)).data!;
  } catch (_) {
    return null;
  }
});

final rideMessagesProvider = FutureProvider.autoDispose.family<List<QuickMessage>, String>((ref, id) async {
  final ride = ref.watch(rideProvider(id)).value;
  if (ride == null || !isActiveStatus(ride.status)) return const [];
  final timer = Timer(messagesEvery, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  try {
    return (await ref.read(clientProvider).api.getRidesApi().listRideMessages(id: id)).data!.items.toList();
  } catch (_) {
    return const [];
  }
});

final receiptProvider = FutureProvider.autoDispose.family<Receipt, String>((ref, id) async {
  try {
    return (await ref.read(clientProvider).api.getRidesApi().getRideReceipt(id: id)).data!;
  } catch (e) {
    throw problemOf(e);
  }
});

/// Everything the student can do to a ride. One idempotency key per quote, so
/// pressing Book twice or retrying after a dropped connection books once.
class RideActions {
  RideActions(this.ref);

  final Ref ref;
  final _bookKeys = <String, IdempotencyKey>{};

  RidesApi get _api => ref.read(clientProvider).api.getRidesApi();

  /// Books a quoted ride. Throws [ApiProblem]. `active_ride_exists` means the
  /// caller should open the ride that is already running.
  Future<Ride> book(String quoteId) async {
    final key = _bookKeys.putIfAbsent(quoteId, IdempotencyKey.new);
    try {
      final response = await _api.createRide(idempotencyKey: key.value, rideCreate: RideCreate(quoteId: quoteId));
      ref.invalidate(activeRideProvider);
      return response.data!;
    } catch (e) {
      final problem = problemOf(e);
      // A definite answer ends this intention; a lost connection does not.
      if (problem.code != ApiProblem.network && (problem.status ?? 0) < 500) _bookKeys.remove(quoteId);
      throw problem;
    }
  }

  Future<Ride> cancel(String id, CancelRequestReasonCodeEnum reason) async {
    try {
      final r = (await _api.cancelRide(id: id, cancelRequest: CancelRequest(reasonCode: reason))).data!;
      ref.invalidate(rideProvider(id));
      ref.invalidate(activeRideProvider);
      return r;
    } catch (e) {
      throw problemOf(e);
    }
  }

  Future<void> sendMessage(String id, QuickMessageCode code) async {
    try {
      await _api.sendRideMessage(id: id, quickMessageSend: QuickMessageSend(code: code));
      ref.invalidate(rideMessagesProvider(id));
    } catch (e) {
      throw problemOf(e);
    }
  }

  Future<void> rate(String id, int stars, String comment) async {
    try {
      await _api.rateRide(
        id: id,
        ratingCreate: RatingCreate(stars: stars, comment: comment.trim().isEmpty ? null : comment.trim()),
      );
    } catch (e) {
      throw problemOf(e);
    }
  }
}

final rideActionsProvider = Provider<RideActions>(RideActions.new);

/// How long ago a ride was asked for, for the searching screen.
Duration sinceRequested(Ride ride) => clock.now().difference(ride.requestedAt);
