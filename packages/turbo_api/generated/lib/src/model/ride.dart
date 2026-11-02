//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/ride_status.dart';
import 'package:turbo_api_generated/src/model/ride_payment.dart';
import 'package:turbo_api_generated/src/model/vehicle_public.dart';
import 'package:turbo_api_generated/src/model/driver_public.dart';
import 'package:turbo_api_generated/src/model/cancellation.dart';
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Ride {
  /// Returns a new [Ride] instance.
  Ride({

    required  this.id,

    required  this.status,

    required  this.pickup,

    required  this.dropoff,

    required  this.routeDistanceMeters,

     this.routePolyline,

    required  this.farePesewas,

     this.pin,

     this.pickupEtaSeconds,

     this.driver,

     this.vehicle,

    required  this.payment,

     this.cancellation,

    required  this.requestedAt,

     this.assignedAt,

     this.driverArrivedAt,

     this.startedAt,

     this.completedAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final RideStatus status;



  @JsonKey(
    
    name: r'pickup',
    required: true,
    includeIfNull: false,
  )


  final Location pickup;



  @JsonKey(
    
    name: r'dropoff',
    required: true,
    includeIfNull: false,
  )


  final Location dropoff;



  @JsonKey(
    
    name: r'routeDistanceMeters',
    required: true,
    includeIfNull: false,
  )


  final int routeDistanceMeters;



      /// The road from pickup to drop-off as a Google encoded polyline (precision 5), computed by the server from the same Routes call that gives the distance. Null when no road route is known (the apps then draw the two points only). Never needs a Maps key in the app.
  @JsonKey(
    
    name: r'routePolyline',
    required: false,
    includeIfNull: false,
  )


  final String? routePolyline;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'farePesewas',
    required: true,
    includeIfNull: false,
  )


  final int farePesewas;



      /// 4-digit start PIN. Returned only to the student who owns the ride, while status is assigned or driver_arrived.
  @JsonKey(
    
    name: r'pin',
    required: false,
    includeIfNull: false,
  )


  final String? pin;



  @JsonKey(
    
    name: r'pickupEtaSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? pickupEtaSeconds;



  @JsonKey(
    
    name: r'driver',
    required: false,
    includeIfNull: false,
  )


  final DriverPublic? driver;



  @JsonKey(
    
    name: r'vehicle',
    required: false,
    includeIfNull: false,
  )


  final VehiclePublic? vehicle;



  @JsonKey(
    
    name: r'payment',
    required: true,
    includeIfNull: false,
  )


  final RidePayment payment;



  @JsonKey(
    
    name: r'cancellation',
    required: false,
    includeIfNull: false,
  )


  final Cancellation? cancellation;



  @JsonKey(
    
    name: r'requestedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime requestedAt;



  @JsonKey(
    
    name: r'assignedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? assignedAt;



  @JsonKey(
    
    name: r'driverArrivedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? driverArrivedAt;



  @JsonKey(
    
    name: r'startedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? startedAt;



  @JsonKey(
    
    name: r'completedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? completedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Ride &&
      other.id == id &&
      other.status == status &&
      other.pickup == pickup &&
      other.dropoff == dropoff &&
      other.routeDistanceMeters == routeDistanceMeters &&
      other.routePolyline == routePolyline &&
      other.farePesewas == farePesewas &&
      other.pin == pin &&
      other.pickupEtaSeconds == pickupEtaSeconds &&
      other.driver == driver &&
      other.vehicle == vehicle &&
      other.payment == payment &&
      other.cancellation == cancellation &&
      other.requestedAt == requestedAt &&
      other.assignedAt == assignedAt &&
      other.driverArrivedAt == driverArrivedAt &&
      other.startedAt == startedAt &&
      other.completedAt == completedAt;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        pickup.hashCode +
        dropoff.hashCode +
        routeDistanceMeters.hashCode +
        (routePolyline == null ? 0 : routePolyline.hashCode) +
        farePesewas.hashCode +
        (pin == null ? 0 : pin.hashCode) +
        (pickupEtaSeconds == null ? 0 : pickupEtaSeconds.hashCode) +
        (driver == null ? 0 : driver.hashCode) +
        (vehicle == null ? 0 : vehicle.hashCode) +
        payment.hashCode +
        (cancellation == null ? 0 : cancellation.hashCode) +
        requestedAt.hashCode +
        (assignedAt == null ? 0 : assignedAt.hashCode) +
        (driverArrivedAt == null ? 0 : driverArrivedAt.hashCode) +
        (startedAt == null ? 0 : startedAt.hashCode) +
        (completedAt == null ? 0 : completedAt.hashCode);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

