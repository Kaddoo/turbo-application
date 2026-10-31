// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDetailCWProxy {
  DriverDetail id(String id);

  DriverDetail fullName(String fullName);

  DriverDetail phone(String phone);

  DriverDetail email(String? email);

  DriverDetail status(AccountStatus status);

  DriverDetail dutyStatus(DriverDetailDutyStatusEnum dutyStatus);

  DriverDetail vehicle(Vehicle? vehicle);

  DriverDetail currentRideId(String? currentRideId);

  DriverDetail lastLocation(DriverLocation? lastLocation);

  DriverDetail documents(List<DriverDocument>? documents);

  DriverDetail createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDetail call({
    String id,
    String fullName,
    String phone,
    String? email,
    AccountStatus status,
    DriverDetailDutyStatusEnum dutyStatus,
    Vehicle? vehicle,
    String? currentRideId,
    DriverLocation? lastLocation,
    List<DriverDocument>? documents,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDetail.copyWith.fieldName(...)`
class _$DriverDetailCWProxyImpl implements _$DriverDetailCWProxy {
  const _$DriverDetailCWProxyImpl(this._value);

  final DriverDetail _value;

  @override
  DriverDetail id(String id) => this(id: id);

  @override
  DriverDetail fullName(String fullName) => this(fullName: fullName);

  @override
  DriverDetail phone(String phone) => this(phone: phone);

  @override
  DriverDetail email(String? email) => this(email: email);

  @override
  DriverDetail status(AccountStatus status) => this(status: status);

  @override
  DriverDetail dutyStatus(DriverDetailDutyStatusEnum dutyStatus) =>
      this(dutyStatus: dutyStatus);

  @override
  DriverDetail vehicle(Vehicle? vehicle) => this(vehicle: vehicle);

  @override
  DriverDetail currentRideId(String? currentRideId) =>
      this(currentRideId: currentRideId);

  @override
  DriverDetail lastLocation(DriverLocation? lastLocation) =>
      this(lastLocation: lastLocation);

  @override
  DriverDetail documents(List<DriverDocument>? documents) =>
      this(documents: documents);

  @override
  DriverDetail createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDetail call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? dutyStatus = const $CopyWithPlaceholder(),
    Object? vehicle = const $CopyWithPlaceholder(),
    Object? currentRideId = const $CopyWithPlaceholder(),
    Object? lastLocation = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return DriverDetail(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AccountStatus,
      dutyStatus: dutyStatus == const $CopyWithPlaceholder()
          ? _value.dutyStatus
          // ignore: cast_nullable_to_non_nullable
          : dutyStatus as DriverDetailDutyStatusEnum,
      vehicle: vehicle == const $CopyWithPlaceholder()
          ? _value.vehicle
          // ignore: cast_nullable_to_non_nullable
          : vehicle as Vehicle?,
      currentRideId: currentRideId == const $CopyWithPlaceholder()
          ? _value.currentRideId
          // ignore: cast_nullable_to_non_nullable
          : currentRideId as String?,
      lastLocation: lastLocation == const $CopyWithPlaceholder()
          ? _value.lastLocation
          // ignore: cast_nullable_to_non_nullable
          : lastLocation as DriverLocation?,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<DriverDocument>?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $DriverDetailCopyWith on DriverDetail {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDetail.copyWith(...)` or like so:`instanceOfDriverDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDetailCWProxy get copyWith => _$DriverDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDetail _$DriverDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DriverDetail', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'fullName',
      'phone',
      'status',
      'dutyStatus',
      'createdAt',
    ],
  );
  final val = DriverDetail(
    id: $checkedConvert('id', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    email: $checkedConvert('email', (v) => v as String?),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$AccountStatusEnumMap, v),
    ),
    dutyStatus: $checkedConvert(
      'dutyStatus',
      (v) => $enumDecode(_$DriverDetailDutyStatusEnumEnumMap, v),
    ),
    vehicle: $checkedConvert(
      'vehicle',
      (v) => v == null ? null : Vehicle.fromJson(v as Map<String, dynamic>),
    ),
    currentRideId: $checkedConvert('currentRideId', (v) => v as String?),
    lastLocation: $checkedConvert(
      'lastLocation',
      (v) =>
          v == null ? null : DriverLocation.fromJson(v as Map<String, dynamic>),
    ),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>?)
          ?.map((e) => DriverDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$DriverDetailToJson(DriverDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': ?instance.email,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'dutyStatus': _$DriverDetailDutyStatusEnumEnumMap[instance.dutyStatus]!,
      'vehicle': ?instance.vehicle?.toJson(),
      'currentRideId': ?instance.currentRideId,
      'lastLocation': ?instance.lastLocation?.toJson(),
      'documents': ?instance.documents?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
};

const _$DriverDetailDutyStatusEnumEnumMap = {
  DriverDetailDutyStatusEnum.offDuty: 'off_duty',
  DriverDetailDutyStatusEnum.onDuty: 'on_duty',
};
