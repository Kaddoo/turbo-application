import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

/// The pickup and drop-off being chosen, shared by the destination and quote
/// screens.
class TripDraft {
  const TripDraft({this.pickup, this.dropoff});

  final Location? pickup;
  final Location? dropoff;

  bool get complete => pickup != null && dropoff != null;

  TripDraft copyWith({Location? pickup, Location? dropoff}) =>
      TripDraft(pickup: pickup ?? this.pickup, dropoff: dropoff ?? this.dropoff);
}

class TripDraftController extends Notifier<TripDraft> {
  @override
  TripDraft build() => const TripDraft();

  void setPickup(Location l) => state = state.copyWith(pickup: l);
  void setDropoff(Location l) => state = state.copyWith(dropoff: l);
  void clear() => state = const TripDraft();
}

final tripDraftProvider = NotifierProvider<TripDraftController, TripDraft>(TripDraftController.new);
