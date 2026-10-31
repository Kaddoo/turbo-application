import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while the phone has any connection. Starts true so the banner does not
/// flash before the first reading.
final onlineProvider = StreamProvider<bool>((ref) async* {
  final c = Connectivity();
  yield (await c.checkConnectivity()).any((r) => r != ConnectivityResult.none);
  yield* c.onConnectivityChanged.map((r) => r.any((x) => x != ConnectivityResult.none));
});
