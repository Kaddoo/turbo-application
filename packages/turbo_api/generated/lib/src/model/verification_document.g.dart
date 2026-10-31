// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_document.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDocumentCWProxy {
  VerificationDocument purpose(VerificationDocumentPurposeEnum purpose);

  VerificationDocument url(String url);

  VerificationDocument expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDocument(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDocument(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDocument call({
    VerificationDocumentPurposeEnum purpose,
    String url,
    DateTime expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDocument.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDocument.copyWith.fieldName(...)`
class _$VerificationDocumentCWProxyImpl
    implements _$VerificationDocumentCWProxy {
  const _$VerificationDocumentCWProxyImpl(this._value);

  final VerificationDocument _value;

  @override
  VerificationDocument purpose(VerificationDocumentPurposeEnum purpose) =>
      this(purpose: purpose);

  @override
  VerificationDocument url(String url) => this(url: url);

  @override
  VerificationDocument expiresAt(DateTime expiresAt) =>
      this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDocument(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDocument(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDocument call({
    Object? purpose = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return VerificationDocument(
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as VerificationDocumentPurposeEnum,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $VerificationDocumentCopyWith on VerificationDocument {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDocument.copyWith(...)` or like so:`instanceOfVerificationDocument.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDocumentCWProxy get copyWith =>
      _$VerificationDocumentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDocument _$VerificationDocumentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDocument', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['purpose', 'url', 'expiresAt']);
  final val = VerificationDocument(
    purpose: $checkedConvert(
      'purpose',
      (v) => $enumDecode(_$VerificationDocumentPurposeEnumEnumMap, v),
    ),
    url: $checkedConvert('url', (v) => v as String),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$VerificationDocumentToJson(
  VerificationDocument instance,
) => <String, dynamic>{
  'purpose': _$VerificationDocumentPurposeEnumEnumMap[instance.purpose]!,
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

const _$VerificationDocumentPurposeEnumEnumMap = {
  VerificationDocumentPurposeEnum.ghanaCardFront: 'ghana_card_front',
  VerificationDocumentPurposeEnum.ghanaCardBack: 'ghana_card_back',
  VerificationDocumentPurposeEnum.studentId: 'student_id',
  VerificationDocumentPurposeEnum.selfieWithCard: 'selfie_with_card',
};
