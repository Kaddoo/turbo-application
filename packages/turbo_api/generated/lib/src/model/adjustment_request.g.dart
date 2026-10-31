// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdjustmentRequestCWProxy {
  AdjustmentRequest id(String id);

  AdjustmentRequest studentId(String studentId);

  AdjustmentRequest amountPesewas(int amountPesewas);

  AdjustmentRequest reasonCode(AdjustmentRequestReasonCodeEnum reasonCode);

  AdjustmentRequest note(String? note);

  AdjustmentRequest status(AdjustmentRequestStatusEnum status);

  AdjustmentRequest requestedBy(String requestedBy);

  AdjustmentRequest decidedBy(String? decidedBy);

  AdjustmentRequest createdAt(DateTime createdAt);

  AdjustmentRequest decidedAt(DateTime? decidedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentRequest call({
    String id,
    String studentId,
    int amountPesewas,
    AdjustmentRequestReasonCodeEnum reasonCode,
    String? note,
    AdjustmentRequestStatusEnum status,
    String requestedBy,
    String? decidedBy,
    DateTime createdAt,
    DateTime? decidedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdjustmentRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdjustmentRequest.copyWith.fieldName(...)`
class _$AdjustmentRequestCWProxyImpl implements _$AdjustmentRequestCWProxy {
  const _$AdjustmentRequestCWProxyImpl(this._value);

  final AdjustmentRequest _value;

  @override
  AdjustmentRequest id(String id) => this(id: id);

  @override
  AdjustmentRequest studentId(String studentId) => this(studentId: studentId);

  @override
  AdjustmentRequest amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  AdjustmentRequest reasonCode(AdjustmentRequestReasonCodeEnum reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  AdjustmentRequest note(String? note) => this(note: note);

  @override
  AdjustmentRequest status(AdjustmentRequestStatusEnum status) =>
      this(status: status);

  @override
  AdjustmentRequest requestedBy(String requestedBy) =>
      this(requestedBy: requestedBy);

  @override
  AdjustmentRequest decidedBy(String? decidedBy) => this(decidedBy: decidedBy);

  @override
  AdjustmentRequest createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdjustmentRequest decidedAt(DateTime? decidedAt) =>
      this(decidedAt: decidedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentRequest call({
    Object? id = const $CopyWithPlaceholder(),
    Object? studentId = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? requestedBy = const $CopyWithPlaceholder(),
    Object? decidedBy = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? decidedAt = const $CopyWithPlaceholder(),
  }) {
    return AdjustmentRequest(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      studentId: studentId == const $CopyWithPlaceholder()
          ? _value.studentId
          // ignore: cast_nullable_to_non_nullable
          : studentId as String,
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as AdjustmentRequestReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AdjustmentRequestStatusEnum,
      requestedBy: requestedBy == const $CopyWithPlaceholder()
          ? _value.requestedBy
          // ignore: cast_nullable_to_non_nullable
          : requestedBy as String,
      decidedBy: decidedBy == const $CopyWithPlaceholder()
          ? _value.decidedBy
          // ignore: cast_nullable_to_non_nullable
          : decidedBy as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      decidedAt: decidedAt == const $CopyWithPlaceholder()
          ? _value.decidedAt
          // ignore: cast_nullable_to_non_nullable
          : decidedAt as DateTime?,
    );
  }
}

extension $AdjustmentRequestCopyWith on AdjustmentRequest {
  /// Returns a callable class that can be used as follows: `instanceOfAdjustmentRequest.copyWith(...)` or like so:`instanceOfAdjustmentRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdjustmentRequestCWProxy get copyWith =>
      _$AdjustmentRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentRequest _$AdjustmentRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdjustmentRequest', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'studentId',
      'amountPesewas',
      'reasonCode',
      'status',
      'requestedBy',
      'createdAt',
    ],
  );
  final val = AdjustmentRequest(
    id: $checkedConvert('id', (v) => v as String),
    studentId: $checkedConvert('studentId', (v) => v as String),
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    reasonCode: $checkedConvert(
      'reasonCode',
      (v) => $enumDecode(_$AdjustmentRequestReasonCodeEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String?),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$AdjustmentRequestStatusEnumEnumMap, v),
    ),
    requestedBy: $checkedConvert('requestedBy', (v) => v as String),
    decidedBy: $checkedConvert('decidedBy', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    decidedAt: $checkedConvert(
      'decidedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$AdjustmentRequestToJson(
  AdjustmentRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'amountPesewas': instance.amountPesewas,
  'reasonCode': _$AdjustmentRequestReasonCodeEnumEnumMap[instance.reasonCode]!,
  'note': ?instance.note,
  'status': _$AdjustmentRequestStatusEnumEnumMap[instance.status]!,
  'requestedBy': instance.requestedBy,
  'decidedBy': ?instance.decidedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'decidedAt': ?instance.decidedAt?.toIso8601String(),
};

const _$AdjustmentRequestReasonCodeEnumEnumMap = {
  AdjustmentRequestReasonCodeEnum.goodwill: 'goodwill',
  AdjustmentRequestReasonCodeEnum.duplicateCharge: 'duplicate_charge',
  AdjustmentRequestReasonCodeEnum.providerReconciliation:
      'provider_reconciliation',
  AdjustmentRequestReasonCodeEnum.correction: 'correction',
  AdjustmentRequestReasonCodeEnum.other: 'other',
};

const _$AdjustmentRequestStatusEnumEnumMap = {
  AdjustmentRequestStatusEnum.pending: 'pending',
  AdjustmentRequestStatusEnum.approved: 'approved',
  AdjustmentRequestStatusEnum.rejected: 'rejected',
};
