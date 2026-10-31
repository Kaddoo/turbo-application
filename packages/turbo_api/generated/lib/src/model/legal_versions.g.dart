// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_versions.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalVersionsCWProxy {
  LegalVersions termsVersion(String termsVersion);

  LegalVersions privacyVersion(String privacyVersion);

  LegalVersions termsUrl(String termsUrl);

  LegalVersions privacyUrl(String privacyUrl);

  LegalVersions locationNoticeUrl(String? locationNoticeUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersions(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersions call({
    String termsVersion,
    String privacyVersion,
    String termsUrl,
    String privacyUrl,
    String? locationNoticeUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalVersions.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalVersions.copyWith.fieldName(...)`
class _$LegalVersionsCWProxyImpl implements _$LegalVersionsCWProxy {
  const _$LegalVersionsCWProxyImpl(this._value);

  final LegalVersions _value;

  @override
  LegalVersions termsVersion(String termsVersion) =>
      this(termsVersion: termsVersion);

  @override
  LegalVersions privacyVersion(String privacyVersion) =>
      this(privacyVersion: privacyVersion);

  @override
  LegalVersions termsUrl(String termsUrl) => this(termsUrl: termsUrl);

  @override
  LegalVersions privacyUrl(String privacyUrl) => this(privacyUrl: privacyUrl);

  @override
  LegalVersions locationNoticeUrl(String? locationNoticeUrl) =>
      this(locationNoticeUrl: locationNoticeUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersions(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersions call({
    Object? termsVersion = const $CopyWithPlaceholder(),
    Object? privacyVersion = const $CopyWithPlaceholder(),
    Object? termsUrl = const $CopyWithPlaceholder(),
    Object? privacyUrl = const $CopyWithPlaceholder(),
    Object? locationNoticeUrl = const $CopyWithPlaceholder(),
  }) {
    return LegalVersions(
      termsVersion: termsVersion == const $CopyWithPlaceholder()
          ? _value.termsVersion
          // ignore: cast_nullable_to_non_nullable
          : termsVersion as String,
      privacyVersion: privacyVersion == const $CopyWithPlaceholder()
          ? _value.privacyVersion
          // ignore: cast_nullable_to_non_nullable
          : privacyVersion as String,
      termsUrl: termsUrl == const $CopyWithPlaceholder()
          ? _value.termsUrl
          // ignore: cast_nullable_to_non_nullable
          : termsUrl as String,
      privacyUrl: privacyUrl == const $CopyWithPlaceholder()
          ? _value.privacyUrl
          // ignore: cast_nullable_to_non_nullable
          : privacyUrl as String,
      locationNoticeUrl: locationNoticeUrl == const $CopyWithPlaceholder()
          ? _value.locationNoticeUrl
          // ignore: cast_nullable_to_non_nullable
          : locationNoticeUrl as String?,
    );
  }
}

extension $LegalVersionsCopyWith on LegalVersions {
  /// Returns a callable class that can be used as follows: `instanceOfLegalVersions.copyWith(...)` or like so:`instanceOfLegalVersions.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalVersionsCWProxy get copyWith => _$LegalVersionsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalVersions _$LegalVersionsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalVersions', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'termsVersion',
          'privacyVersion',
          'termsUrl',
          'privacyUrl',
        ],
      );
      final val = LegalVersions(
        termsVersion: $checkedConvert('termsVersion', (v) => v as String),
        privacyVersion: $checkedConvert('privacyVersion', (v) => v as String),
        termsUrl: $checkedConvert('termsUrl', (v) => v as String),
        privacyUrl: $checkedConvert('privacyUrl', (v) => v as String),
        locationNoticeUrl: $checkedConvert(
          'locationNoticeUrl',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$LegalVersionsToJson(LegalVersions instance) =>
    <String, dynamic>{
      'termsVersion': instance.termsVersion,
      'privacyVersion': instance.privacyVersion,
      'termsUrl': instance.termsUrl,
      'privacyUrl': instance.privacyUrl,
      'locationNoticeUrl': ?instance.locationNoticeUrl,
    };
