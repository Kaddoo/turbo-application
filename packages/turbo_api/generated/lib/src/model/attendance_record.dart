//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_record.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AttendanceRecord {
  /// Returns a new [AttendanceRecord] instance.
  AttendanceRecord({

    required  this.id,

    required  this.driverId,

     this.shiftId,

    required  this.date,

     this.clockInAt,

     this.clockOutAt,

    required  this.minutesWorked,

    required  this.status,

     this.correctionNote,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'shiftId',
    required: false,
    includeIfNull: false,
  )


  final String? shiftId;



  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



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
    
    name: r'minutesWorked',
    required: true,
    includeIfNull: false,
  )


  final int minutesWorked;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AttendanceRecordStatusEnum status;



  @JsonKey(
    
    name: r'correctionNote',
    required: false,
    includeIfNull: false,
  )


  final String? correctionNote;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AttendanceRecord &&
      other.id == id &&
      other.driverId == driverId &&
      other.shiftId == shiftId &&
      other.date == date &&
      other.clockInAt == clockInAt &&
      other.clockOutAt == clockOutAt &&
      other.minutesWorked == minutesWorked &&
      other.status == status &&
      other.correctionNote == correctionNote;

    @override
    int get hashCode =>
        id.hashCode +
        driverId.hashCode +
        (shiftId == null ? 0 : shiftId.hashCode) +
        date.hashCode +
        (clockInAt == null ? 0 : clockInAt.hashCode) +
        (clockOutAt == null ? 0 : clockOutAt.hashCode) +
        minutesWorked.hashCode +
        status.hashCode +
        (correctionNote == null ? 0 : correctionNote.hashCode);

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRecordToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AttendanceRecordStatusEnum {
@JsonValue(r'present')
present(r'present'),
@JsonValue(r'late')
late_(r'late'),
@JsonValue(r'absent')
absent(r'absent'),
@JsonValue(r'corrected')
corrected(r'corrected');

const AttendanceRecordStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


