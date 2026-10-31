//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/verification_summary_student.dart';
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationSummary {
  /// Returns a new [VerificationSummary] instance.
  VerificationSummary({

    required  this.id,

    required  this.student,

    required  this.status,

    required  this.submittedAt,

     this.claimedBy,

     this.claimExpiresAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'student',
    required: true,
    includeIfNull: false,
  )


  final VerificationSummaryStudent student;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final VerificationStatus status;



  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'claimedBy',
    required: false,
    includeIfNull: false,
  )


  final String? claimedBy;



  @JsonKey(
    
    name: r'claimExpiresAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? claimExpiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationSummary &&
      other.id == id &&
      other.student == student &&
      other.status == status &&
      other.submittedAt == submittedAt &&
      other.claimedBy == claimedBy &&
      other.claimExpiresAt == claimExpiresAt;

    @override
    int get hashCode =>
        id.hashCode +
        student.hashCode +
        status.hashCode +
        submittedAt.hashCode +
        (claimedBy == null ? 0 : claimedBy.hashCode) +
        (claimExpiresAt == null ? 0 : claimExpiresAt.hashCode);

  factory VerificationSummary.fromJson(Map<String, dynamic> json) => _$VerificationSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

