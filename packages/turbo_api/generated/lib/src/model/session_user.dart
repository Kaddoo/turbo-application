//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/staff_role.dart';
import 'package:turbo_api_generated/src/model/user_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_user.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SessionUser {
  /// Returns a new [SessionUser] instance.
  SessionUser({

    required  this.id,

    required  this.role,

     this.staffRole,

     this.displayName,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserRole role;



  @JsonKey(
    
    name: r'staffRole',
    required: false,
    includeIfNull: false,
  )


  final StaffRole? staffRole;



  @JsonKey(
    
    name: r'displayName',
    required: false,
    includeIfNull: false,
  )


  final String? displayName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SessionUser &&
      other.id == id &&
      other.role == role &&
      other.staffRole == staffRole &&
      other.displayName == displayName;

    @override
    int get hashCode =>
        id.hashCode +
        role.hashCode +
        (staffRole == null ? 0 : staffRole.hashCode) +
        displayName.hashCode;

  factory SessionUser.fromJson(Map<String, dynamic> json) => _$SessionUserFromJson(json);

  Map<String, dynamic> toJson() => _$SessionUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

