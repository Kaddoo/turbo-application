// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IncidentUpdateCWProxy {
  IncidentUpdate status(IncidentUpdateStatusEnum status);

  IncidentUpdate note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncidentUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncidentUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  IncidentUpdate call({IncidentUpdateStatusEnum status, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIncidentUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIncidentUpdate.copyWith.fieldName(...)`
class _$IncidentUpdateCWProxyImpl implements _$IncidentUpdateCWProxy {
  const _$IncidentUpdateCWProxyImpl(this._value);

  final IncidentUpdate _value;

  @override
  IncidentUpdate status(IncidentUpdateStatusEnum status) =>
      this(status: status);

  @override
  IncidentUpdate note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncidentUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncidentUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  IncidentUpdate call({
    Object? status = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return IncidentUpdate(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as IncidentUpdateStatusEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $IncidentUpdateCopyWith on IncidentUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfIncidentUpdate.copyWith(...)` or like so:`instanceOfIncidentUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IncidentUpdateCWProxy get copyWith => _$IncidentUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentUpdate _$IncidentUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IncidentUpdate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status']);
      final val = IncidentUpdate(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$IncidentUpdateStatusEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$IncidentUpdateToJson(IncidentUpdate instance) =>
    <String, dynamic>{
      'status': _$IncidentUpdateStatusEnumEnumMap[instance.status]!,
      'note': ?instance.note,
    };

const _$IncidentUpdateStatusEnumEnumMap = {
  IncidentUpdateStatusEnum.acknowledged: 'acknowledged',
  IncidentUpdateStatusEnum.resolved: 'resolved',
};
