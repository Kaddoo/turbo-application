// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TopupCreateCWProxy {
  TopupCreate amountPesewas(int amountPesewas);

  TopupCreate channel(TopupCreateChannelEnum channel);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupCreate call({int amountPesewas, TopupCreateChannelEnum channel});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTopupCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTopupCreate.copyWith.fieldName(...)`
class _$TopupCreateCWProxyImpl implements _$TopupCreateCWProxy {
  const _$TopupCreateCWProxyImpl(this._value);

  final TopupCreate _value;

  @override
  TopupCreate amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  TopupCreate channel(TopupCreateChannelEnum channel) => this(channel: channel);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupCreate call({
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? channel = const $CopyWithPlaceholder(),
  }) {
    return TopupCreate(
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      channel: channel == const $CopyWithPlaceholder()
          ? _value.channel
          // ignore: cast_nullable_to_non_nullable
          : channel as TopupCreateChannelEnum,
    );
  }
}

extension $TopupCreateCopyWith on TopupCreate {
  /// Returns a callable class that can be used as follows: `instanceOfTopupCreate.copyWith(...)` or like so:`instanceOfTopupCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TopupCreateCWProxy get copyWith => _$TopupCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupCreate _$TopupCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TopupCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['amountPesewas', 'channel']);
      final val = TopupCreate(
        amountPesewas: $checkedConvert(
          'amountPesewas',
          (v) => (v as num).toInt(),
        ),
        channel: $checkedConvert(
          'channel',
          (v) => $enumDecode(_$TopupCreateChannelEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TopupCreateToJson(TopupCreate instance) =>
    <String, dynamic>{
      'amountPesewas': instance.amountPesewas,
      'channel': _$TopupCreateChannelEnumEnumMap[instance.channel]!,
    };

const _$TopupCreateChannelEnumEnumMap = {
  TopupCreateChannelEnum.mobileMoney: 'mobile_money',
  TopupCreateChannelEnum.card: 'card',
};
