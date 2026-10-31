// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operating_window.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OperatingWindowCWProxy {
  OperatingWindow dayOfWeek(int dayOfWeek);

  OperatingWindow opensAt(String opensAt);

  OperatingWindow closesAt(String closesAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OperatingWindow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OperatingWindow(...).copyWith(id: 12, name: "My name")
  /// ````
  OperatingWindow call({int dayOfWeek, String opensAt, String closesAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOperatingWindow.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOperatingWindow.copyWith.fieldName(...)`
class _$OperatingWindowCWProxyImpl implements _$OperatingWindowCWProxy {
  const _$OperatingWindowCWProxyImpl(this._value);

  final OperatingWindow _value;

  @override
  OperatingWindow dayOfWeek(int dayOfWeek) => this(dayOfWeek: dayOfWeek);

  @override
  OperatingWindow opensAt(String opensAt) => this(opensAt: opensAt);

  @override
  OperatingWindow closesAt(String closesAt) => this(closesAt: closesAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OperatingWindow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OperatingWindow(...).copyWith(id: 12, name: "My name")
  /// ````
  OperatingWindow call({
    Object? dayOfWeek = const $CopyWithPlaceholder(),
    Object? opensAt = const $CopyWithPlaceholder(),
    Object? closesAt = const $CopyWithPlaceholder(),
  }) {
    return OperatingWindow(
      dayOfWeek: dayOfWeek == const $CopyWithPlaceholder()
          ? _value.dayOfWeek
          // ignore: cast_nullable_to_non_nullable
          : dayOfWeek as int,
      opensAt: opensAt == const $CopyWithPlaceholder()
          ? _value.opensAt
          // ignore: cast_nullable_to_non_nullable
          : opensAt as String,
      closesAt: closesAt == const $CopyWithPlaceholder()
          ? _value.closesAt
          // ignore: cast_nullable_to_non_nullable
          : closesAt as String,
    );
  }
}

extension $OperatingWindowCopyWith on OperatingWindow {
  /// Returns a callable class that can be used as follows: `instanceOfOperatingWindow.copyWith(...)` or like so:`instanceOfOperatingWindow.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OperatingWindowCWProxy get copyWith => _$OperatingWindowCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperatingWindow _$OperatingWindowFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OperatingWindow', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['dayOfWeek', 'opensAt', 'closesAt'],
      );
      final val = OperatingWindow(
        dayOfWeek: $checkedConvert('dayOfWeek', (v) => (v as num).toInt()),
        opensAt: $checkedConvert('opensAt', (v) => v as String),
        closesAt: $checkedConvert('closesAt', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$OperatingWindowToJson(OperatingWindow instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'opensAt': instance.opensAt,
      'closesAt': instance.closesAt,
    };
