// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportTicketCreateCWProxy {
  SupportTicketCreate category(SupportTicketCreateCategoryEnum category);

  SupportTicketCreate rideId(String? rideId);

  SupportTicketCreate subject(String subject);

  SupportTicketCreate message(String message);

  SupportTicketCreate uploadIds(List<String>? uploadIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicketCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicketCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicketCreate call({
    SupportTicketCreateCategoryEnum category,
    String? rideId,
    String subject,
    String message,
    List<String>? uploadIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportTicketCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportTicketCreate.copyWith.fieldName(...)`
class _$SupportTicketCreateCWProxyImpl implements _$SupportTicketCreateCWProxy {
  const _$SupportTicketCreateCWProxyImpl(this._value);

  final SupportTicketCreate _value;

  @override
  SupportTicketCreate category(SupportTicketCreateCategoryEnum category) =>
      this(category: category);

  @override
  SupportTicketCreate rideId(String? rideId) => this(rideId: rideId);

  @override
  SupportTicketCreate subject(String subject) => this(subject: subject);

  @override
  SupportTicketCreate message(String message) => this(message: message);

  @override
  SupportTicketCreate uploadIds(List<String>? uploadIds) =>
      this(uploadIds: uploadIds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportTicketCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportTicketCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportTicketCreate call({
    Object? category = const $CopyWithPlaceholder(),
    Object? rideId = const $CopyWithPlaceholder(),
    Object? subject = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? uploadIds = const $CopyWithPlaceholder(),
  }) {
    return SupportTicketCreate(
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as SupportTicketCreateCategoryEnum,
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String?,
      subject: subject == const $CopyWithPlaceholder()
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      uploadIds: uploadIds == const $CopyWithPlaceholder()
          ? _value.uploadIds
          // ignore: cast_nullable_to_non_nullable
          : uploadIds as List<String>?,
    );
  }
}

extension $SupportTicketCreateCopyWith on SupportTicketCreate {
  /// Returns a callable class that can be used as follows: `instanceOfSupportTicketCreate.copyWith(...)` or like so:`instanceOfSupportTicketCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportTicketCreateCWProxy get copyWith =>
      _$SupportTicketCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicketCreate _$SupportTicketCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SupportTicketCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['category', 'subject', 'message']);
      final val = SupportTicketCreate(
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$SupportTicketCreateCategoryEnumEnumMap, v),
        ),
        rideId: $checkedConvert('rideId', (v) => v as String?),
        subject: $checkedConvert('subject', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        uploadIds: $checkedConvert(
          'uploadIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SupportTicketCreateToJson(
  SupportTicketCreate instance,
) => <String, dynamic>{
  'category': _$SupportTicketCreateCategoryEnumEnumMap[instance.category]!,
  'rideId': ?instance.rideId,
  'subject': instance.subject,
  'message': instance.message,
  'uploadIds': ?instance.uploadIds,
};

const _$SupportTicketCreateCategoryEnumEnumMap = {
  SupportTicketCreateCategoryEnum.safety: 'safety',
  SupportTicketCreateCategoryEnum.driverConduct: 'driver_conduct',
  SupportTicketCreateCategoryEnum.vehicle: 'vehicle',
  SupportTicketCreateCategoryEnum.wrongCharge: 'wrong_charge',
  SupportTicketCreateCategoryEnum.paymentProblem: 'payment_problem',
  SupportTicketCreateCategoryEnum.lostItem: 'lost_item',
  SupportTicketCreateCategoryEnum.account: 'account',
  SupportTicketCreateCategoryEnum.other: 'other',
  SupportTicketCreateCategoryEnum.phoneChange: 'phone_change',
  SupportTicketCreateCategoryEnum.dataRequest: 'data_request',
};
