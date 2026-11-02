// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notice_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomeNoticeInputCWProxy {
  HomeNoticeInput message(String message);

  HomeNoticeInput severity(HomeNoticeInputSeverityEnum severity);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeNoticeInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeNoticeInput(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeNoticeInput call({String message, HomeNoticeInputSeverityEnum severity});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomeNoticeInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomeNoticeInput.copyWith.fieldName(...)`
class _$HomeNoticeInputCWProxyImpl implements _$HomeNoticeInputCWProxy {
  const _$HomeNoticeInputCWProxyImpl(this._value);

  final HomeNoticeInput _value;

  @override
  HomeNoticeInput message(String message) => this(message: message);

  @override
  HomeNoticeInput severity(HomeNoticeInputSeverityEnum severity) =>
      this(severity: severity);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeNoticeInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeNoticeInput(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeNoticeInput call({
    Object? message = const $CopyWithPlaceholder(),
    Object? severity = const $CopyWithPlaceholder(),
  }) {
    return HomeNoticeInput(
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      severity: severity == const $CopyWithPlaceholder()
          ? _value.severity
          // ignore: cast_nullable_to_non_nullable
          : severity as HomeNoticeInputSeverityEnum,
    );
  }
}

extension $HomeNoticeInputCopyWith on HomeNoticeInput {
  /// Returns a callable class that can be used as follows: `instanceOfHomeNoticeInput.copyWith(...)` or like so:`instanceOfHomeNoticeInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomeNoticeInputCWProxy get copyWith => _$HomeNoticeInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNoticeInput _$HomeNoticeInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HomeNoticeInput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['message', 'severity']);
      final val = HomeNoticeInput(
        message: $checkedConvert('message', (v) => v as String),
        severity: $checkedConvert(
          'severity',
          (v) => $enumDecode(_$HomeNoticeInputSeverityEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HomeNoticeInputToJson(HomeNoticeInput instance) =>
    <String, dynamic>{
      'message': instance.message,
      'severity': _$HomeNoticeInputSeverityEnumEnumMap[instance.severity]!,
    };

const _$HomeNoticeInputSeverityEnumEnumMap = {
  HomeNoticeInputSeverityEnum.info: 'info',
  HomeNoticeInputSeverityEnum.warning: 'warning',
  HomeNoticeInputSeverityEnum.critical: 'critical',
};
