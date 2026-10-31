// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RatingCreateCWProxy {
  RatingCreate stars(int stars);

  RatingCreate tags(List<String>? tags);

  RatingCreate comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RatingCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RatingCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  RatingCreate call({int stars, List<String>? tags, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRatingCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRatingCreate.copyWith.fieldName(...)`
class _$RatingCreateCWProxyImpl implements _$RatingCreateCWProxy {
  const _$RatingCreateCWProxyImpl(this._value);

  final RatingCreate _value;

  @override
  RatingCreate stars(int stars) => this(stars: stars);

  @override
  RatingCreate tags(List<String>? tags) => this(tags: tags);

  @override
  RatingCreate comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RatingCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RatingCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  RatingCreate call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return RatingCreate(
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as int,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>?,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $RatingCreateCopyWith on RatingCreate {
  /// Returns a callable class that can be used as follows: `instanceOfRatingCreate.copyWith(...)` or like so:`instanceOfRatingCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RatingCreateCWProxy get copyWith => _$RatingCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingCreate _$RatingCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RatingCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['stars']);
      final val = RatingCreate(
        stars: $checkedConvert('stars', (v) => (v as num).toInt()),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        comment: $checkedConvert('comment', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RatingCreateToJson(RatingCreate instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'tags': ?instance.tags,
      'comment': ?instance.comment,
    };
