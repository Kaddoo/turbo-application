// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_contact_collection.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrustedContactCollectionCWProxy {
  TrustedContactCollection data(List<TrustedContact> data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContactCollection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContactCollection(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContactCollection call({List<TrustedContact> data});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrustedContactCollection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrustedContactCollection.copyWith.fieldName(...)`
class _$TrustedContactCollectionCWProxyImpl
    implements _$TrustedContactCollectionCWProxy {
  const _$TrustedContactCollectionCWProxyImpl(this._value);

  final TrustedContactCollection _value;

  @override
  TrustedContactCollection data(List<TrustedContact> data) => this(data: data);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContactCollection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContactCollection(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContactCollection call({Object? data = const $CopyWithPlaceholder()}) {
    return TrustedContactCollection(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<TrustedContact>,
    );
  }
}

extension $TrustedContactCollectionCopyWith on TrustedContactCollection {
  /// Returns a callable class that can be used as follows: `instanceOfTrustedContactCollection.copyWith(...)` or like so:`instanceOfTrustedContactCollection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrustedContactCollectionCWProxy get copyWith =>
      _$TrustedContactCollectionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustedContactCollection _$TrustedContactCollectionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TrustedContactCollection', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = TrustedContactCollection(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => TrustedContact.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TrustedContactCollectionToJson(
  TrustedContactCollection instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
