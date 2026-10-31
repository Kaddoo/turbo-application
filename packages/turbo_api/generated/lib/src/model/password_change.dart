//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_change.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PasswordChange {
  /// Returns a new [PasswordChange] instance.
  PasswordChange({

    required  this.currentPassword,

    required  this.newPassword,

    required  this.totpCode,
  });

  @JsonKey(
    
    name: r'currentPassword',
    required: true,
    includeIfNull: false,
  )


  final String currentPassword;



  @JsonKey(
    
    name: r'newPassword',
    required: true,
    includeIfNull: false,
  )


  final String newPassword;



  @JsonKey(
    
    name: r'totpCode',
    required: true,
    includeIfNull: false,
  )


  final String totpCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PasswordChange &&
      other.currentPassword == currentPassword &&
      other.newPassword == newPassword &&
      other.totpCode == totpCode;

    @override
    int get hashCode =>
        currentPassword.hashCode +
        newPassword.hashCode +
        totpCode.hashCode;

  factory PasswordChange.fromJson(Map<String, dynamic> json) => _$PasswordChangeFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordChangeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

