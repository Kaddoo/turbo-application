// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUserListCWProxy {
  StaffUserList data(List<StaffUser> data);

  StaffUserList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserList(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserList call({List<StaffUser> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUserList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUserList.copyWith.fieldName(...)`
class _$StaffUserListCWProxyImpl implements _$StaffUserListCWProxy {
  const _$StaffUserListCWProxyImpl(this._value);

  final StaffUserList _value;

  @override
  StaffUserList data(List<StaffUser> data) => this(data: data);

  @override
  StaffUserList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserList(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return StaffUserList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<StaffUser>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $StaffUserListCopyWith on StaffUserList {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUserList.copyWith(...)` or like so:`instanceOfStaffUserList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUserListCWProxy get copyWith => _$StaffUserListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserList _$StaffUserListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUserList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = StaffUserList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => StaffUser.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserListToJson(StaffUserList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
