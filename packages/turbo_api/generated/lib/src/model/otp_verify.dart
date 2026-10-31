//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_verify.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpVerify {
  /// Returns a new [OtpVerify] instance.
  OtpVerify({

    required  this.phone,

    required  this.code,

    required  this.role,

    required  this.clientType,

     this.acceptedTermsVersion,

     this.acceptedPrivacyVersion,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final OtpVerifyRoleEnum role;



      /// mobile: refresh token returned in the body. web: refresh token set as an httpOnly cookie and omitted from the body.
  @JsonKey(
    
    name: r'clientType',
    required: true,
    includeIfNull: false,
  )


  final OtpVerifyClientTypeEnum clientType;



      /// Required on first login (terms_not_accepted if missing). Stored with time and client.
  @JsonKey(
    
    name: r'acceptedTermsVersion',
    required: false,
    includeIfNull: false,
  )


  final String? acceptedTermsVersion;



  @JsonKey(
    
    name: r'acceptedPrivacyVersion',
    required: false,
    includeIfNull: false,
  )


  final String? acceptedPrivacyVersion;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpVerify &&
      other.phone == phone &&
      other.code == code &&
      other.role == role &&
      other.clientType == clientType &&
      other.acceptedTermsVersion == acceptedTermsVersion &&
      other.acceptedPrivacyVersion == acceptedPrivacyVersion;

    @override
    int get hashCode =>
        phone.hashCode +
        code.hashCode +
        role.hashCode +
        clientType.hashCode +
        acceptedTermsVersion.hashCode +
        acceptedPrivacyVersion.hashCode;

  factory OtpVerify.fromJson(Map<String, dynamic> json) => _$OtpVerifyFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum OtpVerifyRoleEnum {
@JsonValue(r'student')
student(r'student'),
@JsonValue(r'driver')
driver(r'driver');

const OtpVerifyRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


/// mobile: refresh token returned in the body. web: refresh token set as an httpOnly cookie and omitted from the body.
enum OtpVerifyClientTypeEnum {
@JsonValue(r'mobile')
mobile(r'mobile'),
@JsonValue(r'web')
web(r'web');

const OtpVerifyClientTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


