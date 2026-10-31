//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:turbo_api_generated/src/model/verification_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Student {
  /// Returns a new [Student] instance.
  Student({

    required  this.id,

    required  this.phone,

     this.fullName,

     this.email,

    required  this.accountStatus,

    required  this.verificationStatus,

    required  this.createdAt,

     this.termsAcceptedVersion,
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



  @JsonKey(
    
    name: r'termsAcceptedVersion',
    required: false,
    includeIfNull: false,
  )


  final String? termsAcceptedVersion;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Student &&
      other.id == id &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.email == email &&
      other.accountStatus == accountStatus &&
      other.verificationStatus == verificationStatus &&
      other.createdAt == createdAt &&
      other.termsAcceptedVersion == termsAcceptedVersion;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (fullName == null ? 0 : fullName.hashCode) +
        (email == null ? 0 : email.hashCode) +
        accountStatus.hashCode +
        verificationStatus.hashCode +
        createdAt.hashCode +
        (termsAcceptedVersion == null ? 0 : termsAcceptedVersion.hashCode);

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

