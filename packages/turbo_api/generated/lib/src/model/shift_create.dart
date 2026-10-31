//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShiftCreate {
  /// Returns a new [ShiftCreate] instance.
  ShiftCreate({

    required  this.driverId,

    required  this.startsAt,

    required  this.endsAt,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ShiftCreate &&
      other.driverId == driverId &&
      other.startsAt == startsAt &&
      other.endsAt == endsAt;

    @override
    int get hashCode =>
        driverId.hashCode +
        startsAt.hashCode +
        endsAt.hashCode;

  factory ShiftCreate.fromJson(Map<String, dynamic> json) => _$ShiftCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

