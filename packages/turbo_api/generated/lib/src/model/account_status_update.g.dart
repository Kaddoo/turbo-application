// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_status_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AccountStatusUpdateCWProxy {
  AccountStatusUpdate accountStatus(AccountStatus accountStatus);

  AccountStatusUpdate reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AccountStatusUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AccountStatusUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  AccountStatusUpdate call({AccountStatus accountStatus, String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAccountStatusUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAccountStatusUpdate.copyWith.fieldName(...)`
class _$AccountStatusUpdateCWProxyImpl implements _$AccountStatusUpdateCWProxy {
  const _$AccountStatusUpdateCWProxyImpl(this._value);

  final AccountStatusUpdate _value;

  @override
  AccountStatusUpdate accountStatus(AccountStatus accountStatus) =>
      this(accountStatus: accountStatus);

  @override
  AccountStatusUpdate reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AccountStatusUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AccountStatusUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  AccountStatusUpdate call({
    Object? accountStatus = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return AccountStatusUpdate(
      accountStatus: accountStatus == const $CopyWithPlaceholder()
          ? _value.accountStatus
          // ignore: cast_nullable_to_non_nullable
          : accountStatus as AccountStatus,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $AccountStatusUpdateCopyWith on AccountStatusUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfAccountStatusUpdate.copyWith(...)` or like so:`instanceOfAccountStatusUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AccountStatusUpdateCWProxy get copyWith =>
      _$AccountStatusUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStatusUpdate _$AccountStatusUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountStatusUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['accountStatus', 'reason']);
      final val = AccountStatusUpdate(
        accountStatus: $checkedConvert(
          'accountStatus',
          (v) => $enumDecode(_$AccountStatusEnumMap, v),
        ),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AccountStatusUpdateToJson(
  AccountStatusUpdate instance,
) => <String, dynamic>{
  'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
  'reason': instance.reason,
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
};
