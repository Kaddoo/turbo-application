// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AttendanceRecordListCWProxy {
  AttendanceRecordList data(List<AttendanceRecord> data);

  AttendanceRecordList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceRecordList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceRecordList(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceRecordList call({List<AttendanceRecord> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAttendanceRecordList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAttendanceRecordList.copyWith.fieldName(...)`
class _$AttendanceRecordListCWProxyImpl
    implements _$AttendanceRecordListCWProxy {
  const _$AttendanceRecordListCWProxyImpl(this._value);

  final AttendanceRecordList _value;

  @override
  AttendanceRecordList data(List<AttendanceRecord> data) => this(data: data);

  @override
  AttendanceRecordList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceRecordList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceRecordList(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceRecordList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return AttendanceRecordList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<AttendanceRecord>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $AttendanceRecordListCopyWith on AttendanceRecordList {
  /// Returns a callable class that can be used as follows: `instanceOfAttendanceRecordList.copyWith(...)` or like so:`instanceOfAttendanceRecordList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AttendanceRecordListCWProxy get copyWith =>
      _$AttendanceRecordListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordList _$AttendanceRecordListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AttendanceRecordList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data', 'page']);
  final val = AttendanceRecordList(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AttendanceRecordListToJson(
  AttendanceRecordList instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
