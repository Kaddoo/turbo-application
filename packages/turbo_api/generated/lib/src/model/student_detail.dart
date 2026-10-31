//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/wallet.dart';
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StudentDetail {
  /// Returns a new [StudentDetail] instance.
  StudentDetail({

    required  this.id,

    required  this.phone,

     this.fullName,

     this.email,

     this.studentIdNumber,

    required  this.accountStatus,

    required  this.verificationStatus,

    required  this.wallet,

    required  this.completedRides,

    required  this.createdAt,
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
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'studentIdNumber',
    required: false,
    includeIfNull: false,
  )


  final String? studentIdNumber;



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
    
    name: r'wallet',
    required: true,
    includeIfNull: false,
  )


  final Wallet wallet;



  @JsonKey(
    
    name: r'completedRides',
    required: true,
    includeIfNull: false,
  )


  final int completedRides;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StudentDetail &&
      other.id == id &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.email == email &&
      other.studentIdNumber == studentIdNumber &&
      other.accountStatus == accountStatus &&
      other.verificationStatus == verificationStatus &&
      other.wallet == wallet &&
      other.completedRides == completedRides &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (fullName == null ? 0 : fullName.hashCode) +
        (email == null ? 0 : email.hashCode) +
        (studentIdNumber == null ? 0 : studentIdNumber.hashCode) +
        accountStatus.hashCode +
        verificationStatus.hashCode +
        wallet.hashCode +
        completedRides.hashCode +
        createdAt.hashCode;

  factory StudentDetail.fromJson(Map<String, dynamic> json) => _$StudentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

