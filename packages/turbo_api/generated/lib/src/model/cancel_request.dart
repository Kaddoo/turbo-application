//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancel_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancelRequest {
  /// Returns a new [CancelRequest] instance.
  CancelRequest({

     this.reasonCode,

     this.note,
  });

  @JsonKey(
    
    name: r'reasonCode',
    required: false,
    includeIfNull: false,
  )


  final CancelRequestReasonCodeEnum? reasonCode;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancelRequest &&
      other.reasonCode == reasonCode &&
      other.note == note;

    @override
    int get hashCode =>
        reasonCode.hashCode +
        note.hashCode;

  factory CancelRequest.fromJson(Map<String, dynamic> json) => _$CancelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CancelRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CancelRequestReasonCodeEnum {
@JsonValue(r'student_changed_mind')
studentChangedMind(r'student_changed_mind'),
@JsonValue(r'wait_too_long')
waitTooLong(r'wait_too_long'),
@JsonValue(r'wrong_location')
wrongLocation(r'wrong_location'),
@JsonValue(r'other')
other(r'other');

const CancelRequestReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


