//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_correction.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AttendanceCorrection {
  /// Returns a new [AttendanceCorrection] instance.
  AttendanceCorrection({

     this.clockInAt,

     this.clockOutAt,

    required  this.reasonCode,

    required  this.note,
  });

  @JsonKey(
    
    name: r'clockInAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? clockInAt;



  @JsonKey(
    
    name: r'clockOutAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? clockOutAt;



  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final AttendanceCorrectionReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AttendanceCorrection &&
      other.clockInAt == clockInAt &&
      other.clockOutAt == clockOutAt &&
      other.reasonCode == reasonCode &&
      other.note == note;

    @override
    int get hashCode =>
        clockInAt.hashCode +
        clockOutAt.hashCode +
        reasonCode.hashCode +
        note.hashCode;

  factory AttendanceCorrection.fromJson(Map<String, dynamic> json) => _$AttendanceCorrectionFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceCorrectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AttendanceCorrectionReasonCodeEnum {
@JsonValue(r'forgot_to_clock')
forgotToClock(r'forgot_to_clock'),
@JsonValue(r'app_issue')
appIssue(r'app_issue'),
@JsonValue(r'approved_leave')
approvedLeave(r'approved_leave'),
@JsonValue(r'other')
other(r'other');

const AttendanceCorrectionReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


