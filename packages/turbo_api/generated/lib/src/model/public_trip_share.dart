//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/ride_status.dart';
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:turbo_api_generated/src/model/vehicle_public.dart';
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_trip_share.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PublicTripShare {
  /// Returns a new [PublicTripShare] instance.
  PublicTripShare({

    required  this.rideStatus,

    required  this.studentFirstName,

     this.driverFirstName,

     this.vehicle,

     this.driverLocation,

    required  this.dropoff,

    required  this.expiresAt,
  });

  @JsonKey(
    
    name: r'rideStatus',
    required: true,
    includeIfNull: false,
  )


  final RideStatus rideStatus;



  @JsonKey(
    
    name: r'studentFirstName',
    required: true,
    includeIfNull: false,
  )


  final String studentFirstName;



  @JsonKey(
    
    name: r'driverFirstName',
    required: false,
    includeIfNull: false,
  )


  final String? driverFirstName;



  @JsonKey(
    
    name: r'vehicle',
    required: false,
    includeIfNull: false,
  )


  final VehiclePublic? vehicle;



  @JsonKey(
    
    name: r'driverLocation',
    required: false,
    includeIfNull: false,
  )


  final DriverLocation? driverLocation;



  @JsonKey(
    
    name: r'dropoff',
    required: true,
    includeIfNull: false,
  )


  final Location dropoff;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PublicTripShare &&
      other.rideStatus == rideStatus &&
      other.studentFirstName == studentFirstName &&
      other.driverFirstName == driverFirstName &&
      other.vehicle == vehicle &&
      other.driverLocation == driverLocation &&
      other.dropoff == dropoff &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        rideStatus.hashCode +
        studentFirstName.hashCode +
        (driverFirstName == null ? 0 : driverFirstName.hashCode) +
        (vehicle == null ? 0 : vehicle.hashCode) +
        (driverLocation == null ? 0 : driverLocation.hashCode) +
        dropoff.hashCode +
        expiresAt.hashCode;

  factory PublicTripShare.fromJson(Map<String, dynamic> json) => _$PublicTripShareFromJson(json);

  Map<String, dynamic> toJson() => _$PublicTripShareToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

