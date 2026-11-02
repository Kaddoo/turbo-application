// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notice.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomeNoticeCWProxy {
  HomeNotice id(String id);

  HomeNotice message(String message);

  HomeNotice severity(HomeNoticeSeverityEnum severity);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeNotice(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeNotice(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeNotice call({String id, String message, HomeNoticeSeverityEnum severity});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomeNotice.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomeNotice.copyWith.fieldName(...)`
class _$HomeNoticeCWProxyImpl implements _$HomeNoticeCWProxy {
  const _$HomeNoticeCWProxyImpl(this._value);

  final HomeNotice _value;

  @override
  HomeNotice id(String id) => this(id: id);

  @override
  HomeNotice message(String message) => this(message: message);

  @override
  HomeNotice severity(HomeNoticeSeverityEnum severity) =>
      this(severity: severity);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeNotice(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeNotice(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeNotice call({
    Object? id = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? severity = const $CopyWithPlaceholder(),
  }) {
    return HomeNotice(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      severity: severity == const $CopyWithPlaceholder()
          ? _value.severity
          // ignore: cast_nullable_to_non_nullable
          : severity as HomeNoticeSeverityEnum,
    );
  }
}

extension $HomeNoticeCopyWith on HomeNotice {
  /// Returns a callable class that can be used as follows: `instanceOfHomeNotice.copyWith(...)` or like so:`instanceOfHomeNotice.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomeNoticeCWProxy get copyWith => _$HomeNoticeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNotice _$HomeNoticeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HomeNotice', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'message', 'severity']);
      final val = HomeNotice(
        id: $checkedConvert('id', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        severity: $checkedConvert(
          'severity',
          (v) => $enumDecode(_$HomeNoticeSeverityEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HomeNoticeToJson(HomeNotice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'severity': _$HomeNoticeSeverityEnumEnumMap[instance.severity]!,
    };

const _$HomeNoticeSeverityEnumEnumMap = {
  HomeNoticeSeverityEnum.info: 'info',
  HomeNoticeSeverityEnum.warning: 'warning',
  HomeNoticeSeverityEnum.critical: 'critical',
};
