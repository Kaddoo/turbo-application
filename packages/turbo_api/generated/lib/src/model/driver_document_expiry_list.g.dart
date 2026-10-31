// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_document_expiry_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDocumentExpiryListCWProxy {
  DriverDocumentExpiryList items(List<DriverDocumentExpiry> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentExpiryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentExpiryList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentExpiryList call({List<DriverDocumentExpiry> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDocumentExpiryList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDocumentExpiryList.copyWith.fieldName(...)`
class _$DriverDocumentExpiryListCWProxyImpl
    implements _$DriverDocumentExpiryListCWProxy {
  const _$DriverDocumentExpiryListCWProxyImpl(this._value);

  final DriverDocumentExpiryList _value;

  @override
  DriverDocumentExpiryList items(List<DriverDocumentExpiry> items) =>
      this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentExpiryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentExpiryList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentExpiryList call({
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return DriverDocumentExpiryList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<DriverDocumentExpiry>,
    );
  }
}

extension $DriverDocumentExpiryListCopyWith on DriverDocumentExpiryList {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDocumentExpiryList.copyWith(...)` or like so:`instanceOfDriverDocumentExpiryList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDocumentExpiryListCWProxy get copyWith =>
      _$DriverDocumentExpiryListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDocumentExpiryList _$DriverDocumentExpiryListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DriverDocumentExpiryList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items']);
  final val = DriverDocumentExpiryList(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => DriverDocumentExpiry.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$DriverDocumentExpiryListToJson(
  DriverDocumentExpiryList instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
