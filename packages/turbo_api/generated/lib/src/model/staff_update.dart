//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/staff_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffUpdate {
  /// Returns a new [StaffUpdate] instance.
  StaffUpdate({

     this.staffRole,

     this.isActive,
  });

  @JsonKey(
    
    name: r'staffRole',
    required: false,
    includeIfNull: false,
  )


  final StaffRole? staffRole;



  @JsonKey(
    
    name: r'isActive',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffUpdate &&
      other.staffRole == staffRole &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        staffRole.hashCode +
        isActive.hashCode;

  factory StaffUpdate.fromJson(Map<String, dynamic> json) => _$StaffUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$StaffUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

