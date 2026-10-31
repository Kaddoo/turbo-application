//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/live_rides_rides_inner.dart';
import 'package:turbo_api_generated/src/model/live_rides_on_duty_drivers_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_rides.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LiveRides {
  /// Returns a new [LiveRides] instance.
  LiveRides({

    required  this.rides,

    required  this.onDutyDrivers,
  });

  @JsonKey(
    
    name: r'rides',
    required: true,
    includeIfNull: false,
  )


  final List<LiveRidesRidesInner> rides;



  @JsonKey(
    
    name: r'onDutyDrivers',
    required: true,
    includeIfNull: false,
  )


  final List<LiveRidesOnDutyDriversInner> onDutyDrivers;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LiveRides &&
      other.rides == rides &&
      other.onDutyDrivers == onDutyDrivers;

    @override
    int get hashCode =>
        rides.hashCode +
        onDutyDrivers.hashCode;

  factory LiveRides.fromJson(Map<String, dynamic> json) => _$LiveRidesFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRidesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

