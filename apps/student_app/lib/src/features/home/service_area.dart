import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';

/// Boundary, pickup points and trip limit. Safe to cache for five minutes per
/// the contract. When a refresh fails the last good copy stays and [stale]
/// says so.
class ServiceAreaState {
  const ServiceAreaState(this.area, {this.stale = false, this.fetchedAt});

  final ServiceArea area;
  final bool stale;
  final DateTime? fetchedAt;
}

class ServiceAreaController extends AsyncNotifier<ServiceAreaState> {
  static const maxAge = Duration(minutes: 5);

  @override
  Future<ServiceAreaState> build() => _fetch();

  Future<ServiceAreaState> _fetch() async {
    final response = await ref.read(clientProvider).api.getServiceAreaApi().getServiceArea();
    return ServiceAreaState(response.data!, fetchedAt: DateTime.now());
  }

  /// Re-reads when older than five minutes, or when forced. Keeps old data on failure.
  Future<void> refresh({bool force = false}) async {
    final current = state.value;
    final at = current?.fetchedAt;
    if (!force && at != null && DateTime.now().difference(at) < maxAge) return;
    try {
      state = AsyncData(await _fetch());
    } catch (e) {
      if (current == null) {
        state = AsyncError(e, StackTrace.current);
      } else {
        state = AsyncData(ServiceAreaState(current.area, stale: true, fetchedAt: current.fetchedAt));
      }
    }
  }
}

final serviceAreaProvider = AsyncNotifierProvider<ServiceAreaController, ServiceAreaState>(ServiceAreaController.new);

final walletProvider = FutureProvider<Wallet>((ref) async {
  final response = await ref.read(clientProvider).api.getWalletApi().getWallet();
  return response.data!;
});

final savedPlacesProvider = FutureProvider<List<SavedPlace>>((ref) async {
  final response = await ref.read(clientProvider).api.getStudentApi().listSavedPlaces();
  return response.data!.data.toList();
});
