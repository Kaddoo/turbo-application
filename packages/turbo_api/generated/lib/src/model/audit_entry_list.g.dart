// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditEntryListCWProxy {
  AuditEntryList data(List<AuditEntry> data);

  AuditEntryList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryList(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryList call({List<AuditEntry> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditEntryList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditEntryList.copyWith.fieldName(...)`
class _$AuditEntryListCWProxyImpl implements _$AuditEntryListCWProxy {
  const _$AuditEntryListCWProxyImpl(this._value);

  final AuditEntryList _value;

  @override
  AuditEntryList data(List<AuditEntry> data) => this(data: data);

  @override
  AuditEntryList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryList(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return AuditEntryList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<AuditEntry>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $AuditEntryListCopyWith on AuditEntryList {
  /// Returns a callable class that can be used as follows: `instanceOfAuditEntryList.copyWith(...)` or like so:`instanceOfAuditEntryList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditEntryListCWProxy get copyWith => _$AuditEntryListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryList _$AuditEntryListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditEntryList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = AuditEntryList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => AuditEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuditEntryListToJson(AuditEntryList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
