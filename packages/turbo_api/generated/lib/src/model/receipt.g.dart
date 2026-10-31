// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReceiptCWProxy {
  Receipt rideId(String rideId);

  Receipt receiptNumber(String receiptNumber);

  Receipt issuedAt(DateTime issuedAt);

  Receipt pickup(Location? pickup);

  Receipt dropoff(Location? dropoff);

  Receipt routeDistanceMeters(int? routeDistanceMeters);

  Receipt driverFirstName(String? driverFirstName);

  Receipt vehiclePlate(String? vehiclePlate);

  Receipt lines(List<ReceiptLine> lines);

  Receipt totalPesewas(int totalPesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Receipt(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Receipt(...).copyWith(id: 12, name: "My name")
  /// ````
  Receipt call({
    String rideId,
    String receiptNumber,
    DateTime issuedAt,
    Location? pickup,
    Location? dropoff,
    int? routeDistanceMeters,
    String? driverFirstName,
    String? vehiclePlate,
    List<ReceiptLine> lines,
    int totalPesewas,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReceipt.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReceipt.copyWith.fieldName(...)`
class _$ReceiptCWProxyImpl implements _$ReceiptCWProxy {
  const _$ReceiptCWProxyImpl(this._value);

  final Receipt _value;

  @override
  Receipt rideId(String rideId) => this(rideId: rideId);

  @override
  Receipt receiptNumber(String receiptNumber) =>
      this(receiptNumber: receiptNumber);

  @override
  Receipt issuedAt(DateTime issuedAt) => this(issuedAt: issuedAt);

  @override
  Receipt pickup(Location? pickup) => this(pickup: pickup);

  @override
  Receipt dropoff(Location? dropoff) => this(dropoff: dropoff);

  @override
  Receipt routeDistanceMeters(int? routeDistanceMeters) =>
      this(routeDistanceMeters: routeDistanceMeters);

  @override
  Receipt driverFirstName(String? driverFirstName) =>
      this(driverFirstName: driverFirstName);

  @override
  Receipt vehiclePlate(String? vehiclePlate) =>
      this(vehiclePlate: vehiclePlate);

  @override
  Receipt lines(List<ReceiptLine> lines) => this(lines: lines);

  @override
  Receipt totalPesewas(int totalPesewas) => this(totalPesewas: totalPesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Receipt(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Receipt(...).copyWith(id: 12, name: "My name")
  /// ````
  Receipt call({
    Object? rideId = const $CopyWithPlaceholder(),
    Object? receiptNumber = const $CopyWithPlaceholder(),
    Object? issuedAt = const $CopyWithPlaceholder(),
    Object? pickup = const $CopyWithPlaceholder(),
    Object? dropoff = const $CopyWithPlaceholder(),
    Object? routeDistanceMeters = const $CopyWithPlaceholder(),
    Object? driverFirstName = const $CopyWithPlaceholder(),
    Object? vehiclePlate = const $CopyWithPlaceholder(),
    Object? lines = const $CopyWithPlaceholder(),
    Object? totalPesewas = const $CopyWithPlaceholder(),
  }) {
    return Receipt(
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String,
      receiptNumber: receiptNumber == const $CopyWithPlaceholder()
          ? _value.receiptNumber
          // ignore: cast_nullable_to_non_nullable
          : receiptNumber as String,
      issuedAt: issuedAt == const $CopyWithPlaceholder()
          ? _value.issuedAt
          // ignore: cast_nullable_to_non_nullable
          : issuedAt as DateTime,
      pickup: pickup == const $CopyWithPlaceholder()
          ? _value.pickup
          // ignore: cast_nullable_to_non_nullable
          : pickup as Location?,
      dropoff: dropoff == const $CopyWithPlaceholder()
          ? _value.dropoff
          // ignore: cast_nullable_to_non_nullable
          : dropoff as Location?,
      routeDistanceMeters: routeDistanceMeters == const $CopyWithPlaceholder()
          ? _value.routeDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : routeDistanceMeters as int?,
      driverFirstName: driverFirstName == const $CopyWithPlaceholder()
          ? _value.driverFirstName
          // ignore: cast_nullable_to_non_nullable
          : driverFirstName as String?,
      vehiclePlate: vehiclePlate == const $CopyWithPlaceholder()
          ? _value.vehiclePlate
          // ignore: cast_nullable_to_non_nullable
          : vehiclePlate as String?,
      lines: lines == const $CopyWithPlaceholder()
          ? _value.lines
          // ignore: cast_nullable_to_non_nullable
          : lines as List<ReceiptLine>,
      totalPesewas: totalPesewas == const $CopyWithPlaceholder()
          ? _value.totalPesewas
          // ignore: cast_nullable_to_non_nullable
          : totalPesewas as int,
    );
  }
}

extension $ReceiptCopyWith on Receipt {
  /// Returns a callable class that can be used as follows: `instanceOfReceipt.copyWith(...)` or like so:`instanceOfReceipt.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReceiptCWProxy get copyWith => _$ReceiptCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Receipt',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'rideId',
        'receiptNumber',
        'issuedAt',
        'lines',
        'totalPesewas',
      ],
    );
    final val = Receipt(
      rideId: $checkedConvert('rideId', (v) => v as String),
      receiptNumber: $checkedConvert('receiptNumber', (v) => v as String),
      issuedAt: $checkedConvert('issuedAt', (v) => DateTime.parse(v as String)),
      pickup: $checkedConvert(
        'pickup',
        (v) => v == null ? null : Location.fromJson(v as Map<String, dynamic>),
      ),
      dropoff: $checkedConvert(
        'dropoff',
        (v) => v == null ? null : Location.fromJson(v as Map<String, dynamic>),
      ),
      routeDistanceMeters: $checkedConvert(
        'routeDistanceMeters',
        (v) => (v as num?)?.toInt(),
      ),
      driverFirstName: $checkedConvert('driverFirstName', (v) => v as String?),
      vehiclePlate: $checkedConvert('vehiclePlate', (v) => v as String?),
      lines: $checkedConvert(
        'lines',
        (v) => (v as List<dynamic>)
            .map((e) => ReceiptLine.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      totalPesewas: $checkedConvert('totalPesewas', (v) => (v as num).toInt()),
    );
    return val;
  },
);

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
  'rideId': instance.rideId,
  'receiptNumber': instance.receiptNumber,
  'issuedAt': instance.issuedAt.toIso8601String(),
  'pickup': ?instance.pickup?.toJson(),
  'dropoff': ?instance.dropoff?.toJson(),
  'routeDistanceMeters': ?instance.routeDistanceMeters,
  'driverFirstName': ?instance.driverFirstName,
  'vehiclePlate': ?instance.vehiclePlate,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'totalPesewas': instance.totalPesewas,
};
