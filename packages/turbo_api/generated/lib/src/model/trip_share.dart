//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_share.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TripShare {
  /// Returns a new [TripShare] instance.
  TripShare({

    required  this.shareUrl,

    required  this.expiresAt,

     this.notifiedContactIds,
  });

  @JsonKey(
    
    name: r'shareUrl',
    required: true,
    includeIfNull: false,
  )


  final String shareUrl;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;



  @JsonKey(
    
    name: r'notifiedContactIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? notifiedContactIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TripShare &&
      other.shareUrl == shareUrl &&
      other.expiresAt == expiresAt &&
      other.notifiedContactIds == notifiedContactIds;

    @override
    int get hashCode =>
        shareUrl.hashCode +
        expiresAt.hashCode +
        notifiedContactIds.hashCode;

  factory TripShare.fromJson(Map<String, dynamic> json) => _$TripShareFromJson(json);

  Map<String, dynamic> toJson() => _$TripShareToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

