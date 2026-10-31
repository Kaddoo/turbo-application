//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_login.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminLogin {
  /// Returns a new [AdminLogin] instance.
  AdminLogin({

    required  this.email,

    required  this.password,

     this.totpCode,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;



      /// Required once the staff user has enrolled in MFA.
  @JsonKey(
    
    name: r'totpCode',
    required: false,
    includeIfNull: false,
  )


  final String? totpCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminLogin &&
      other.email == email &&
      other.password == password &&
      other.totpCode == totpCode;

    @override
    int get hashCode =>
        email.hashCode +
        password.hashCode +
        totpCode.hashCode;

  factory AdminLogin.fromJson(Map<String, dynamic> json) => _$AdminLoginFromJson(json);

  Map<String, dynamic> toJson() => _$AdminLoginToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

