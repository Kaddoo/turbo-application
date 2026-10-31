// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeletionRequestCWProxy {
  DeletionRequest id(String id);

  DeletionRequest status(DeletionRequestStatusEnum status);

  DeletionRequest requestedAt(DateTime requestedAt);

  DeletionRequest scheduledFor(DateTime? scheduledFor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionRequest call({
    String id,
    DeletionRequestStatusEnum status,
    DateTime requestedAt,
    DateTime? scheduledFor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeletionRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeletionRequest.copyWith.fieldName(...)`
class _$DeletionRequestCWProxyImpl implements _$DeletionRequestCWProxy {
  const _$DeletionRequestCWProxyImpl(this._value);

  final DeletionRequest _value;

  @override
  DeletionRequest id(String id) => this(id: id);

  @override
  DeletionRequest status(DeletionRequestStatusEnum status) =>
      this(status: status);

  @override
  DeletionRequest requestedAt(DateTime requestedAt) =>
      this(requestedAt: requestedAt);

  @override
  DeletionRequest scheduledFor(DateTime? scheduledFor) =>
      this(scheduledFor: scheduledFor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionRequest call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? requestedAt = const $CopyWithPlaceholder(),
    Object? scheduledFor = const $CopyWithPlaceholder(),
  }) {
    return DeletionRequest(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DeletionRequestStatusEnum,
      requestedAt: requestedAt == const $CopyWithPlaceholder()
          ? _value.requestedAt
          // ignore: cast_nullable_to_non_nullable
          : requestedAt as DateTime,
      scheduledFor: scheduledFor == const $CopyWithPlaceholder()
          ? _value.scheduledFor
          // ignore: cast_nullable_to_non_nullable
          : scheduledFor as DateTime?,
    );
  }
}

extension $DeletionRequestCopyWith on DeletionRequest {
  /// Returns a callable class that can be used as follows: `instanceOfDeletionRequest.copyWith(...)` or like so:`instanceOfDeletionRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeletionRequestCWProxy get copyWith => _$DeletionRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletionRequest _$DeletionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeletionRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'status', 'requestedAt']);
      final val = DeletionRequest(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$DeletionRequestStatusEnumEnumMap, v),
        ),
        requestedAt: $checkedConvert(
          'requestedAt',
          (v) => DateTime.parse(v as String),
        ),
        scheduledFor: $checkedConvert(
          'scheduledFor',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeletionRequestToJson(DeletionRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$DeletionRequestStatusEnumEnumMap[instance.status]!,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'scheduledFor': ?instance.scheduledFor?.toIso8601String(),
    };

const _$DeletionRequestStatusEnumEnumMap = {
  DeletionRequestStatusEnum.received: 'received',
  DeletionRequestStatusEnum.scheduled: 'scheduled',
  DeletionRequestStatusEnum.completed: 'completed',
};
