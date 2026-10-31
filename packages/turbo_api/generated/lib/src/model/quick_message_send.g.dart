// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_message_send.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuickMessageSendCWProxy {
  QuickMessageSend code(QuickMessageCode code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessageSend(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessageSend(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessageSend call({QuickMessageCode code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuickMessageSend.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuickMessageSend.copyWith.fieldName(...)`
class _$QuickMessageSendCWProxyImpl implements _$QuickMessageSendCWProxy {
  const _$QuickMessageSendCWProxyImpl(this._value);

  final QuickMessageSend _value;

  @override
  QuickMessageSend code(QuickMessageCode code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessageSend(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessageSend(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessageSend call({Object? code = const $CopyWithPlaceholder()}) {
    return QuickMessageSend(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as QuickMessageCode,
    );
  }
}

extension $QuickMessageSendCopyWith on QuickMessageSend {
  /// Returns a callable class that can be used as follows: `instanceOfQuickMessageSend.copyWith(...)` or like so:`instanceOfQuickMessageSend.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuickMessageSendCWProxy get copyWith => _$QuickMessageSendCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickMessageSend _$QuickMessageSendFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuickMessageSend', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code']);
      final val = QuickMessageSend(
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$QuickMessageCodeEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuickMessageSendToJson(QuickMessageSend instance) =>
    <String, dynamic>{'code': _$QuickMessageCodeEnumMap[instance.code]!};

const _$QuickMessageCodeEnumMap = {
  QuickMessageCode.imHere: 'im_here',
  QuickMessageCode.runningLate: 'running_late',
  QuickMessageCode.atTheGate: 'at_the_gate',
  QuickMessageCode.cannotFindYou: 'cannot_find_you',
  QuickMessageCode.pleaseComeOut: 'please_come_out',
  QuickMessageCode.onMyWay: 'on_my_way',
};
