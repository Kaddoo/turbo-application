//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Shift {
  /// Returns a new [Shift] instance.
  Shift({

    required  this.id,

    required  this.driverId,

    required  this.startsAt,

    required  this.endsAt,

    required  this.status,
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



  @JsonKey(
    
    name: r'startsAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime startsAt;



  @JsonKey(
    
    name: r'endsAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime endsAt;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final ShiftStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Shift &&
      other.id == id &&
      other.driverId == driverId &&
      other.startsAt == startsAt &&
      other.endsAt == endsAt &&
      other.status == status;

    @override
    int get hashCode =>
        id.hashCode +
        driverId.hashCode +
        startsAt.hashCode +
        endsAt.hashCode +
        status.hashCode;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ShiftStatusEnum {
@JsonValue(r'scheduled')
scheduled(r'scheduled'),
@JsonValue(r'in_progress')
inProgress(r'in_progress'),
@JsonValue(r'completed')
completed(r'completed'),
@JsonValue(r'missed')
missed(r'missed');

const ShiftStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


