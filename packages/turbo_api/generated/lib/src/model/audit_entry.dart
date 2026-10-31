//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_entry.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditEntry {
  /// Returns a new [AuditEntry] instance.
  AuditEntry({

    required  this.id,

    required  this.at,

     this.actorStaffId,

    required  this.action,

    required  this.entityType,

    required  this.entityId,

     this.detail,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'actorStaffId',
    required: false,
    includeIfNull: false,
  )


  final String? actorStaffId;



      /// e.g. verification.approved, wallet.adjusted, ride.reassigned
  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'entityType',
    required: true,
    includeIfNull: false,
  )


  final String entityType;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'entityId',
    required: true,
    includeIfNull: false,
  )


  final String entityId;



  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false,
  )


  final Map<String, Object>? detail;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditEntry &&
      other.id == id &&
      other.at == at &&
      other.actorStaffId == actorStaffId &&
      other.action == action &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.detail == detail;

    @override
    int get hashCode =>
        id.hashCode +
        at.hashCode +
        (actorStaffId == null ? 0 : actorStaffId.hashCode) +
        action.hashCode +
        entityType.hashCode +
        entityId.hashCode +
        detail.hashCode;

  factory AuditEntry.fromJson(Map<String, dynamic> json) => _$AuditEntryFromJson(json);

  Map<String, dynamic> toJson() => _$AuditEntryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

