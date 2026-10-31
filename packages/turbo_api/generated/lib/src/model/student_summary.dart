//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StudentSummary {
  /// Returns a new [StudentSummary] instance.
  StudentSummary({

    required  this.id,

    required  this.phone,

     this.fullName,

    required  this.accountStatus,

    required  this.verificationStatus,

    required  this.createdAt,

     this.noShowCount,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'fullName',
    required: false,
    includeIfNull: false,
  )


  final String? fullName;



  @JsonKey(
    
    name: r'accountStatus',
    required: true,
    includeIfNull: false,
  )


  final AccountStatus accountStatus;



  @JsonKey(
    
    name: r'verificationStatus',
    required: true,
    includeIfNull: false,
  )


  final VerificationStatus verificationStatus;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



          // minimum: 0
  @JsonKey(
    
    name: r'noShowCount',
    required: false,
    includeIfNull: false,
  )


  final int? noShowCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StudentSummary &&
      other.id == id &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.accountStatus == accountStatus &&
      other.verificationStatus == verificationStatus &&
      other.createdAt == createdAt &&
      other.noShowCount == noShowCount;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (fullName == null ? 0 : fullName.hashCode) +
        accountStatus.hashCode +
        verificationStatus.hashCode +
        createdAt.hashCode +
        noShowCount.hashCode;

  factory StudentSummary.fromJson(Map<String, dynamic> json) => _$StudentSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$StudentSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

