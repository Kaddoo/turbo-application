// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SessionListCWProxy {
  SessionList items(List<Session> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionList(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionList call({List<Session> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSessionList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSessionList.copyWith.fieldName(...)`
class _$SessionListCWProxyImpl implements _$SessionListCWProxy {
  const _$SessionListCWProxyImpl(this._value);

  final SessionList _value;

  @override
  SessionList items(List<Session> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionList(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionList call({Object? items = const $CopyWithPlaceholder()}) {
    return SessionList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Session>,
    );
  }
}

extension $SessionListCopyWith on SessionList {
  /// Returns a callable class that can be used as follows: `instanceOfSessionList.copyWith(...)` or like so:`instanceOfSessionList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SessionListCWProxy get copyWith => _$SessionListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionList _$SessionListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SessionList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = SessionList(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => Session.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SessionListToJson(SessionList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
