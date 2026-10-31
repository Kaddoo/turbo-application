// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShareCreateCWProxy {
  ShareCreate trustedContactIds(List<String> trustedContactIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShareCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShareCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  ShareCreate call({List<String> trustedContactIds});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShareCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShareCreate.copyWith.fieldName(...)`
class _$ShareCreateCWProxyImpl implements _$ShareCreateCWProxy {
  const _$ShareCreateCWProxyImpl(this._value);

  final ShareCreate _value;

  @override
  ShareCreate trustedContactIds(List<String> trustedContactIds) =>
      this(trustedContactIds: trustedContactIds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShareCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShareCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  ShareCreate call({Object? trustedContactIds = const $CopyWithPlaceholder()}) {
    return ShareCreate(
      trustedContactIds: trustedContactIds == const $CopyWithPlaceholder()
          ? _value.trustedContactIds
          // ignore: cast_nullable_to_non_nullable
          : trustedContactIds as List<String>,
    );
  }
}

extension $ShareCreateCopyWith on ShareCreate {
  /// Returns a callable class that can be used as follows: `instanceOfShareCreate.copyWith(...)` or like so:`instanceOfShareCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShareCreateCWProxy get copyWith => _$ShareCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareCreate _$ShareCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ShareCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['trustedContactIds']);
      final val = ShareCreate(
        trustedContactIds: $checkedConvert(
          'trustedContactIds',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ShareCreateToJson(ShareCreate instance) =>
    <String, dynamic>{'trustedContactIds': instance.trustedContactIds};
