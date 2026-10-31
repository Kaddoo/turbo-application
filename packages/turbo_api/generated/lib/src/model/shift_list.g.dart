// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShiftListCWProxy {
  ShiftList data(List<Shift> data);

  ShiftList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShiftList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShiftList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShiftList call({List<Shift> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShiftList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShiftList.copyWith.fieldName(...)`
class _$ShiftListCWProxyImpl implements _$ShiftListCWProxy {
  const _$ShiftListCWProxyImpl(this._value);

  final ShiftList _value;

  @override
  ShiftList data(List<Shift> data) => this(data: data);

  @override
  ShiftList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShiftList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShiftList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShiftList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return ShiftList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Shift>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $ShiftListCopyWith on ShiftList {
  /// Returns a callable class that can be used as follows: `instanceOfShiftList.copyWith(...)` or like so:`instanceOfShiftList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShiftListCWProxy get copyWith => _$ShiftListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftList _$ShiftListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ShiftList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = ShiftList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Shift.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ShiftListToJson(ShiftList instance) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
