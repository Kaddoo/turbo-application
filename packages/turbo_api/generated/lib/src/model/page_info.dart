//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_info.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PageInfo {
  /// Returns a new [PageInfo] instance.
  PageInfo({

    required  this.nextCursor,

    required  this.hasMore,
  });

      /// Opaque. Pass back as ?cursor= for the next page. Null on the last page.
  @JsonKey(
    
    name: r'nextCursor',
    required: true,
    includeIfNull: true,
  )


  final String? nextCursor;



  @JsonKey(
    
    name: r'hasMore',
    required: true,
    includeIfNull: false,
  )


  final bool hasMore;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PageInfo &&
      other.nextCursor == nextCursor &&
      other.hasMore == hasMore;

    @override
    int get hashCode =>
        (nextCursor == null ? 0 : nextCursor.hashCode) +
        hasMore.hashCode;

  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PageInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

