//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'decline_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeclineRequest {
  /// Returns a new [DeclineRequest] instance.
  DeclineRequest({

    required  this.reasonCode,

     this.note,
  });

  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final DeclineRequestReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeclineRequest &&
      other.reasonCode == reasonCode &&
      other.note == note;

    @override
    int get hashCode =>
        reasonCode.hashCode +
        note.hashCode;

  factory DeclineRequest.fromJson(Map<String, dynamic> json) => _$DeclineRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeclineRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DeclineRequestReasonCodeEnum {
@JsonValue(r'vehicle_issue')
vehicleIssue(r'vehicle_issue'),
@JsonValue(r'unwell')
unwell(r'unwell'),
@JsonValue(r'too_far')
tooFar(r'too_far'),
@JsonValue(r'other')
other(r'other');

const DeclineRequestReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


