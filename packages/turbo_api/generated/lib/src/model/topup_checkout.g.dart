// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_checkout.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TopupCheckoutCWProxy {
  TopupCheckout type(TopupCheckoutTypeEnum? type);

  TopupCheckout url(String? url);

  TopupCheckout message(String? message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupCheckout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupCheckout(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupCheckout call({
    TopupCheckoutTypeEnum? type,
    String? url,
    String? message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTopupCheckout.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTopupCheckout.copyWith.fieldName(...)`
class _$TopupCheckoutCWProxyImpl implements _$TopupCheckoutCWProxy {
  const _$TopupCheckoutCWProxyImpl(this._value);

  final TopupCheckout _value;

  @override
  TopupCheckout type(TopupCheckoutTypeEnum? type) => this(type: type);

  @override
  TopupCheckout url(String? url) => this(url: url);

  @override
  TopupCheckout message(String? message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupCheckout(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupCheckout(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupCheckout call({
    Object? type = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return TopupCheckout(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as TopupCheckoutTypeEnum?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
    );
  }
}

extension $TopupCheckoutCopyWith on TopupCheckout {
  /// Returns a callable class that can be used as follows: `instanceOfTopupCheckout.copyWith(...)` or like so:`instanceOfTopupCheckout.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TopupCheckoutCWProxy get copyWith => _$TopupCheckoutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupCheckout _$TopupCheckoutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TopupCheckout', json, ($checkedConvert) {
      final val = TopupCheckout(
        type: $checkedConvert(
          'type',
          (v) => $enumDecodeNullable(_$TopupCheckoutTypeEnumEnumMap, v),
        ),
        url: $checkedConvert('url', (v) => v as String?),
        message: $checkedConvert('message', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$TopupCheckoutToJson(TopupCheckout instance) =>
    <String, dynamic>{
      'type': ?_$TopupCheckoutTypeEnumEnumMap[instance.type],
      'url': ?instance.url,
      'message': ?instance.message,
    };

const _$TopupCheckoutTypeEnumEnumMap = {
  TopupCheckoutTypeEnum.redirect: 'redirect',
  TopupCheckoutTypeEnum.prompt: 'prompt',
};
