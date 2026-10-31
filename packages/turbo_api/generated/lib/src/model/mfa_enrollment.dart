//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mfa_enrollment.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MfaEnrollment {
  /// Returns a new [MfaEnrollment] instance.
  MfaEnrollment({

    required  this.enrollmentToken,

    required  this.secret,

    required  this.otpauthUri,
  });

      /// Short-lived. Send back with the first TOTP code.
  @JsonKey(
    
    name: r'enrollmentToken',
    required: true,
    includeIfNull: false,
  )


  final String enrollmentToken;



  @JsonKey(
    
    name: r'secret',
    required: true,
    includeIfNull: false,
  )


  final String secret;



  @JsonKey(
    
    name: r'otpauthUri',
    required: true,
    includeIfNull: false,
  )


  final String otpauthUri;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MfaEnrollment &&
      other.enrollmentToken == enrollmentToken &&
      other.secret == secret &&
      other.otpauthUri == otpauthUri;

    @override
    int get hashCode =>
        enrollmentToken.hashCode +
        secret.hashCode +
        otpauthUri.hashCode;

  factory MfaEnrollment.fromJson(Map<String, dynamic> json) => _$MfaEnrollmentFromJson(json);

  Map<String, dynamic> toJson() => _$MfaEnrollmentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

