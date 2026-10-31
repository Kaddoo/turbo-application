//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_challenge.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpChallenge {
  /// Returns a new [OtpChallenge] instance.
  OtpChallenge({

    required  this.expiresInSeconds,

    required  this.resendInSeconds,
  });

  @JsonKey(
    
    name: r'expiresInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int expiresInSeconds;



  @JsonKey(
    
    name: r'resendInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int resendInSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpChallenge &&
      other.expiresInSeconds == expiresInSeconds &&
      other.resendInSeconds == resendInSeconds;

    @override
    int get hashCode =>
        expiresInSeconds.hashCode +
        resendInSeconds.hashCode;

  factory OtpChallenge.fromJson(Map<String, dynamic> json) => _$OtpChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$OtpChallengeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

