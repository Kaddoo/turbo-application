//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_rides_on_duty_drivers_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LiveRidesOnDutyDriversInner {
  /// Returns a new [LiveRidesOnDutyDriversInner] instance.
  LiveRidesOnDutyDriversInner({

    required  this.driverId,

    required  this.fullName,

    required  this.idle,

     this.location,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'idle',
    required: true,
    includeIfNull: false,
  )


  final bool idle;



  @JsonKey(
    
    name: r'location',
    required: false,
    includeIfNull: false,
  )


  final DriverLocation? location;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LiveRidesOnDutyDriversInner &&
      other.driverId == driverId &&
      other.fullName == fullName &&
      other.idle == idle &&
      other.location == location;

    @override
    int get hashCode =>
        driverId.hashCode +
        fullName.hashCode +
        idle.hashCode +
        (location == null ? 0 : location.hashCode);

  factory LiveRidesOnDutyDriversInner.fromJson(Map<String, dynamic> json) => _$LiveRidesOnDutyDriversInnerFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRidesOnDutyDriversInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

