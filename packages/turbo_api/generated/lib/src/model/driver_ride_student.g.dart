// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_ride_student.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverRideStudentCWProxy {
  DriverRideStudent firstName(String firstName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRideStudent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRideStudent(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRideStudent call({String firstName});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverRideStudent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverRideStudent.copyWith.fieldName(...)`
class _$DriverRideStudentCWProxyImpl implements _$DriverRideStudentCWProxy {
  const _$DriverRideStudentCWProxyImpl(this._value);

  final DriverRideStudent _value;

  @override
  DriverRideStudent firstName(String firstName) => this(firstName: firstName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRideStudent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRideStudent(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRideStudent call({Object? firstName = const $CopyWithPlaceholder()}) {
    return DriverRideStudent(
      firstName: firstName == const $CopyWithPlaceholder()
          ? _value.firstName
          // ignore: cast_nullable_to_non_nullable
          : firstName as String,
    );
  }
}

extension $DriverRideStudentCopyWith on DriverRideStudent {
  /// Returns a callable class that can be used as follows: `instanceOfDriverRideStudent.copyWith(...)` or like so:`instanceOfDriverRideStudent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverRideStudentCWProxy get copyWith =>
      _$DriverRideStudentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRideStudent _$DriverRideStudentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverRideStudent', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['firstName']);
      final val = DriverRideStudent(
        firstName: $checkedConvert('firstName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DriverRideStudentToJson(DriverRideStudent instance) =>
    <String, dynamic>{'firstName': instance.firstName};
