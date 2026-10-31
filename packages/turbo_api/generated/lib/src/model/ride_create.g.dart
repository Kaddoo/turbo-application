// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RideCreateCWProxy {
  RideCreate quoteId(String quoteId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  RideCreate call({String quoteId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRideCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRideCreate.copyWith.fieldName(...)`
class _$RideCreateCWProxyImpl implements _$RideCreateCWProxy {
  const _$RideCreateCWProxyImpl(this._value);

  final RideCreate _value;

  @override
  RideCreate quoteId(String quoteId) => this(quoteId: quoteId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  RideCreate call({Object? quoteId = const $CopyWithPlaceholder()}) {
    return RideCreate(
      quoteId: quoteId == const $CopyWithPlaceholder()
          ? _value.quoteId
          // ignore: cast_nullable_to_non_nullable
          : quoteId as String,
    );
  }
}

extension $RideCreateCopyWith on RideCreate {
  /// Returns a callable class that can be used as follows: `instanceOfRideCreate.copyWith(...)` or like so:`instanceOfRideCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RideCreateCWProxy get copyWith => _$RideCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideCreate _$RideCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RideCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['quoteId']);
      final val = RideCreate(
        quoteId: $checkedConvert('quoteId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RideCreateToJson(RideCreate instance) =>
    <String, dynamic>{'quoteId': instance.quoteId};
