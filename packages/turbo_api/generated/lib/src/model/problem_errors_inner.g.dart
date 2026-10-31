// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_errors_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProblemErrorsInnerCWProxy {
  ProblemErrorsInner field(String field);

  ProblemErrorsInner message(String message);

  ProblemErrorsInner code(String? code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProblemErrorsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProblemErrorsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ProblemErrorsInner call({String field, String message, String? code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProblemErrorsInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProblemErrorsInner.copyWith.fieldName(...)`
class _$ProblemErrorsInnerCWProxyImpl implements _$ProblemErrorsInnerCWProxy {
  const _$ProblemErrorsInnerCWProxyImpl(this._value);

  final ProblemErrorsInner _value;

  @override
  ProblemErrorsInner field(String field) => this(field: field);

  @override
  ProblemErrorsInner message(String message) => this(message: message);

  @override
  ProblemErrorsInner code(String? code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProblemErrorsInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProblemErrorsInner(...).copyWith(id: 12, name: "My name")
  /// ````
  ProblemErrorsInner call({
    Object? field = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return ProblemErrorsInner(
      field: field == const $CopyWithPlaceholder()
          ? _value.field
          // ignore: cast_nullable_to_non_nullable
          : field as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
    );
  }
}

extension $ProblemErrorsInnerCopyWith on ProblemErrorsInner {
  /// Returns a callable class that can be used as follows: `instanceOfProblemErrorsInner.copyWith(...)` or like so:`instanceOfProblemErrorsInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProblemErrorsInnerCWProxy get copyWith =>
      _$ProblemErrorsInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemErrorsInner _$ProblemErrorsInnerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProblemErrorsInner', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['field', 'message']);
      final val = ProblemErrorsInner(
        field: $checkedConvert('field', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ProblemErrorsInnerToJson(ProblemErrorsInner instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
      'code': ?instance.code,
    };
