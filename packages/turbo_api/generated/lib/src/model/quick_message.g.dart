// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuickMessageCWProxy {
  QuickMessage from(QuickMessageFromEnum from);

  QuickMessage code(QuickMessageCode code);

  QuickMessage sentAt(DateTime sentAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessage(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessage call({
    QuickMessageFromEnum from,
    QuickMessageCode code,
    DateTime sentAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuickMessage.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuickMessage.copyWith.fieldName(...)`
class _$QuickMessageCWProxyImpl implements _$QuickMessageCWProxy {
  const _$QuickMessageCWProxyImpl(this._value);

  final QuickMessage _value;

  @override
  QuickMessage from(QuickMessageFromEnum from) => this(from: from);

  @override
  QuickMessage code(QuickMessageCode code) => this(code: code);

  @override
  QuickMessage sentAt(DateTime sentAt) => this(sentAt: sentAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessage(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessage call({
    Object? from = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? sentAt = const $CopyWithPlaceholder(),
  }) {
    return QuickMessage(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as QuickMessageFromEnum,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as QuickMessageCode,
      sentAt: sentAt == const $CopyWithPlaceholder()
          ? _value.sentAt
          // ignore: cast_nullable_to_non_nullable
          : sentAt as DateTime,
    );
  }
}

extension $QuickMessageCopyWith on QuickMessage {
  /// Returns a callable class that can be used as follows: `instanceOfQuickMessage.copyWith(...)` or like so:`instanceOfQuickMessage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuickMessageCWProxy get copyWith => _$QuickMessageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickMessage _$QuickMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuickMessage', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['from', 'code', 'sentAt']);
      final val = QuickMessage(
        from: $checkedConvert(
          'from',
          (v) => $enumDecode(_$QuickMessageFromEnumEnumMap, v),
        ),
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$QuickMessageCodeEnumMap, v),
        ),
        sentAt: $checkedConvert('sentAt', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$QuickMessageToJson(QuickMessage instance) =>
    <String, dynamic>{
      'from': _$QuickMessageFromEnumEnumMap[instance.from]!,
      'code': _$QuickMessageCodeEnumMap[instance.code]!,
      'sentAt': instance.sentAt.toIso8601String(),
    };

const _$QuickMessageFromEnumEnumMap = {
  QuickMessageFromEnum.student: 'student',
  QuickMessageFromEnum.driver: 'driver',
};

const _$QuickMessageCodeEnumMap = {
  QuickMessageCode.imHere: 'im_here',
  QuickMessageCode.runningLate: 'running_late',
  QuickMessageCode.atTheGate: 'at_the_gate',
  QuickMessageCode.cannotFindYou: 'cannot_find_you',
  QuickMessageCode.pleaseComeOut: 'please_come_out',
  QuickMessageCode.onMyWay: 'on_my_way',
};
