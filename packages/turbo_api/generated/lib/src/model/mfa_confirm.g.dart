// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_confirm.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MfaConfirmCWProxy {
  MfaConfirm enrollmentToken(String enrollmentToken);

  MfaConfirm totpCode(String totpCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MfaConfirm(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MfaConfirm(...).copyWith(id: 12, name: "My name")
  /// ````
  MfaConfirm call({String enrollmentToken, String totpCode});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMfaConfirm.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMfaConfirm.copyWith.fieldName(...)`
class _$MfaConfirmCWProxyImpl implements _$MfaConfirmCWProxy {
  const _$MfaConfirmCWProxyImpl(this._value);

  final MfaConfirm _value;

  @override
  MfaConfirm enrollmentToken(String enrollmentToken) =>
      this(enrollmentToken: enrollmentToken);

  @override
  MfaConfirm totpCode(String totpCode) => this(totpCode: totpCode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MfaConfirm(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MfaConfirm(...).copyWith(id: 12, name: "My name")
  /// ````
  MfaConfirm call({
    Object? enrollmentToken = const $CopyWithPlaceholder(),
    Object? totpCode = const $CopyWithPlaceholder(),
  }) {
    return MfaConfirm(
      enrollmentToken: enrollmentToken == const $CopyWithPlaceholder()
          ? _value.enrollmentToken
          // ignore: cast_nullable_to_non_nullable
          : enrollmentToken as String,
      totpCode: totpCode == const $CopyWithPlaceholder()
          ? _value.totpCode
          // ignore: cast_nullable_to_non_nullable
          : totpCode as String,
    );
  }
}

extension $MfaConfirmCopyWith on MfaConfirm {
  /// Returns a callable class that can be used as follows: `instanceOfMfaConfirm.copyWith(...)` or like so:`instanceOfMfaConfirm.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MfaConfirmCWProxy get copyWith => _$MfaConfirmCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MfaConfirm _$MfaConfirmFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MfaConfirm', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['enrollmentToken', 'totpCode']);
      final val = MfaConfirm(
        enrollmentToken: $checkedConvert('enrollmentToken', (v) => v as String),
        totpCode: $checkedConvert('totpCode', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MfaConfirmToJson(MfaConfirm instance) =>
    <String, dynamic>{
      'enrollmentToken': instance.enrollmentToken,
      'totpCode': instance.totpCode,
    };
