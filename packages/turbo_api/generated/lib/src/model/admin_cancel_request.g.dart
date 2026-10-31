// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCancelRequestCWProxy {
  AdminCancelRequest reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCancelRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCancelRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCancelRequest call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCancelRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCancelRequest.copyWith.fieldName(...)`
class _$AdminCancelRequestCWProxyImpl implements _$AdminCancelRequestCWProxy {
  const _$AdminCancelRequestCWProxyImpl(this._value);

  final AdminCancelRequest _value;

  @override
  AdminCancelRequest reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCancelRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCancelRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCancelRequest call({Object? reason = const $CopyWithPlaceholder()}) {
    return AdminCancelRequest(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $AdminCancelRequestCopyWith on AdminCancelRequest {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCancelRequest.copyWith(...)` or like so:`instanceOfAdminCancelRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCancelRequestCWProxy get copyWith =>
      _$AdminCancelRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCancelRequest _$AdminCancelRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminCancelRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = AdminCancelRequest(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminCancelRequestToJson(AdminCancelRequest instance) =>
    <String, dynamic>{'reason': instance.reason};
