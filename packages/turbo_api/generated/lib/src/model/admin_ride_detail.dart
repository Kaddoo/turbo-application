//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_detail.dart';
import 'package:turbo_api_generated/src/model/ride_flag.dart';
import 'package:turbo_api_generated/src/model/ride.dart';
import 'package:turbo_api_generated/src/model/ride_event.dart';
import 'package:turbo_api_generated/src/model/student_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_ride_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminRideDetail {
  /// Returns a new [AdminRideDetail] instance.
  AdminRideDetail({

    required  this.ride,

    required  this.student,

     this.driver,

    required  this.events,

     this.flags,
  });

  @JsonKey(
    
    name: r'ride',
    required: true,
    includeIfNull: false,
  )


  final Ride ride;



  @JsonKey(
    
    name: r'student',
    required: true,
    includeIfNull: false,
  )


  final StudentSummary student;



  @JsonKey(
    
    name: r'driver',
    required: false,
    includeIfNull: false,
  )


  final DriverDetail? driver;



  @JsonKey(
    
    name: r'events',
    required: true,
    includeIfNull: false,
  )


  final List<RideEvent> events;



  @JsonKey(
    
    name: r'flags',
    required: false,
    includeIfNull: false,
  )


  final List<RideFlag>? flags;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminRideDetail &&
      other.ride == ride &&
      other.student == student &&
      other.driver == driver &&
      other.events == events &&
      other.flags == flags;

    @override
    int get hashCode =>
        ride.hashCode +
        student.hashCode +
        (driver == null ? 0 : driver.hashCode) +
        events.hashCode +
        flags.hashCode;

  factory AdminRideDetail.fromJson(Map<String, dynamic> json) => _$AdminRideDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AdminRideDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

