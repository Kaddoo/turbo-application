// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RefundRequestCWProxy {
  RefundRequest amountPesewas(int? amountPesewas);

  RefundRequest reasonCode(RefundRequestReasonCodeEnum reasonCode);

  RefundRequest note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefundRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefundRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RefundRequest call({
    int? amountPesewas,
    RefundRequestReasonCodeEnum reasonCode,
    String note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRefundRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRefundRequest.copyWith.fieldName(...)`
class _$RefundRequestCWProxyImpl implements _$RefundRequestCWProxy {
  const _$RefundRequestCWProxyImpl(this._value);

  final RefundRequest _value;

  @override
  RefundRequest amountPesewas(int? amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  RefundRequest reasonCode(RefundRequestReasonCodeEnum reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  RefundRequest note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefundRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefundRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RefundRequest call({
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return RefundRequest(
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int?,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as RefundRequestReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $RefundRequestCopyWith on RefundRequest {
  /// Returns a callable class that can be used as follows: `instanceOfRefundRequest.copyWith(...)` or like so:`instanceOfRefundRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RefundRequestCWProxy get copyWith => _$RefundRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RefundRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reasonCode', 'note']);
      final val = RefundRequest(
        amountPesewas: $checkedConvert(
          'amountPesewas',
          (v) => (v as num?)?.toInt(),
        ),
        reasonCode: $checkedConvert(
          'reasonCode',
          (v) => $enumDecode(_$RefundRequestReasonCodeEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RefundRequestToJson(RefundRequest instance) =>
    <String, dynamic>{
      'amountPesewas': ?instance.amountPesewas,
      'reasonCode': _$RefundRequestReasonCodeEnumEnumMap[instance.reasonCode]!,
      'note': instance.note,
    };

const _$RefundRequestReasonCodeEnumEnumMap = {
  RefundRequestReasonCodeEnum.driverCancelled: 'driver_cancelled',
  RefundRequestReasonCodeEnum.serviceIssue: 'service_issue',
  RefundRequestReasonCodeEnum.breakdown: 'breakdown',
  RefundRequestReasonCodeEnum.partialTrip: 'partial_trip',
  RefundRequestReasonCodeEnum.wrongCharge: 'wrong_charge',
  RefundRequestReasonCodeEnum.other: 'other',
};
