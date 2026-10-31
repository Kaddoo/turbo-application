// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancellationCWProxy {
  Cancellation by(CancellationByEnum by);

  Cancellation reasonCode(CancellationReasonCodeEnum reasonCode);

  Cancellation note(String? note);

  Cancellation cancelledAt(DateTime cancelledAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cancellation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cancellation(...).copyWith(id: 12, name: "My name")
  /// ````
  Cancellation call({
    CancellationByEnum by,
    CancellationReasonCodeEnum reasonCode,
    String? note,
    DateTime cancelledAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancellation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancellation.copyWith.fieldName(...)`
class _$CancellationCWProxyImpl implements _$CancellationCWProxy {
  const _$CancellationCWProxyImpl(this._value);

  final Cancellation _value;

  @override
  Cancellation by(CancellationByEnum by) => this(by: by);

  @override
  Cancellation reasonCode(CancellationReasonCodeEnum reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  Cancellation note(String? note) => this(note: note);

  @override
  Cancellation cancelledAt(DateTime cancelledAt) =>
      this(cancelledAt: cancelledAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cancellation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cancellation(...).copyWith(id: 12, name: "My name")
  /// ````
  Cancellation call({
    Object? by = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? cancelledAt = const $CopyWithPlaceholder(),
  }) {
    return Cancellation(
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as CancellationByEnum,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as CancellationReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      cancelledAt: cancelledAt == const $CopyWithPlaceholder()
          ? _value.cancelledAt
          // ignore: cast_nullable_to_non_nullable
          : cancelledAt as DateTime,
    );
  }
}

extension $CancellationCopyWith on Cancellation {
  /// Returns a callable class that can be used as follows: `instanceOfCancellation.copyWith(...)` or like so:`instanceOfCancellation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancellationCWProxy get copyWith => _$CancellationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cancellation _$CancellationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Cancellation', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['by', 'reasonCode', 'cancelledAt']);
      final val = Cancellation(
        by: $checkedConvert(
          'by',
          (v) => $enumDecode(_$CancellationByEnumEnumMap, v),
        ),
        reasonCode: $checkedConvert(
          'reasonCode',
          (v) => $enumDecode(_$CancellationReasonCodeEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
        cancelledAt: $checkedConvert(
          'cancelledAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CancellationToJson(Cancellation instance) =>
    <String, dynamic>{
      'by': _$CancellationByEnumEnumMap[instance.by]!,
      'reasonCode': _$CancellationReasonCodeEnumEnumMap[instance.reasonCode]!,
      'note': ?instance.note,
      'cancelledAt': instance.cancelledAt.toIso8601String(),
    };

const _$CancellationByEnumEnumMap = {
  CancellationByEnum.student: 'student',
  CancellationByEnum.driver: 'driver',
  CancellationByEnum.system: 'system',
  CancellationByEnum.admin: 'admin',
};

const _$CancellationReasonCodeEnumEnumMap = {
  CancellationReasonCodeEnum.studentChangedMind: 'student_changed_mind',
  CancellationReasonCodeEnum.driverUnavailable: 'driver_unavailable',
  CancellationReasonCodeEnum.vehicleIssue: 'vehicle_issue',
  CancellationReasonCodeEnum.noDriverAvailable: 'no_driver_available',
  CancellationReasonCodeEnum.serviceIssue: 'service_issue',
  CancellationReasonCodeEnum.adminDecision: 'admin_decision',
  CancellationReasonCodeEnum.other: 'other',
  CancellationReasonCodeEnum.riderNoShow: 'rider_no_show',
};
