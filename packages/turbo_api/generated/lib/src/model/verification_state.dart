//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_state.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationState {
  /// Returns a new [VerificationState] instance.
  VerificationState({

    required  this.status,

     this.reasonCode,

     this.message,

     this.submittedAt,

     this.decidedAt,

    required  this.canResubmit,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final VerificationStatus status;



      /// Why it was sent back or rejected, e.g. document_unclear, name_mismatch, expired_id.
  @JsonKey(
    
    name: r'reasonCode',
    required: false,
    includeIfNull: false,
  )


  final String? reasonCode;



      /// Plain-language explanation to show the student.
  @JsonKey(
    
    name: r'message',
    required: false,
    includeIfNull: false,
  )


  final String? message;



  @JsonKey(
    
    name: r'submittedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? submittedAt;



  @JsonKey(
    
    name: r'decidedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? decidedAt;



  @JsonKey(
    
    name: r'canResubmit',
    required: true,
    includeIfNull: false,
  )


  final bool canResubmit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationState &&
      other.status == status &&
      other.reasonCode == reasonCode &&
      other.message == message &&
      other.submittedAt == submittedAt &&
      other.decidedAt == decidedAt &&
      other.canResubmit == canResubmit;

    @override
    int get hashCode =>
        status.hashCode +
        (reasonCode == null ? 0 : reasonCode.hashCode) +
        (message == null ? 0 : message.hashCode) +
        (submittedAt == null ? 0 : submittedAt.hashCode) +
        (decidedAt == null ? 0 : decidedAt.hashCode) +
        canResubmit.hashCode;

  factory VerificationState.fromJson(Map<String, dynamic> json) => _$VerificationStateFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationStateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

