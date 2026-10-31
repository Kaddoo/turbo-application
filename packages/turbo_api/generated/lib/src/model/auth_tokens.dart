//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/session_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_tokens.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthTokens {
  /// Returns a new [AuthTokens] instance.
  AuthTokens({

    required  this.accessToken,

    required  this.expiresInSeconds,

     this.refreshToken,

    required  this.user,
  });

      /// JWT, 15 minutes.
  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'expiresInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int expiresInSeconds;



      /// Present for clientType=mobile only. Rotated on every refresh.
  @JsonKey(
    
    name: r'refreshToken',
    required: false,
    includeIfNull: false,
  )


  final String? refreshToken;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final SessionUser user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthTokens &&
      other.accessToken == accessToken &&
      other.expiresInSeconds == expiresInSeconds &&
      other.refreshToken == refreshToken &&
      other.user == user;

    @override
    int get hashCode =>
        accessToken.hashCode +
        expiresInSeconds.hashCode +
        refreshToken.hashCode +
        user.hashCode;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

