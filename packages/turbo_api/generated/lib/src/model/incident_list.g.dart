// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IncidentListCWProxy {
  IncidentList data(List<Incident> data);

  IncidentList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncidentList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncidentList(...).copyWith(id: 12, name: "My name")
  /// ````
  IncidentList call({List<Incident> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIncidentList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIncidentList.copyWith.fieldName(...)`
class _$IncidentListCWProxyImpl implements _$IncidentListCWProxy {
  const _$IncidentListCWProxyImpl(this._value);

  final IncidentList _value;

  @override
  IncidentList data(List<Incident> data) => this(data: data);

  @override
  IncidentList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncidentList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncidentList(...).copyWith(id: 12, name: "My name")
  /// ````
  IncidentList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return IncidentList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Incident>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $IncidentListCopyWith on IncidentList {
  /// Returns a callable class that can be used as follows: `instanceOfIncidentList.copyWith(...)` or like so:`instanceOfIncidentList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IncidentListCWProxy get copyWith => _$IncidentListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentList _$IncidentListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IncidentList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = IncidentList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Incident.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$IncidentListToJson(IncidentList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
