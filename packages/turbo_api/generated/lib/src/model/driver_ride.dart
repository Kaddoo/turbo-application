//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/ride_status.dart';
import 'package:turbo_api_generated/src/model/driver_ride_student.dart';
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_ride.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverRide {
  /// Returns a new [DriverRide] instance.
  DriverRide({

    required  this.id,

    required  this.status,

    required  this.pickup,

    required  this.dropoff,

    required  this.routeDistanceMeters,

     this.routePolyline,

     this.farePesewas,

     this.pickupDistanceMeters,

     this.pickupEtaSeconds,

     this.routeDurationSeconds,

    required  this.student,

    required  this.assignedAt,

     this.acknowledgedAt,

     this.noShowAvailableAt,

     this.arrivedAt,

     this.startedAt,

     this.completedAt,

     this.cancelledAt,

     this.cancelledBy,

     this.cancelReasonCode,
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



      /// What the student pays for this trip. Shown so the driver can see the price before acknowledging.
          // minimum: 0
  @JsonKey(
    
    name: r'farePesewas',
    required: false,
    includeIfNull: false,
  )


  final int? farePesewas;



      /// Estimated road distance from the driver's last known position to the pickup. Null once the trip has started or if the driver has no recent position.
  @JsonKey(
    
    name: r'pickupDistanceMeters',
    required: false,
    includeIfNull: false,
  )


  final int? pickupDistanceMeters;



      /// Estimated time to reach the pickup. 0 once arrived, null once the trip has started.
  @JsonKey(
    
    name: r'pickupEtaSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? pickupEtaSeconds;



      /// Estimated duration of the trip itself.
  @JsonKey(
    
    name: r'routeDurationSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? routeDurationSeconds;



  @JsonKey(
    
    name: r'student',
    required: true,
    includeIfNull: false,
  )


  final DriverRideStudent student;



  @JsonKey(
    
    name: r'assignedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime assignedAt;



  @JsonKey(
    
    name: r'acknowledgedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? acknowledgedAt;



      /// Time after which \"student not here\" can be used. Null until the driver has arrived.
  @JsonKey(
    
    name: r'noShowAvailableAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? noShowAvailableAt;



  @JsonKey(
    
    name: r'arrivedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? arrivedAt;



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



  @JsonKey(
    
    name: r'cancelledAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? cancelledAt;



      /// Who cancelled (as `Cancellation.by`). Null unless the ride is cancelled.
  @JsonKey(
    
    name: r'cancelledBy',
    required: false,
    includeIfNull: false,
  )


  final DriverRideCancelledByEnum? cancelledBy;



      /// Why (as `Cancellation.reasonCode`). Null unless the ride is cancelled. The free-text note is not sent to drivers.
  @JsonKey(
    
    name: r'cancelReasonCode',
    required: false,
    includeIfNull: false,
  )


  final DriverRideCancelReasonCodeEnum? cancelReasonCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverRide &&
      other.id == id &&
      other.status == status &&
      other.pickup == pickup &&
      other.dropoff == dropoff &&
      other.routeDistanceMeters == routeDistanceMeters &&
      other.routePolyline == routePolyline &&
      other.farePesewas == farePesewas &&
      other.pickupDistanceMeters == pickupDistanceMeters &&
      other.pickupEtaSeconds == pickupEtaSeconds &&
      other.routeDurationSeconds == routeDurationSeconds &&
      other.student == student &&
      other.assignedAt == assignedAt &&
      other.acknowledgedAt == acknowledgedAt &&
      other.noShowAvailableAt == noShowAvailableAt &&
      other.arrivedAt == arrivedAt &&
      other.startedAt == startedAt &&
      other.completedAt == completedAt &&
      other.cancelledAt == cancelledAt &&
      other.cancelledBy == cancelledBy &&
      other.cancelReasonCode == cancelReasonCode;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        pickup.hashCode +
        dropoff.hashCode +
        routeDistanceMeters.hashCode +
        (routePolyline == null ? 0 : routePolyline.hashCode) +
        farePesewas.hashCode +
        (pickupDistanceMeters == null ? 0 : pickupDistanceMeters.hashCode) +
        (pickupEtaSeconds == null ? 0 : pickupEtaSeconds.hashCode) +
        routeDurationSeconds.hashCode +
        student.hashCode +
        assignedAt.hashCode +
        (acknowledgedAt == null ? 0 : acknowledgedAt.hashCode) +
        (noShowAvailableAt == null ? 0 : noShowAvailableAt.hashCode) +
        (arrivedAt == null ? 0 : arrivedAt.hashCode) +
        (startedAt == null ? 0 : startedAt.hashCode) +
        (completedAt == null ? 0 : completedAt.hashCode) +
        (cancelledAt == null ? 0 : cancelledAt.hashCode) +
        (cancelledBy == null ? 0 : cancelledBy.hashCode) +
        (cancelReasonCode == null ? 0 : cancelReasonCode.hashCode);

  factory DriverRide.fromJson(Map<String, dynamic> json) => _$DriverRideFromJson(json);

  Map<String, dynamic> toJson() => _$DriverRideToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Who cancelled (as `Cancellation.by`). Null unless the ride is cancelled.
enum DriverRideCancelledByEnum {
@JsonValue(r'student')
student(r'student'),
@JsonValue(r'driver')
driver(r'driver'),
@JsonValue(r'system')
system(r'system'),
@JsonValue(r'admin')
admin(r'admin');

const DriverRideCancelledByEnum(this.value);

final String value;

@override
String toString() => value;
}


/// Why (as `Cancellation.reasonCode`). Null unless the ride is cancelled. The free-text note is not sent to drivers.
enum DriverRideCancelReasonCodeEnum {
@JsonValue(r'student_changed_mind')
studentChangedMind(r'student_changed_mind'),
@JsonValue(r'driver_unavailable')
driverUnavailable(r'driver_unavailable'),
@JsonValue(r'vehicle_issue')
vehicleIssue(r'vehicle_issue'),
@JsonValue(r'no_driver_available')
noDriverAvailable(r'no_driver_available'),
@JsonValue(r'service_issue')
serviceIssue(r'service_issue'),
@JsonValue(r'admin_decision')
adminDecision(r'admin_decision'),
@JsonValue(r'other')
other(r'other'),
@JsonValue(r'rider_no_show')
riderNoShow(r'rider_no_show');

const DriverRideCancelReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


