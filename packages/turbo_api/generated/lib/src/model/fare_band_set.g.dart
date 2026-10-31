// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_band_set.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FareBandSetCWProxy {
  FareBandSet bands(List<FareBand> bands);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FareBandSet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FareBandSet(...).copyWith(id: 12, name: "My name")
  /// ````
  FareBandSet call({List<FareBand> bands});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFareBandSet.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFareBandSet.copyWith.fieldName(...)`
class _$FareBandSetCWProxyImpl implements _$FareBandSetCWProxy {
  const _$FareBandSetCWProxyImpl(this._value);

  final FareBandSet _value;

  @override
  FareBandSet bands(List<FareBand> bands) => this(bands: bands);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FareBandSet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FareBandSet(...).copyWith(id: 12, name: "My name")
  /// ````
  FareBandSet call({Object? bands = const $CopyWithPlaceholder()}) {
    return FareBandSet(
      bands: bands == const $CopyWithPlaceholder()
          ? _value.bands
          // ignore: cast_nullable_to_non_nullable
          : bands as List<FareBand>,
    );
  }
}

extension $FareBandSetCopyWith on FareBandSet {
  /// Returns a callable class that can be used as follows: `instanceOfFareBandSet.copyWith(...)` or like so:`instanceOfFareBandSet.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FareBandSetCWProxy get copyWith => _$FareBandSetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareBandSet _$FareBandSetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FareBandSet', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['bands']);
      final val = FareBandSet(
        bands: $checkedConvert(
          'bands',
          (v) => (v as List<dynamic>)
              .map((e) => FareBand.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FareBandSetToJson(FareBandSet instance) =>
    <String, dynamic>{'bands': instance.bands.map((e) => e.toJson()).toList()};
