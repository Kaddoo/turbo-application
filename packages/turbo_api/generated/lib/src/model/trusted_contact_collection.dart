//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/trusted_contact.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_contact_collection.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrustedContactCollection {
  /// Returns a new [TrustedContactCollection] instance.
  TrustedContactCollection({

    required  this.data,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<TrustedContact> data;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrustedContactCollection &&
      other.data == data;

    @override
    int get hashCode =>
        data.hashCode;

  factory TrustedContactCollection.fromJson(Map<String, dynamic> json) => _$TrustedContactCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$TrustedContactCollectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

