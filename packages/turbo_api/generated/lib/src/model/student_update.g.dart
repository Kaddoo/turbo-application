// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StudentUpdateCWProxy {
  StudentUpdate fullName(String? fullName);

  StudentUpdate email(String? email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentUpdate call({String? fullName, String? email});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudentUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudentUpdate.copyWith.fieldName(...)`
class _$StudentUpdateCWProxyImpl implements _$StudentUpdateCWProxy {
  const _$StudentUpdateCWProxyImpl(this._value);

  final StudentUpdate _value;

  @override
  StudentUpdate fullName(String? fullName) => this(fullName: fullName);

  @override
  StudentUpdate email(String? email) => this(email: email);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentUpdate call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
  }) {
    return StudentUpdate(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
    );
  }
}

extension $StudentUpdateCopyWith on StudentUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfStudentUpdate.copyWith(...)` or like so:`instanceOfStudentUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudentUpdateCWProxy get copyWith => _$StudentUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentUpdate _$StudentUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StudentUpdate', json, ($checkedConvert) {
      final val = StudentUpdate(
        fullName: $checkedConvert('fullName', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$StudentUpdateToJson(StudentUpdate instance) =>
    <String, dynamic>{'fullName': ?instance.fullName, 'email': ?instance.email};
