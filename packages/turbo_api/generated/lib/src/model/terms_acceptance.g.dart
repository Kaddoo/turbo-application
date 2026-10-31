// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_acceptance.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TermsAcceptanceCWProxy {
  TermsAcceptance termsVersion(String termsVersion);

  TermsAcceptance privacyVersion(String privacyVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TermsAcceptance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TermsAcceptance(...).copyWith(id: 12, name: "My name")
  /// ````
  TermsAcceptance call({String termsVersion, String privacyVersion});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTermsAcceptance.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTermsAcceptance.copyWith.fieldName(...)`
class _$TermsAcceptanceCWProxyImpl implements _$TermsAcceptanceCWProxy {
  const _$TermsAcceptanceCWProxyImpl(this._value);

  final TermsAcceptance _value;

  @override
  TermsAcceptance termsVersion(String termsVersion) =>
      this(termsVersion: termsVersion);

  @override
  TermsAcceptance privacyVersion(String privacyVersion) =>
      this(privacyVersion: privacyVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TermsAcceptance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TermsAcceptance(...).copyWith(id: 12, name: "My name")
  /// ````
  TermsAcceptance call({
    Object? termsVersion = const $CopyWithPlaceholder(),
    Object? privacyVersion = const $CopyWithPlaceholder(),
  }) {
    return TermsAcceptance(
      termsVersion: termsVersion == const $CopyWithPlaceholder()
          ? _value.termsVersion
          // ignore: cast_nullable_to_non_nullable
          : termsVersion as String,
      privacyVersion: privacyVersion == const $CopyWithPlaceholder()
          ? _value.privacyVersion
          // ignore: cast_nullable_to_non_nullable
          : privacyVersion as String,
    );
  }
}

extension $TermsAcceptanceCopyWith on TermsAcceptance {
  /// Returns a callable class that can be used as follows: `instanceOfTermsAcceptance.copyWith(...)` or like so:`instanceOfTermsAcceptance.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TermsAcceptanceCWProxy get copyWith => _$TermsAcceptanceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsAcceptance _$TermsAcceptanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TermsAcceptance', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['termsVersion', 'privacyVersion']);
      final val = TermsAcceptance(
        termsVersion: $checkedConvert('termsVersion', (v) => v as String),
        privacyVersion: $checkedConvert('privacyVersion', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TermsAcceptanceToJson(TermsAcceptance instance) =>
    <String, dynamic>{
      'termsVersion': instance.termsVersion,
      'privacyVersion': instance.privacyVersion,
    };
