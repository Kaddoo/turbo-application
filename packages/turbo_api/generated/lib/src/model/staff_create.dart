//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/staff_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffCreate {
  /// Returns a new [StaffCreate] instance.
  StaffCreate({

    required  this.email,

    required  this.fullName,

    required  this.staffRole,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'staffRole',
    required: true,
    includeIfNull: false,
  )


  final StaffRole staffRole;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffCreate &&
      other.email == email &&
      other.fullName == fullName &&
      other.staffRole == staffRole;

    @override
    int get hashCode =>
        email.hashCode +
        fullName.hashCode +
        staffRole.hashCode;

  factory StaffCreate.fromJson(Map<String, dynamic> json) => _$StaffCreateFromJson(json);

  Map<String, dynamic> toJson() => _$StaffCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

