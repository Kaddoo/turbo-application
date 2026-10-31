// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_resolve.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TopupResolveCWProxy {
  TopupResolve resolution(TopupResolveResolutionEnum resolution);

  TopupResolve note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupResolve(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupResolve(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupResolve call({TopupResolveResolutionEnum resolution, String note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTopupResolve.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTopupResolve.copyWith.fieldName(...)`
class _$TopupResolveCWProxyImpl implements _$TopupResolveCWProxy {
  const _$TopupResolveCWProxyImpl(this._value);

  final TopupResolve _value;

  @override
  TopupResolve resolution(TopupResolveResolutionEnum resolution) =>
      this(resolution: resolution);

  @override
  TopupResolve note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupResolve(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupResolve(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupResolve call({
    Object? resolution = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return TopupResolve(
      resolution: resolution == const $CopyWithPlaceholder()
          ? _value.resolution
          // ignore: cast_nullable_to_non_nullable
          : resolution as TopupResolveResolutionEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $TopupResolveCopyWith on TopupResolve {
  /// Returns a callable class that can be used as follows: `instanceOfTopupResolve.copyWith(...)` or like so:`instanceOfTopupResolve.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TopupResolveCWProxy get copyWith => _$TopupResolveCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupResolve _$TopupResolveFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TopupResolve', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['resolution', 'note']);
      final val = TopupResolve(
        resolution: $checkedConvert(
          'resolution',
          (v) => $enumDecode(_$TopupResolveResolutionEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TopupResolveToJson(TopupResolve instance) =>
    <String, dynamic>{
      'resolution': _$TopupResolveResolutionEnumEnumMap[instance.resolution]!,
      'note': instance.note,
    };

const _$TopupResolveResolutionEnumEnumMap = {
  TopupResolveResolutionEnum.acceptReceivedAmount: 'accept_received_amount',
  TopupResolveResolutionEnum.refundOutsideSystem: 'refund_outside_system',
  TopupResolveResolutionEnum.noAction: 'no_action',
};
