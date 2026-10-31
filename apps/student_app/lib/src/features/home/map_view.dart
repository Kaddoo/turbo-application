import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:turbo_api/turbo_api.dart' show GeoPoint, PickupPoint;
import 'package:turbo_ui/turbo_ui.dart';

/// What the home map shows.
class MapSpec {
  const MapSpec({
    this.center,
    this.pickupPoints = const [],
    this.showMyLocation = false,
    this.driver,
    this.pickup,
    this.dropoff,
  });

  final GeoPoint? center;

  /// The driver's last known position, when there is a ride.
  final GeoPoint? driver;
  final GeoPoint? pickup;
  final GeoPoint? dropoff;
  final List<PickupPoint> pickupPoints;
  final bool showMyLocation;
}

typedef MapBuilder = Widget Function(BuildContext context, MapSpec spec);

Widget _googleMap(BuildContext context, MapSpec spec) {
  // Without a position (no permission, no pickup points) the map opens on a
  // wide view of Ghana; real data replaces it as soon as it arrives.
  LatLng ll(GeoPoint p) => LatLng(p.lat.toDouble(), p.lng.toDouble());
  final focus = spec.driver ?? spec.pickup ?? spec.center;
  final target = focus != null
      ? ll(focus)
      : spec.pickupPoints.isNotEmpty
          ? LatLng(spec.pickupPoints.first.point.lat.toDouble(), spec.pickupPoints.first.point.lng.toDouble())
          : const LatLng(5.7, 0.1);
  return GoogleMap(
    initialCameraPosition: CameraPosition(target: target, zoom: focus != null ? 15 : 12),
    myLocationEnabled: spec.showMyLocation,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    mapToolbarEnabled: false,
    markers: {
      if (spec.pickup != null) Marker(markerId: const MarkerId('pickup'), position: ll(spec.pickup!)),
      if (spec.dropoff != null)
        Marker(
          markerId: const MarkerId('dropoff'),
          position: ll(spec.dropoff!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      if (spec.driver != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: ll(spec.driver!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      for (final p in spec.pickupPoints.where((p) => p.isActive))
        Marker(
          markerId: MarkerId(p.id),
          position: LatLng(p.point.lat.toDouble(), p.point.lng.toDouble()),
          infoWindow: InfoWindow(title: p.name),
        ),
    },
  );
}

/// Replaced in tests, where a native map view cannot run.
final mapBuilderProvider = Provider<MapBuilder>((_) => _googleMap);

class HomeMap extends ConsumerWidget {
  const HomeMap({super.key, required this.spec, this.height = 320});

  final MapSpec spec;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TurboMapContainer(
      height: height,
      child: ref.watch(mapBuilderProvider)(context, spec),
    );
  }
}
