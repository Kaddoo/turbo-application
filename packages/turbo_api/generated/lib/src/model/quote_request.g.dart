// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuoteRequestCWProxy {
  QuoteRequest pickup(Location pickup);

  QuoteRequest dropoff(Location dropoff);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuoteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuoteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  QuoteRequest call({Location pickup, Location dropoff});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuoteRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuoteRequest.copyWith.fieldName(...)`
class _$QuoteRequestCWProxyImpl implements _$QuoteRequestCWProxy {
  const _$QuoteRequestCWProxyImpl(this._value);

  final QuoteRequest _value;

  @override
  QuoteRequest pickup(Location pickup) => this(pickup: pickup);

  @override
  QuoteRequest dropoff(Location dropoff) => this(dropoff: dropoff);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuoteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuoteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  QuoteRequest call({
    Object? pickup = const $CopyWithPlaceholder(),
    Object? dropoff = const $CopyWithPlaceholder(),
  }) {
    return QuoteRequest(
      pickup: pickup == const $CopyWithPlaceholder()
          ? _value.pickup
          // ignore: cast_nullable_to_non_nullable
          : pickup as Location,
      dropoff: dropoff == const $CopyWithPlaceholder()
          ? _value.dropoff
          // ignore: cast_nullable_to_non_nullable
          : dropoff as Location,
    );
  }
}

extension $QuoteRequestCopyWith on QuoteRequest {
  /// Returns a callable class that can be used as follows: `instanceOfQuoteRequest.copyWith(...)` or like so:`instanceOfQuoteRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuoteRequestCWProxy get copyWith => _$QuoteRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteRequest _$QuoteRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuoteRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['pickup', 'dropoff']);
      final val = QuoteRequest(
        pickup: $checkedConvert(
          'pickup',
          (v) => Location.fromJson(v as Map<String, dynamic>),
        ),
        dropoff: $checkedConvert(
          'dropoff',
          (v) => Location.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuoteRequestToJson(QuoteRequest instance) =>
    <String, dynamic>{
      'pickup': instance.pickup.toJson(),
      'dropoff': instance.dropoff.toJson(),
    };
