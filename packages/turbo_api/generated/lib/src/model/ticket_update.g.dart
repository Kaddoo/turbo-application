// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TicketUpdateCWProxy {
  TicketUpdate status(TicketUpdateStatusEnum? status);

  TicketUpdate assignedToStaffId(String? assignedToStaffId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketUpdate call({
    TicketUpdateStatusEnum? status,
    String? assignedToStaffId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTicketUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTicketUpdate.copyWith.fieldName(...)`
class _$TicketUpdateCWProxyImpl implements _$TicketUpdateCWProxy {
  const _$TicketUpdateCWProxyImpl(this._value);

  final TicketUpdate _value;

  @override
  TicketUpdate status(TicketUpdateStatusEnum? status) => this(status: status);

  @override
  TicketUpdate assignedToStaffId(String? assignedToStaffId) =>
      this(assignedToStaffId: assignedToStaffId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketUpdate call({
    Object? status = const $CopyWithPlaceholder(),
    Object? assignedToStaffId = const $CopyWithPlaceholder(),
  }) {
    return TicketUpdate(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as TicketUpdateStatusEnum?,
      assignedToStaffId: assignedToStaffId == const $CopyWithPlaceholder()
          ? _value.assignedToStaffId
          // ignore: cast_nullable_to_non_nullable
          : assignedToStaffId as String?,
    );
  }
}

extension $TicketUpdateCopyWith on TicketUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfTicketUpdate.copyWith(...)` or like so:`instanceOfTicketUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TicketUpdateCWProxy get copyWith => _$TicketUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketUpdate _$TicketUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicketUpdate', json, ($checkedConvert) {
      final val = TicketUpdate(
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$TicketUpdateStatusEnumEnumMap, v),
        ),
        assignedToStaffId: $checkedConvert(
          'assignedToStaffId',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$TicketUpdateToJson(TicketUpdate instance) =>
    <String, dynamic>{
      'status': ?_$TicketUpdateStatusEnumEnumMap[instance.status],
      'assignedToStaffId': ?instance.assignedToStaffId,
    };

const _$TicketUpdateStatusEnumEnumMap = {
  TicketUpdateStatusEnum.open: 'open',
  TicketUpdateStatusEnum.inProgress: 'in_progress',
  TicketUpdateStatusEnum.waitingOnUser: 'waiting_on_user',
  TicketUpdateStatusEnum.resolved: 'resolved',
  TicketUpdateStatusEnum.closed: 'closed',
};
