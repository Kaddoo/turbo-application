// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FareBandCWProxy {
  FareBand upToMeters(int upToMeters);

  FareBand farePesewas(int farePesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FareBand(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FareBand(...).copyWith(id: 12, name: "My name")
  /// ````
  FareBand call({int upToMeters, int farePesewas});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFareBand.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFareBand.copyWith.fieldName(...)`
class _$FareBandCWProxyImpl implements _$FareBandCWProxy {
  const _$FareBandCWProxyImpl(this._value);

  final FareBand _value;

  @override
  FareBand upToMeters(int upToMeters) => this(upToMeters: upToMeters);

  @override
  FareBand farePesewas(int farePesewas) => this(farePesewas: farePesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FareBand(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FareBand(...).copyWith(id: 12, name: "My name")
  /// ````
  FareBand call({
    Object? upToMeters = const $CopyWithPlaceholder(),
    Object? farePesewas = const $CopyWithPlaceholder(),
  }) {
    return FareBand(
      upToMeters: upToMeters == const $CopyWithPlaceholder()
          ? _value.upToMeters
          // ignore: cast_nullable_to_non_nullable
          : upToMeters as int,
      farePesewas: farePesewas == const $CopyWithPlaceholder()
          ? _value.farePesewas
          // ignore: cast_nullable_to_non_nullable
          : farePesewas as int,
    );
  }
}

extension $FareBandCopyWith on FareBand {
  /// Returns a callable class that can be used as follows: `instanceOfFareBand.copyWith(...)` or like so:`instanceOfFareBand.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FareBandCWProxy get copyWith => _$FareBandCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareBand _$FareBandFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FareBand', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['upToMeters', 'farePesewas']);
      final val = FareBand(
        upToMeters: $checkedConvert('upToMeters', (v) => (v as num).toInt()),
        farePesewas: $checkedConvert('farePesewas', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$FareBandToJson(FareBand instance) => <String, dynamic>{
  'upToMeters': instance.upToMeters,
  'farePesewas': instance.farePesewas,
};
