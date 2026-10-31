// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IncidentCWProxy {
  Incident id(String id);

  Incident type(IncidentTypeEnum type);

  Incident status(IncidentStatusEnum status);

  Incident rideId(String? rideId);

  Incident location(GeoPoint? location);

  Incident note(String? note);

  Incident createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Incident(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Incident(...).copyWith(id: 12, name: "My name")
  /// ````
  Incident call({
    String id,
    IncidentTypeEnum type,
    IncidentStatusEnum status,
    String? rideId,
    GeoPoint? location,
    String? note,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIncident.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIncident.copyWith.fieldName(...)`
class _$IncidentCWProxyImpl implements _$IncidentCWProxy {
  const _$IncidentCWProxyImpl(this._value);

  final Incident _value;

  @override
  Incident id(String id) => this(id: id);

  @override
  Incident type(IncidentTypeEnum type) => this(type: type);

  @override
  Incident status(IncidentStatusEnum status) => this(status: status);

  @override
  Incident rideId(String? rideId) => this(rideId: rideId);

  @override
  Incident location(GeoPoint? location) => this(location: location);

  @override
  Incident note(String? note) => this(note: note);

  @override
  Incident createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Incident(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Incident(...).copyWith(id: 12, name: "My name")
  /// ````
  Incident call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? rideId = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return Incident(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as IncidentTypeEnum,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as IncidentStatusEnum,
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String?,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as GeoPoint?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $IncidentCopyWith on Incident {
  /// Returns a callable class that can be used as follows: `instanceOfIncident.copyWith(...)` or like so:`instanceOfIncident.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IncidentCWProxy get copyWith => _$IncidentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incident _$IncidentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Incident', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'type', 'status', 'createdAt']);
  final val = Incident(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$IncidentTypeEnumEnumMap, v),
    ),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$IncidentStatusEnumEnumMap, v),
    ),
    rideId: $checkedConvert('rideId', (v) => v as String?),
    location: $checkedConvert(
      'location',
      (v) => v == null ? null : GeoPoint.fromJson(v as Map<String, dynamic>),
    ),
    note: $checkedConvert('note', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$IncidentTypeEnumEnumMap[instance.type]!,
  'status': _$IncidentStatusEnumEnumMap[instance.status]!,
  'rideId': ?instance.rideId,
  'location': ?instance.location?.toJson(),
  'note': ?instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$IncidentTypeEnumEnumMap = {
  IncidentTypeEnum.sos: 'sos',
  IncidentTypeEnum.safetyReport: 'safety_report',
};

const _$IncidentStatusEnumEnumMap = {
  IncidentStatusEnum.open: 'open',
  IncidentStatusEnum.acknowledged: 'acknowledged',
  IncidentStatusEnum.resolved: 'resolved',
};
