//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_ride_student.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverRideStudent {
  /// Returns a new [DriverRideStudent] instance.
  DriverRideStudent({

    required  this.firstName,
  });

  @JsonKey(
    
    name: r'firstName',
    required: true,
    includeIfNull: false,
  )


  final String firstName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverRideStudent &&
      other.firstName == firstName;

    @override
    int get hashCode =>
        firstName.hashCode;

  factory DriverRideStudent.fromJson(Map<String, dynamic> json) => _$DriverRideStudentFromJson(json);

  Map<String, dynamic> toJson() => _$DriverRideStudentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

