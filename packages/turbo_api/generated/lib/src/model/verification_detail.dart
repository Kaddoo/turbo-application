//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/verification_decision_record.dart';
import 'package:turbo_api_generated/src/model/verification_document.dart';
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:turbo_api_generated/src/model/student_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDetail {
  /// Returns a new [VerificationDetail] instance.
  VerificationDetail({

    required  this.id,

    required  this.student,

    required  this.status,

    required  this.submittedFullName,

    required  this.studentIdNumber,

    required  this.submittedAt,

    required  this.documents,

    required  this.history,

    required  this.ghanaCardNumber,
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


  final StudentSummary student;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final VerificationStatus status;



  @JsonKey(
    
    name: r'submittedFullName',
    required: true,
    includeIfNull: false,
  )


  final String submittedFullName;



  @JsonKey(
    
    name: r'studentIdNumber',
    required: true,
    includeIfNull: false,
  )


  final String studentIdNumber;



  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<VerificationDocument> documents;



  @JsonKey(
    
    name: r'history',
    required: true,
    includeIfNull: false,
  )


  final List<VerificationDecisionRecord> history;



      /// As submitted. Shown to verifiers only, for comparison with the card images. Stored encrypted.
  @JsonKey(
    
    name: r'ghanaCardNumber',
    required: true,
    includeIfNull: false,
  )


  final String ghanaCardNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDetail &&
      other.id == id &&
      other.student == student &&
      other.status == status &&
      other.submittedFullName == submittedFullName &&
      other.studentIdNumber == studentIdNumber &&
      other.submittedAt == submittedAt &&
      other.documents == documents &&
      other.history == history &&
      other.ghanaCardNumber == ghanaCardNumber;

    @override
    int get hashCode =>
        id.hashCode +
        student.hashCode +
        status.hashCode +
        submittedFullName.hashCode +
        studentIdNumber.hashCode +
        submittedAt.hashCode +
        documents.hashCode +
        history.hashCode +
        ghanaCardNumber.hashCode;

  factory VerificationDetail.fromJson(Map<String, dynamic> json) => _$VerificationDetailFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

