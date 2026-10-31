// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_change_confirm.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DestinationChangeConfirmCWProxy {
  DestinationChangeConfirm quoteId(String quoteId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DestinationChangeConfirm(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DestinationChangeConfirm(...).copyWith(id: 12, name: "My name")
  /// ````
  DestinationChangeConfirm call({String quoteId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDestinationChangeConfirm.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDestinationChangeConfirm.copyWith.fieldName(...)`
class _$DestinationChangeConfirmCWProxyImpl
    implements _$DestinationChangeConfirmCWProxy {
  const _$DestinationChangeConfirmCWProxyImpl(this._value);

  final DestinationChangeConfirm _value;

  @override
  DestinationChangeConfirm quoteId(String quoteId) => this(quoteId: quoteId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DestinationChangeConfirm(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DestinationChangeConfirm(...).copyWith(id: 12, name: "My name")
  /// ````
  DestinationChangeConfirm call({
    Object? quoteId = const $CopyWithPlaceholder(),
  }) {
    return DestinationChangeConfirm(
      quoteId: quoteId == const $CopyWithPlaceholder()
          ? _value.quoteId
          // ignore: cast_nullable_to_non_nullable
          : quoteId as String,
    );
  }
}

extension $DestinationChangeConfirmCopyWith on DestinationChangeConfirm {
  /// Returns a callable class that can be used as follows: `instanceOfDestinationChangeConfirm.copyWith(...)` or like so:`instanceOfDestinationChangeConfirm.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DestinationChangeConfirmCWProxy get copyWith =>
      _$DestinationChangeConfirmCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DestinationChangeConfirm _$DestinationChangeConfirmFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DestinationChangeConfirm', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['quoteId']);
  final val = DestinationChangeConfirm(
    quoteId: $checkedConvert('quoteId', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$DestinationChangeConfirmToJson(
  DestinationChangeConfirm instance,
) => <String, dynamic>{'quoteId': instance.quoteId};
