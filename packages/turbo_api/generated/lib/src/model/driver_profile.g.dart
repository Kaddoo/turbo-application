// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverProfileCWProxy {
  DriverProfile id(String id);

  DriverProfile fullName(String fullName);

  DriverProfile phone(String phone);

  DriverProfile photoUrl(String? photoUrl);

  DriverProfile status(AccountStatus status);

  DriverProfile dutyStatus(DriverProfileDutyStatusEnum dutyStatus);

  DriverProfile vehicle(Vehicle? vehicle);

  DriverProfile currentRideId(String? currentRideId);

  DriverProfile documents(List<DriverDocumentStatus>? documents);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverProfile call({
    String id,
    String fullName,
    String phone,
    String? photoUrl,
    AccountStatus status,
    DriverProfileDutyStatusEnum dutyStatus,
    Vehicle? vehicle,
    String? currentRideId,
    List<DriverDocumentStatus>? documents,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverProfile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverProfile.copyWith.fieldName(...)`
class _$DriverProfileCWProxyImpl implements _$DriverProfileCWProxy {
  const _$DriverProfileCWProxyImpl(this._value);

  final DriverProfile _value;

  @override
  DriverProfile id(String id) => this(id: id);

  @override
  DriverProfile fullName(String fullName) => this(fullName: fullName);

  @override
  DriverProfile phone(String phone) => this(phone: phone);

  @override
  DriverProfile photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  DriverProfile status(AccountStatus status) => this(status: status);

  @override
  DriverProfile dutyStatus(DriverProfileDutyStatusEnum dutyStatus) =>
      this(dutyStatus: dutyStatus);

  @override
  DriverProfile vehicle(Vehicle? vehicle) => this(vehicle: vehicle);

  @override
  DriverProfile currentRideId(String? currentRideId) =>
      this(currentRideId: currentRideId);

  @override
  DriverProfile documents(List<DriverDocumentStatus>? documents) =>
      this(documents: documents);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverProfile call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? dutyStatus = const $CopyWithPlaceholder(),
    Object? vehicle = const $CopyWithPlaceholder(),
    Object? currentRideId = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
  }) {
    return DriverProfile(
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
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AccountStatus,
      dutyStatus: dutyStatus == const $CopyWithPlaceholder()
          ? _value.dutyStatus
          // ignore: cast_nullable_to_non_nullable
          : dutyStatus as DriverProfileDutyStatusEnum,
      vehicle: vehicle == const $CopyWithPlaceholder()
          ? _value.vehicle
          // ignore: cast_nullable_to_non_nullable
          : vehicle as Vehicle?,
      currentRideId: currentRideId == const $CopyWithPlaceholder()
          ? _value.currentRideId
          // ignore: cast_nullable_to_non_nullable
          : currentRideId as String?,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<DriverDocumentStatus>?,
    );
  }
}

extension $DriverProfileCopyWith on DriverProfile {
  /// Returns a callable class that can be used as follows: `instanceOfDriverProfile.copyWith(...)` or like so:`instanceOfDriverProfile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverProfileCWProxy get copyWith => _$DriverProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverProfile', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'fullName', 'phone', 'status', 'dutyStatus'],
      );
      final val = DriverProfile(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$AccountStatusEnumMap, v),
        ),
        dutyStatus: $checkedConvert(
          'dutyStatus',
          (v) => $enumDecode(_$DriverProfileDutyStatusEnumEnumMap, v),
        ),
        vehicle: $checkedConvert(
          'vehicle',
          (v) => v == null ? null : Vehicle.fromJson(v as Map<String, dynamic>),
        ),
        currentRideId: $checkedConvert('currentRideId', (v) => v as String?),
        documents: $checkedConvert(
          'documents',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => DriverDocumentStatus.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DriverProfileToJson(DriverProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'photoUrl': ?instance.photoUrl,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'dutyStatus': _$DriverProfileDutyStatusEnumEnumMap[instance.dutyStatus]!,
      'vehicle': ?instance.vehicle?.toJson(),
      'currentRideId': ?instance.currentRideId,
      'documents': ?instance.documents?.map((e) => e.toJson()).toList(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
};

const _$DriverProfileDutyStatusEnumEnumMap = {
  DriverProfileDutyStatusEnum.offDuty: 'off_duty',
  DriverProfileDutyStatusEnum.onDuty: 'on_duty',
};
