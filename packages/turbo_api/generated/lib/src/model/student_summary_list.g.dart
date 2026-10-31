// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_summary_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StudentSummaryListCWProxy {
  StudentSummaryList data(List<StudentSummary> data);

  StudentSummaryList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentSummaryList call({List<StudentSummary> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudentSummaryList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudentSummaryList.copyWith.fieldName(...)`
class _$StudentSummaryListCWProxyImpl implements _$StudentSummaryListCWProxy {
  const _$StudentSummaryListCWProxyImpl(this._value);

  final StudentSummaryList _value;

  @override
  StudentSummaryList data(List<StudentSummary> data) => this(data: data);

  @override
  StudentSummaryList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentSummaryList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return StudentSummaryList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<StudentSummary>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $StudentSummaryListCopyWith on StudentSummaryList {
  /// Returns a callable class that can be used as follows: `instanceOfStudentSummaryList.copyWith(...)` or like so:`instanceOfStudentSummaryList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudentSummaryListCWProxy get copyWith =>
      _$StudentSummaryListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSummaryList _$StudentSummaryListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StudentSummaryList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = StudentSummaryList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => StudentSummary.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StudentSummaryListToJson(StudentSummaryList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
