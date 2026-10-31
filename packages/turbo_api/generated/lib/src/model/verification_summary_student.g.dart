// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_summary_student.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationSummaryStudentCWProxy {
  VerificationSummaryStudent id(String id);

  VerificationSummaryStudent fullName(String? fullName);

  VerificationSummaryStudent phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummaryStudent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummaryStudent(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummaryStudent call({String id, String? fullName, String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationSummaryStudent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationSummaryStudent.copyWith.fieldName(...)`
class _$VerificationSummaryStudentCWProxyImpl
    implements _$VerificationSummaryStudentCWProxy {
  const _$VerificationSummaryStudentCWProxyImpl(this._value);

  final VerificationSummaryStudent _value;

  @override
  VerificationSummaryStudent id(String id) => this(id: id);

  @override
  VerificationSummaryStudent fullName(String? fullName) =>
      this(fullName: fullName);

  @override
  VerificationSummaryStudent phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummaryStudent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummaryStudent(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummaryStudent call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
  }) {
    return VerificationSummaryStudent(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $VerificationSummaryStudentCopyWith on VerificationSummaryStudent {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationSummaryStudent.copyWith(...)` or like so:`instanceOfVerificationSummaryStudent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationSummaryStudentCWProxy get copyWith =>
      _$VerificationSummaryStudentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationSummaryStudent _$VerificationSummaryStudentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationSummaryStudent', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'phone']);
  final val = VerificationSummaryStudent(
    id: $checkedConvert('id', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String?),
    phone: $checkedConvert('phone', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$VerificationSummaryStudentToJson(
  VerificationSummaryStudent instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': ?instance.fullName,
  'phone': instance.phone,
};
