//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/staff_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_user.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffUser {
  /// Returns a new [StaffUser] instance.
  StaffUser({

    required  this.id,

    required  this.email,

    required  this.fullName,

    required  this.staffRole,

    required  this.isActive,

    required  this.mfaEnrolled,

     this.lastLoginAt,

     this.lockedUntil,

     this.invitePending,

     this.adjustmentApprovalThresholdPesewas,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    
    name: r'mfaEnrolled',
    required: true,
    includeIfNull: false,
  )


  final bool mfaEnrolled;



  @JsonKey(
    
    name: r'lastLoginAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? lastLoginAt;



  @JsonKey(
    
    name: r'lockedUntil',
    required: false,
    includeIfNull: false,
  )


  final DateTime? lockedUntil;



  @JsonKey(
    
    name: r'invitePending',
    required: false,
    includeIfNull: false,
  )


  final bool? invitePending;



      /// Only for finance and super admin. A wallet adjustment above this amount needs a second approver.
          // minimum: 0
  @JsonKey(
    
    name: r'adjustmentApprovalThresholdPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? adjustmentApprovalThresholdPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffUser &&
      other.id == id &&
      other.email == email &&
      other.fullName == fullName &&
      other.staffRole == staffRole &&
      other.isActive == isActive &&
      other.mfaEnrolled == mfaEnrolled &&
      other.lastLoginAt == lastLoginAt &&
      other.lockedUntil == lockedUntil &&
      other.invitePending == invitePending &&
      other.adjustmentApprovalThresholdPesewas == adjustmentApprovalThresholdPesewas;

    @override
    int get hashCode =>
        id.hashCode +
        email.hashCode +
        fullName.hashCode +
        staffRole.hashCode +
        isActive.hashCode +
        mfaEnrolled.hashCode +
        (lastLoginAt == null ? 0 : lastLoginAt.hashCode) +
        (lockedUntil == null ? 0 : lockedUntil.hashCode) +
        invitePending.hashCode +
        adjustmentApprovalThresholdPesewas.hashCode;

  factory StaffUser.fromJson(Map<String, dynamic> json) => _$StaffUserFromJson(json);

  Map<String, dynamic> toJson() => _$StaffUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

