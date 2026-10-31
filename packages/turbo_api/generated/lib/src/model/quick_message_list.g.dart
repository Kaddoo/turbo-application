// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_message_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuickMessageListCWProxy {
  QuickMessageList items(List<QuickMessage> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessageList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessageList(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessageList call({List<QuickMessage> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuickMessageList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuickMessageList.copyWith.fieldName(...)`
class _$QuickMessageListCWProxyImpl implements _$QuickMessageListCWProxy {
  const _$QuickMessageListCWProxyImpl(this._value);

  final QuickMessageList _value;

  @override
  QuickMessageList items(List<QuickMessage> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuickMessageList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuickMessageList(...).copyWith(id: 12, name: "My name")
  /// ````
  QuickMessageList call({Object? items = const $CopyWithPlaceholder()}) {
    return QuickMessageList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<QuickMessage>,
    );
  }
}

extension $QuickMessageListCopyWith on QuickMessageList {
  /// Returns a callable class that can be used as follows: `instanceOfQuickMessageList.copyWith(...)` or like so:`instanceOfQuickMessageList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuickMessageListCWProxy get copyWith => _$QuickMessageListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickMessageList _$QuickMessageListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuickMessageList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = QuickMessageList(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => QuickMessage.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuickMessageListToJson(QuickMessageList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
