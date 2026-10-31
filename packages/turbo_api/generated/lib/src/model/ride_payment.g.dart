// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_payment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RidePaymentCWProxy {
  RidePayment status(RidePaymentStatusEnum status);

  RidePayment heldPesewas(int heldPesewas);

  RidePayment chargedPesewas(int chargedPesewas);

  RidePayment refundedPesewas(int refundedPesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RidePayment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RidePayment(...).copyWith(id: 12, name: "My name")
  /// ````
  RidePayment call({
    RidePaymentStatusEnum status,
    int heldPesewas,
    int chargedPesewas,
    int refundedPesewas,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRidePayment.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRidePayment.copyWith.fieldName(...)`
class _$RidePaymentCWProxyImpl implements _$RidePaymentCWProxy {
  const _$RidePaymentCWProxyImpl(this._value);

  final RidePayment _value;

  @override
  RidePayment status(RidePaymentStatusEnum status) => this(status: status);

  @override
  RidePayment heldPesewas(int heldPesewas) => this(heldPesewas: heldPesewas);

  @override
  RidePayment chargedPesewas(int chargedPesewas) =>
      this(chargedPesewas: chargedPesewas);

  @override
  RidePayment refundedPesewas(int refundedPesewas) =>
      this(refundedPesewas: refundedPesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RidePayment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RidePayment(...).copyWith(id: 12, name: "My name")
  /// ````
  RidePayment call({
    Object? status = const $CopyWithPlaceholder(),
    Object? heldPesewas = const $CopyWithPlaceholder(),
    Object? chargedPesewas = const $CopyWithPlaceholder(),
    Object? refundedPesewas = const $CopyWithPlaceholder(),
  }) {
    return RidePayment(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RidePaymentStatusEnum,
      heldPesewas: heldPesewas == const $CopyWithPlaceholder()
          ? _value.heldPesewas
          // ignore: cast_nullable_to_non_nullable
          : heldPesewas as int,
      chargedPesewas: chargedPesewas == const $CopyWithPlaceholder()
          ? _value.chargedPesewas
          // ignore: cast_nullable_to_non_nullable
          : chargedPesewas as int,
      refundedPesewas: refundedPesewas == const $CopyWithPlaceholder()
          ? _value.refundedPesewas
          // ignore: cast_nullable_to_non_nullable
          : refundedPesewas as int,
    );
  }
}

extension $RidePaymentCopyWith on RidePayment {
  /// Returns a callable class that can be used as follows: `instanceOfRidePayment.copyWith(...)` or like so:`instanceOfRidePayment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RidePaymentCWProxy get copyWith => _$RidePaymentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RidePayment _$RidePaymentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RidePayment', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'status',
          'heldPesewas',
          'chargedPesewas',
          'refundedPesewas',
        ],
      );
      final val = RidePayment(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$RidePaymentStatusEnumEnumMap, v),
        ),
        heldPesewas: $checkedConvert('heldPesewas', (v) => (v as num).toInt()),
        chargedPesewas: $checkedConvert(
          'chargedPesewas',
          (v) => (v as num).toInt(),
        ),
        refundedPesewas: $checkedConvert(
          'refundedPesewas',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RidePaymentToJson(RidePayment instance) =>
    <String, dynamic>{
      'status': _$RidePaymentStatusEnumEnumMap[instance.status]!,
      'heldPesewas': instance.heldPesewas,
      'chargedPesewas': instance.chargedPesewas,
      'refundedPesewas': instance.refundedPesewas,
    };

const _$RidePaymentStatusEnumEnumMap = {
  RidePaymentStatusEnum.held: 'held',
  RidePaymentStatusEnum.charged: 'charged',
  RidePaymentStatusEnum.released: 'released',
  RidePaymentStatusEnum.refunded: 'refunded',
  RidePaymentStatusEnum.partiallyRefunded: 'partially_refunded',
};
