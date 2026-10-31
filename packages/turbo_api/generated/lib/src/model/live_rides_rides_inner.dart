//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/admin_ride_summary.dart';
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_rides_rides_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LiveRidesRidesInner {
  /// Returns a new [LiveRidesRidesInner] instance.
  LiveRidesRidesInner({

    required  this.ride,

     this.driverLocation,
  });

  @JsonKey(
    
    name: r'ride',
    required: true,
    includeIfNull: false,
  )


  final AdminRideSummary ride;



  @JsonKey(
    
    name: r'driverLocation',
    required: false,
    includeIfNull: false,
  )


  final DriverLocation? driverLocation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LiveRidesRidesInner &&
      other.ride == ride &&
      other.driverLocation == driverLocation;

    @override
    int get hashCode =>
        ride.hashCode +
        (driverLocation == null ? 0 : driverLocation.hashCode);

  factory LiveRidesRidesInner.fromJson(Map<String, dynamic> json) => _$LiveRidesRidesInnerFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRidesRidesInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

