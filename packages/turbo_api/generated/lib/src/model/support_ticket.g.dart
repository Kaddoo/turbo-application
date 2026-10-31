// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportTicketCWProxy {
  SupportTicket id(String id);

  SupportTicket category(String category);

  SupportTicket status(SupportTicketStatusEnum status);

  SupportTicket subject(String subject);

  SupportTicket rideId(String? rideId);

  SupportTicket assignedToStaffId(String? assignedToStaffId);

  SupportTicket createdAt(DateTime createdAt);

  SupportTicket updatedAt(DateTime updatedAt);

  SupportTicket messages(List<SupportMessage>? messages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicket(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicket(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicket call({
    String id,
    String category,
    SupportTicketStatusEnum status,
    String subject,
    String? rideId,
    String? assignedToStaffId,
    DateTime createdAt,
    DateTime updatedAt,
    List<SupportMessage>? messages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportTicket.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportTicket.copyWith.fieldName(...)`
class _$SupportTicketCWProxyImpl implements _$SupportTicketCWProxy {
  const _$SupportTicketCWProxyImpl(this._value);

  final SupportTicket _value;

  @override
  SupportTicket id(String id) => this(id: id);

  @override
  SupportTicket category(String category) => this(category: category);

  @override
  SupportTicket status(SupportTicketStatusEnum status) => this(status: status);

  @override
  SupportTicket subject(String subject) => this(subject: subject);

  @override
  SupportTicket rideId(String? rideId) => this(rideId: rideId);

  @override
  SupportTicket assignedToStaffId(String? assignedToStaffId) =>
      this(assignedToStaffId: assignedToStaffId);

  @override
  SupportTicket createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  SupportTicket updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  SupportTicket messages(List<SupportMessage>? messages) =>
      this(messages: messages);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicket(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicket(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicket call({
    Object? id = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? subject = const $CopyWithPlaceholder(),
    Object? rideId = const $CopyWithPlaceholder(),
    Object? assignedToStaffId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
  }) {
    return SupportTicket(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SupportTicketStatusEnum,
      subject: subject == const $CopyWithPlaceholder()
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String,
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String?,
      assignedToStaffId: assignedToStaffId == const $CopyWithPlaceholder()
          ? _value.assignedToStaffId
          // ignore: cast_nullable_to_non_nullable
          : assignedToStaffId as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      messages: messages == const $CopyWithPlaceholder()
          ? _value.messages
          // ignore: cast_nullable_to_non_nullable
          : messages as List<SupportMessage>?,
    );
  }
}

extension $SupportTicketCopyWith on SupportTicket {
  /// Returns a callable class that can be used as follows: `instanceOfSupportTicket.copyWith(...)` or like so:`instanceOfSupportTicket.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportTicketCWProxy get copyWith => _$SupportTicketCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicket _$SupportTicketFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SupportTicket', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'category',
      'status',
      'subject',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = SupportTicket(
    id: $checkedConvert('id', (v) => v as String),
    category: $checkedConvert('category', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$SupportTicketStatusEnumEnumMap, v),
    ),
    subject: $checkedConvert('subject', (v) => v as String),
    rideId: $checkedConvert('rideId', (v) => v as String?),
    assignedToStaffId: $checkedConvert(
      'assignedToStaffId',
      (v) => v as String?,
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    messages: $checkedConvert(
      'messages',
      (v) => (v as List<dynamic>?)
          ?.map((e) => SupportMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$SupportTicketToJson(SupportTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'status': _$SupportTicketStatusEnumEnumMap[instance.status]!,
      'subject': instance.subject,
      'rideId': ?instance.rideId,
      'assignedToStaffId': ?instance.assignedToStaffId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'messages': ?instance.messages?.map((e) => e.toJson()).toList(),
    };

const _$SupportTicketStatusEnumEnumMap = {
  SupportTicketStatusEnum.open: 'open',
  SupportTicketStatusEnum.inProgress: 'in_progress',
  SupportTicketStatusEnum.waitingOnUser: 'waiting_on_user',
  SupportTicketStatusEnum.resolved: 'resolved',
  SupportTicketStatusEnum.closed: 'closed',
};
