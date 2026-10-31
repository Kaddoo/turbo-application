// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartRequestCWProxy {
  StartRequest pin(String pin);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  StartRequest call({String pin});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartRequest.copyWith.fieldName(...)`
class _$StartRequestCWProxyImpl implements _$StartRequestCWProxy {
  const _$StartRequestCWProxyImpl(this._value);

  final StartRequest _value;

  @override
  StartRequest pin(String pin) => this(pin: pin);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  StartRequest call({Object? pin = const $CopyWithPlaceholder()}) {
    return StartRequest(
      pin: pin == const $CopyWithPlaceholder()
          ? _value.pin
          // ignore: cast_nullable_to_non_nullable
          : pin as String,
    );
  }
}

extension $StartRequestCopyWith on StartRequest {
  /// Returns a callable class that can be used as follows: `instanceOfStartRequest.copyWith(...)` or like so:`instanceOfStartRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartRequestCWProxy get copyWith => _$StartRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartRequest _$StartRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StartRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['pin']);
      final val = StartRequest(pin: $checkedConvert('pin', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$StartRequestToJson(StartRequest instance) =>
    <String, dynamic>{'pin': instance.pin};
