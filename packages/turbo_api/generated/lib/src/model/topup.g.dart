// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TopupCWProxy {
  Topup id(String id);

  Topup studentId(String? studentId);

  Topup status(TopupStatusEnum status);

  Topup amountPesewas(int amountPesewas);

  Topup channel(TopupChannelEnum channel);

  Topup reference(String reference);

  Topup checkout(TopupCheckout? checkout);

  Topup createdAt(DateTime createdAt);

  Topup completedAt(DateTime? completedAt);

  Topup amountReceivedPesewas(int? amountReceivedPesewas);

  Topup validation(TopupValidationEnum? validation);

  Topup flagged(bool? flagged);

  Topup flagReason(String? flagReason);

  Topup resolvedAt(DateTime? resolvedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Topup(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Topup(...).copyWith(id: 12, name: "My name")
  /// ````
  Topup call({
    String id,
    String? studentId,
    TopupStatusEnum status,
    int amountPesewas,
    TopupChannelEnum channel,
    String reference,
    TopupCheckout? checkout,
    DateTime createdAt,
    DateTime? completedAt,
    int? amountReceivedPesewas,
    TopupValidationEnum? validation,
    bool? flagged,
    String? flagReason,
    DateTime? resolvedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTopup.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTopup.copyWith.fieldName(...)`
class _$TopupCWProxyImpl implements _$TopupCWProxy {
  const _$TopupCWProxyImpl(this._value);

  final Topup _value;

  @override
  Topup id(String id) => this(id: id);

  @override
  Topup studentId(String? studentId) => this(studentId: studentId);

  @override
  Topup status(TopupStatusEnum status) => this(status: status);

  @override
  Topup amountPesewas(int amountPesewas) => this(amountPesewas: amountPesewas);

  @override
  Topup channel(TopupChannelEnum channel) => this(channel: channel);

  @override
  Topup reference(String reference) => this(reference: reference);

  @override
  Topup checkout(TopupCheckout? checkout) => this(checkout: checkout);

  @override
  Topup createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Topup completedAt(DateTime? completedAt) => this(completedAt: completedAt);

  @override
  Topup amountReceivedPesewas(int? amountReceivedPesewas) =>
      this(amountReceivedPesewas: amountReceivedPesewas);

  @override
  Topup validation(TopupValidationEnum? validation) =>
      this(validation: validation);

  @override
  Topup flagged(bool? flagged) => this(flagged: flagged);

  @override
  Topup flagReason(String? flagReason) => this(flagReason: flagReason);

  @override
  Topup resolvedAt(DateTime? resolvedAt) => this(resolvedAt: resolvedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Topup(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Topup(...).copyWith(id: 12, name: "My name")
  /// ````
  Topup call({
    Object? id = const $CopyWithPlaceholder(),
    Object? studentId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? channel = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? checkout = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
    Object? amountReceivedPesewas = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? flagged = const $CopyWithPlaceholder(),
    Object? flagReason = const $CopyWithPlaceholder(),
    Object? resolvedAt = const $CopyWithPlaceholder(),
  }) {
    return Topup(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      studentId: studentId == const $CopyWithPlaceholder()
          ? _value.studentId
          // ignore: cast_nullable_to_non_nullable
          : studentId as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as TopupStatusEnum,
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      channel: channel == const $CopyWithPlaceholder()
          ? _value.channel
          // ignore: cast_nullable_to_non_nullable
          : channel as TopupChannelEnum,
      reference: reference == const $CopyWithPlaceholder()
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as String,
      checkout: checkout == const $CopyWithPlaceholder()
          ? _value.checkout
          // ignore: cast_nullable_to_non_nullable
          : checkout as TopupCheckout?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
      amountReceivedPesewas:
          amountReceivedPesewas == const $CopyWithPlaceholder()
          ? _value.amountReceivedPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountReceivedPesewas as int?,
      validation: validation == const $CopyWithPlaceholder()
          ? _value.validation
          // ignore: cast_nullable_to_non_nullable
          : validation as TopupValidationEnum?,
      flagged: flagged == const $CopyWithPlaceholder()
          ? _value.flagged
          // ignore: cast_nullable_to_non_nullable
          : flagged as bool?,
      flagReason: flagReason == const $CopyWithPlaceholder()
          ? _value.flagReason
          // ignore: cast_nullable_to_non_nullable
          : flagReason as String?,
      resolvedAt: resolvedAt == const $CopyWithPlaceholder()
          ? _value.resolvedAt
          // ignore: cast_nullable_to_non_nullable
          : resolvedAt as DateTime?,
    );
  }
}

extension $TopupCopyWith on Topup {
  /// Returns a callable class that can be used as follows: `instanceOfTopup.copyWith(...)` or like so:`instanceOfTopup.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TopupCWProxy get copyWith => _$TopupCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topup _$TopupFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Topup', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'status',
      'amountPesewas',
      'channel',
      'reference',
      'createdAt',
    ],
  );
  final val = Topup(
    id: $checkedConvert('id', (v) => v as String),
    studentId: $checkedConvert('studentId', (v) => v as String?),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$TopupStatusEnumEnumMap, v),
    ),
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    channel: $checkedConvert(
      'channel',
      (v) => $enumDecode(_$TopupChannelEnumEnumMap, v),
    ),
    reference: $checkedConvert('reference', (v) => v as String),
    checkout: $checkedConvert(
      'checkout',
      (v) =>
          v == null ? null : TopupCheckout.fromJson(v as Map<String, dynamic>),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    completedAt: $checkedConvert(
      'completedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    amountReceivedPesewas: $checkedConvert(
      'amountReceivedPesewas',
      (v) => (v as num?)?.toInt(),
    ),
    validation: $checkedConvert(
      'validation',
      (v) => $enumDecodeNullable(_$TopupValidationEnumEnumMap, v),
    ),
    flagged: $checkedConvert('flagged', (v) => v as bool?),
    flagReason: $checkedConvert('flagReason', (v) => v as String?),
    resolvedAt: $checkedConvert(
      'resolvedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$TopupToJson(Topup instance) => <String, dynamic>{
  'id': instance.id,
  'studentId': ?instance.studentId,
  'status': _$TopupStatusEnumEnumMap[instance.status]!,
  'amountPesewas': instance.amountPesewas,
  'channel': _$TopupChannelEnumEnumMap[instance.channel]!,
  'reference': instance.reference,
  'checkout': ?instance.checkout?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': ?instance.completedAt?.toIso8601String(),
  'amountReceivedPesewas': ?instance.amountReceivedPesewas,
  'validation': ?_$TopupValidationEnumEnumMap[instance.validation],
  'flagged': ?instance.flagged,
  'flagReason': ?instance.flagReason,
  'resolvedAt': ?instance.resolvedAt?.toIso8601String(),
};

const _$TopupStatusEnumEnumMap = {
  TopupStatusEnum.pending: 'pending',
  TopupStatusEnum.succeeded: 'succeeded',
  TopupStatusEnum.failed: 'failed',
  TopupStatusEnum.abandoned: 'abandoned',
};

const _$TopupChannelEnumEnumMap = {
  TopupChannelEnum.mobileMoney: 'mobile_money',
  TopupChannelEnum.card: 'card',
};

const _$TopupValidationEnumEnumMap = {
  TopupValidationEnum.exact: 'exact',
  TopupValidationEnum.underpayment: 'underpayment',
  TopupValidationEnum.overpayment: 'overpayment',
};
