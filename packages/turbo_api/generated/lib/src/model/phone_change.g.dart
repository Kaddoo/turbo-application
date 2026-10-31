// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_change.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PhoneChangeCWProxy {
  PhoneChange newPhone(String newPhone);

  PhoneChange ticketId(String ticketId);

  PhoneChange note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneChange(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneChange call({String newPhone, String ticketId, String note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPhoneChange.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPhoneChange.copyWith.fieldName(...)`
class _$PhoneChangeCWProxyImpl implements _$PhoneChangeCWProxy {
  const _$PhoneChangeCWProxyImpl(this._value);

  final PhoneChange _value;

  @override
  PhoneChange newPhone(String newPhone) => this(newPhone: newPhone);

  @override
  PhoneChange ticketId(String ticketId) => this(ticketId: ticketId);

  @override
  PhoneChange note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneChange(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneChange call({
    Object? newPhone = const $CopyWithPlaceholder(),
    Object? ticketId = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return PhoneChange(
      newPhone: newPhone == const $CopyWithPlaceholder()
          ? _value.newPhone
          // ignore: cast_nullable_to_non_nullable
          : newPhone as String,
      ticketId: ticketId == const $CopyWithPlaceholder()
          ? _value.ticketId
          // ignore: cast_nullable_to_non_nullable
          : ticketId as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $PhoneChangeCopyWith on PhoneChange {
  /// Returns a callable class that can be used as follows: `instanceOfPhoneChange.copyWith(...)` or like so:`instanceOfPhoneChange.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PhoneChangeCWProxy get copyWith => _$PhoneChangeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneChange _$PhoneChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PhoneChange', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['newPhone', 'ticketId', 'note']);
      final val = PhoneChange(
        newPhone: $checkedConvert('newPhone', (v) => v as String),
        ticketId: $checkedConvert('ticketId', (v) => v as String),
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PhoneChangeToJson(PhoneChange instance) =>
    <String, dynamic>{
      'newPhone': instance.newPhone,
      'ticketId': instance.ticketId,
      'note': instance.note,
    };
