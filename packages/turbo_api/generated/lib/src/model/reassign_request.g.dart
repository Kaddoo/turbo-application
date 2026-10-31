// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReassignRequestCWProxy {
  ReassignRequest driverId(String driverId);

  ReassignRequest reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReassignRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReassignRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReassignRequest call({String driverId, String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReassignRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReassignRequest.copyWith.fieldName(...)`
class _$ReassignRequestCWProxyImpl implements _$ReassignRequestCWProxy {
  const _$ReassignRequestCWProxyImpl(this._value);

  final ReassignRequest _value;

  @override
  ReassignRequest driverId(String driverId) => this(driverId: driverId);

  @override
  ReassignRequest reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReassignRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReassignRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReassignRequest call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return ReassignRequest(
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ReassignRequestCopyWith on ReassignRequest {
  /// Returns a callable class that can be used as follows: `instanceOfReassignRequest.copyWith(...)` or like so:`instanceOfReassignRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReassignRequestCWProxy get copyWith => _$ReassignRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignRequest _$ReassignRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReassignRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['driverId', 'reason']);
      final val = ReassignRequest(
        driverId: $checkedConvert('driverId', (v) => v as String),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReassignRequestToJson(ReassignRequest instance) =>
    <String, dynamic>{'driverId': instance.driverId, 'reason': instance.reason};
