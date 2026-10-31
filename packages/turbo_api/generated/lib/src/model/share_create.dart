//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShareCreate {
  /// Returns a new [ShareCreate] instance.
  ShareCreate({

    required  this.trustedContactIds,
  });

  @JsonKey(
    
    name: r'trustedContactIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> trustedContactIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ShareCreate &&
      other.trustedContactIds == trustedContactIds;

    @override
    int get hashCode =>
        trustedContactIds.hashCode;

  factory ShareCreate.fromJson(Map<String, dynamic> json) => _$ShareCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ShareCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

