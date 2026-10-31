//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_forgot.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PasswordForgot {
  /// Returns a new [PasswordForgot] instance.
  PasswordForgot({

    required  this.email,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PasswordForgot &&
      other.email == email;

    @override
    int get hashCode =>
        email.hashCode;

  factory PasswordForgot.fromJson(Map<String, dynamic> json) => _$PasswordForgotFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordForgotToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

