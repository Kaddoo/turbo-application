//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_decision.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDecision {
  /// Returns a new [VerificationDecision] instance.
  VerificationDecision({

    required  this.decision,

     this.reasonCode,

     this.studentMessage,

     this.internalNote,
  });

  @JsonKey(
    
    name: r'decision',
    required: true,
    includeIfNull: false,
  )


  final VerificationDecisionDecisionEnum decision;



      /// Required unless approved.
  @JsonKey(
    
    name: r'reasonCode',
    required: false,
    includeIfNull: false,
  )


  final String? reasonCode;



  @JsonKey(
    
    name: r'studentMessage',
    required: false,
    includeIfNull: false,
  )


  final String? studentMessage;



  @JsonKey(
    
    name: r'internalNote',
    required: false,
    includeIfNull: false,
  )


  final String? internalNote;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDecision &&
      other.decision == decision &&
      other.reasonCode == reasonCode &&
      other.studentMessage == studentMessage &&
      other.internalNote == internalNote;

    @override
    int get hashCode =>
        decision.hashCode +
        reasonCode.hashCode +
        studentMessage.hashCode +
        internalNote.hashCode;

  factory VerificationDecision.fromJson(Map<String, dynamic> json) => _$VerificationDecisionFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDecisionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VerificationDecisionDecisionEnum {
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected'),
@JsonValue(r'needs_attention')
needsAttention(r'needs_attention');

const VerificationDecisionDecisionEnum(this.value);

final String value;

@override
String toString() => value;
}


