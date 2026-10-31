//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpRequest {
  /// Returns a new [OtpRequest] instance.
  OtpRequest({

    required  this.phone,

    required  this.role,

     this.deviceId,

     this.captchaToken,
  });

      /// E.164 Ghana number, e.g. +233241234567
  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final OtpRequestRoleEnum role;



      /// Stable per install. Used for per-device limits.
  @JsonKey(
    
    name: r'deviceId',
    required: false,
    includeIfNull: false,
  )


  final String? deviceId;



      /// Required on the web app (and app attestation token on mobile when enabled).
  @JsonKey(
    
    name: r'captchaToken',
    required: false,
    includeIfNull: false,
  )


  final String? captchaToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpRequest &&
      other.phone == phone &&
      other.role == role &&
      other.deviceId == deviceId &&
      other.captchaToken == captchaToken;

    @override
    int get hashCode =>
        phone.hashCode +
        role.hashCode +
        deviceId.hashCode +
        captchaToken.hashCode;

  factory OtpRequest.fromJson(Map<String, dynamic> json) => _$OtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum OtpRequestRoleEnum {
@JsonValue(r'student')
student(r'student'),
@JsonValue(r'driver')
driver(r'driver');

const OtpRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


