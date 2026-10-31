//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/problem_code.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ineligibility_reason.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IneligibilityReason {
  /// Returns a new [IneligibilityReason] instance.
  IneligibilityReason({

    required  this.code,

    required  this.message,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final ProblemCode code;



      /// Plain-language reason safe to show the student.
  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IneligibilityReason &&
      other.code == code &&
      other.message == message;

    @override
    int get hashCode =>
        code.hashCode +
        message.hashCode;

  factory IneligibilityReason.fromJson(Map<String, dynamic> json) => _$IneligibilityReasonFromJson(json);

  Map<String, dynamic> toJson() => _$IneligibilityReasonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

