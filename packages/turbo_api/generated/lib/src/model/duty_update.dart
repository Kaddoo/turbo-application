//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'duty_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DutyUpdate {
  /// Returns a new [DutyUpdate] instance.
  DutyUpdate({

    required  this.onDuty,
  });

  @JsonKey(
    
    name: r'onDuty',
    required: true,
    includeIfNull: false,
  )


  final bool onDuty;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DutyUpdate &&
      other.onDuty == onDuty;

    @override
    int get hashCode =>
        onDuty.hashCode;

  factory DutyUpdate.fromJson(Map<String, dynamic> json) => _$DutyUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$DutyUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

