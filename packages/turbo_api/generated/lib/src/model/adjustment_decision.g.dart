// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_decision.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdjustmentDecisionCWProxy {
  AdjustmentDecision note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentDecision(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentDecision(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentDecision call({String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdjustmentDecision.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdjustmentDecision.copyWith.fieldName(...)`
class _$AdjustmentDecisionCWProxyImpl implements _$AdjustmentDecisionCWProxy {
  const _$AdjustmentDecisionCWProxyImpl(this._value);

  final AdjustmentDecision _value;

  @override
  AdjustmentDecision note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentDecision(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentDecision(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentDecision call({Object? note = const $CopyWithPlaceholder()}) {
    return AdjustmentDecision(
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $AdjustmentDecisionCopyWith on AdjustmentDecision {
  /// Returns a callable class that can be used as follows: `instanceOfAdjustmentDecision.copyWith(...)` or like so:`instanceOfAdjustmentDecision.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdjustmentDecisionCWProxy get copyWith =>
      _$AdjustmentDecisionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentDecision _$AdjustmentDecisionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdjustmentDecision', json, ($checkedConvert) {
      final val = AdjustmentDecision(
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdjustmentDecisionToJson(AdjustmentDecision instance) =>
    <String, dynamic>{'note': ?instance.note};
