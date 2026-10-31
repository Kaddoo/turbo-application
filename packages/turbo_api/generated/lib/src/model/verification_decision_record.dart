//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_decision_record.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDecisionRecord {
  /// Returns a new [VerificationDecisionRecord] instance.
  VerificationDecisionRecord({

    required  this.decision,

     this.reasonCode,

    required  this.decidedByStaffId,

    required  this.decidedAt,
  });

  @JsonKey(
    
    name: r'decision',
    required: true,
    includeIfNull: false,
  )


  final VerificationDecisionRecordDecisionEnum decision;



  @JsonKey(
    
    name: r'reasonCode',
    required: false,
    includeIfNull: false,
  )


  final String? reasonCode;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'decidedByStaffId',
    required: true,
    includeIfNull: false,
  )


  final String decidedByStaffId;



  @JsonKey(
    
    name: r'decidedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime decidedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDecisionRecord &&
      other.decision == decision &&
      other.reasonCode == reasonCode &&
      other.decidedByStaffId == decidedByStaffId &&
      other.decidedAt == decidedAt;

    @override
    int get hashCode =>
        decision.hashCode +
        (reasonCode == null ? 0 : reasonCode.hashCode) +
        decidedByStaffId.hashCode +
        decidedAt.hashCode;

  factory VerificationDecisionRecord.fromJson(Map<String, dynamic> json) => _$VerificationDecisionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDecisionRecordToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VerificationDecisionRecordDecisionEnum {
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected'),
@JsonValue(r'needs_attention')
needsAttention(r'needs_attention');

const VerificationDecisionRecordDecisionEnum(this.value);

final String value;

@override
String toString() => value;
}


