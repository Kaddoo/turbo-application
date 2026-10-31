// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditEntryCWProxy {
  AuditEntry id(String id);

  AuditEntry at(DateTime at);

  AuditEntry actorStaffId(String? actorStaffId);

  AuditEntry action(String action);

  AuditEntry entityType(String entityType);

  AuditEntry entityId(String entityId);

  AuditEntry detail(Map<String, Object>? detail);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntry(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntry call({
    String id,
    DateTime at,
    String? actorStaffId,
    String action,
    String entityType,
    String entityId,
    Map<String, Object>? detail,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditEntry.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditEntry.copyWith.fieldName(...)`
class _$AuditEntryCWProxyImpl implements _$AuditEntryCWProxy {
  const _$AuditEntryCWProxyImpl(this._value);

  final AuditEntry _value;

  @override
  AuditEntry id(String id) => this(id: id);

  @override
  AuditEntry at(DateTime at) => this(at: at);

  @override
  AuditEntry actorStaffId(String? actorStaffId) =>
      this(actorStaffId: actorStaffId);

  @override
  AuditEntry action(String action) => this(action: action);

  @override
  AuditEntry entityType(String entityType) => this(entityType: entityType);

  @override
  AuditEntry entityId(String entityId) => this(entityId: entityId);

  @override
  AuditEntry detail(Map<String, Object>? detail) => this(detail: detail);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntry(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntry call({
    Object? id = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? actorStaffId = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? entityType = const $CopyWithPlaceholder(),
    Object? entityId = const $CopyWithPlaceholder(),
    Object? detail = const $CopyWithPlaceholder(),
  }) {
    return AuditEntry(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      actorStaffId: actorStaffId == const $CopyWithPlaceholder()
          ? _value.actorStaffId
          // ignore: cast_nullable_to_non_nullable
          : actorStaffId as String?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      entityType: entityType == const $CopyWithPlaceholder()
          ? _value.entityType
          // ignore: cast_nullable_to_non_nullable
          : entityType as String,
      entityId: entityId == const $CopyWithPlaceholder()
          ? _value.entityId
          // ignore: cast_nullable_to_non_nullable
          : entityId as String,
      detail: detail == const $CopyWithPlaceholder()
          ? _value.detail
          // ignore: cast_nullable_to_non_nullable
          : detail as Map<String, Object>?,
    );
  }
}

extension $AuditEntryCopyWith on AuditEntry {
  /// Returns a callable class that can be used as follows: `instanceOfAuditEntry.copyWith(...)` or like so:`instanceOfAuditEntry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditEntryCWProxy get copyWith => _$AuditEntryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntry _$AuditEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditEntry', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'at', 'action', 'entityType', 'entityId'],
      );
      final val = AuditEntry(
        id: $checkedConvert('id', (v) => v as String),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        actorStaffId: $checkedConvert('actorStaffId', (v) => v as String?),
        action: $checkedConvert('action', (v) => v as String),
        entityType: $checkedConvert('entityType', (v) => v as String),
        entityId: $checkedConvert('entityId', (v) => v as String),
        detail: $checkedConvert(
          'detail',
          (v) => (v as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as Object),
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuditEntryToJson(AuditEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'at': instance.at.toIso8601String(),
      'actorStaffId': ?instance.actorStaffId,
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'detail': ?instance.detail,
    };
