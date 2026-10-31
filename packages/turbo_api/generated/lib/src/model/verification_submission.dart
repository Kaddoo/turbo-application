//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_submission.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationSubmission {
  /// Returns a new [VerificationSubmission] instance.
  VerificationSubmission({

    required  this.fullName,

    required  this.studentIdNumber,

    required  this.ghanaCardFrontUploadId,

    required  this.ghanaCardBackUploadId,

    required  this.studentIdUploadId,

    required  this.ghanaCardNumber,

    required  this.selfieUploadId,
  });

      /// As printed on the Ghana Card.
  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'studentIdNumber',
    required: true,
    includeIfNull: false,
  )


  final String studentIdNumber;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'ghanaCardFrontUploadId',
    required: true,
    includeIfNull: false,
  )


  final String ghanaCardFrontUploadId;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'ghanaCardBackUploadId',
    required: true,
    includeIfNull: false,
  )


  final String ghanaCardBackUploadId;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'studentIdUploadId',
    required: true,
    includeIfNull: false,
  )


  final String studentIdUploadId;



      /// Stored encrypted. One card, one account: a duplicate returns 409 duplicate_identity.
  @JsonKey(
    
    name: r'ghanaCardNumber',
    required: true,
    includeIfNull: false,
  )


  final String ghanaCardNumber;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'selfieUploadId',
    required: true,
    includeIfNull: false,
  )


  final String selfieUploadId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationSubmission &&
      other.fullName == fullName &&
      other.studentIdNumber == studentIdNumber &&
      other.ghanaCardFrontUploadId == ghanaCardFrontUploadId &&
      other.ghanaCardBackUploadId == ghanaCardBackUploadId &&
      other.studentIdUploadId == studentIdUploadId &&
      other.ghanaCardNumber == ghanaCardNumber &&
      other.selfieUploadId == selfieUploadId;

    @override
    int get hashCode =>
        fullName.hashCode +
        studentIdNumber.hashCode +
        ghanaCardFrontUploadId.hashCode +
        ghanaCardBackUploadId.hashCode +
        studentIdUploadId.hashCode +
        ghanaCardNumber.hashCode +
        selfieUploadId.hashCode;

  factory VerificationSubmission.fromJson(Map<String, dynamic> json) => _$VerificationSubmissionFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationSubmissionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

