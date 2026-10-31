// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportTicketListCWProxy {
  SupportTicketList data(List<SupportTicket> data);

  SupportTicketList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicketList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicketList(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicketList call({List<SupportTicket> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportTicketList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportTicketList.copyWith.fieldName(...)`
class _$SupportTicketListCWProxyImpl implements _$SupportTicketListCWProxy {
  const _$SupportTicketListCWProxyImpl(this._value);

  final SupportTicketList _value;

  @override
  SupportTicketList data(List<SupportTicket> data) => this(data: data);

  @override
  SupportTicketList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicketList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicketList(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicketList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return SupportTicketList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<SupportTicket>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $SupportTicketListCopyWith on SupportTicketList {
  /// Returns a callable class that can be used as follows: `instanceOfSupportTicketList.copyWith(...)` or like so:`instanceOfSupportTicketList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportTicketListCWProxy get copyWith =>
      _$SupportTicketListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicketList _$SupportTicketListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SupportTicketList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = SupportTicketList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SupportTicketListToJson(SupportTicketList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
