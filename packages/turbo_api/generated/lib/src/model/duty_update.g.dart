// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duty_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DutyUpdateCWProxy {
  DutyUpdate onDuty(bool onDuty);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DutyUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DutyUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  DutyUpdate call({bool onDuty});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDutyUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDutyUpdate.copyWith.fieldName(...)`
class _$DutyUpdateCWProxyImpl implements _$DutyUpdateCWProxy {
  const _$DutyUpdateCWProxyImpl(this._value);

  final DutyUpdate _value;

  @override
  DutyUpdate onDuty(bool onDuty) => this(onDuty: onDuty);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DutyUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DutyUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  DutyUpdate call({Object? onDuty = const $CopyWithPlaceholder()}) {
    return DutyUpdate(
      onDuty: onDuty == const $CopyWithPlaceholder()
          ? _value.onDuty
          // ignore: cast_nullable_to_non_nullable
          : onDuty as bool,
    );
  }
}

extension $DutyUpdateCopyWith on DutyUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfDutyUpdate.copyWith(...)` or like so:`instanceOfDutyUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DutyUpdateCWProxy get copyWith => _$DutyUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DutyUpdate _$DutyUpdateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DutyUpdate',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['onDuty']);
    final val = DutyUpdate(onDuty: $checkedConvert('onDuty', (v) => v as bool));
    return val;
  },
);

Map<String, dynamic> _$DutyUpdateToJson(DutyUpdate instance) =>
    <String, dynamic>{'onDuty': instance.onDuty};
