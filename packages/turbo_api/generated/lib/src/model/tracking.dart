//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/ride_status.dart';
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Tracking {
  /// Returns a new [Tracking] instance.
  Tracking({

    required  this.rideStatus,

    required  this.driverLocation,

     this.etaSeconds,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'rideStatus',
    required: true,
    includeIfNull: false,
  )


  final RideStatus rideStatus;



  @JsonKey(
    
    name: r'driverLocation',
    required: true,
    includeIfNull: true,
  )


  final DriverLocation? driverLocation;



  @JsonKey(
    
    name: r'etaSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? etaSeconds;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Tracking &&
      other.rideStatus == rideStatus &&
      other.driverLocation == driverLocation &&
      other.etaSeconds == etaSeconds &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        rideStatus.hashCode +
        (driverLocation == null ? 0 : driverLocation.hashCode) +
        (etaSeconds == null ? 0 : etaSeconds.hashCode) +
        updatedAt.hashCode;

  factory Tracking.fromJson(Map<String, dynamic> json) => _$TrackingFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

