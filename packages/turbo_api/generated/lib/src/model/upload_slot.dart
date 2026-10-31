//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_slot.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadSlot {
  /// Returns a new [UploadSlot] instance.
  UploadSlot({

    required  this.uploadId,

    required  this.uploadUrl,

    required  this.method,

     this.headers,

    required  this.expiresAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'uploadId',
    required: true,
    includeIfNull: false,
  )


  final String uploadId;



      /// Short-lived signed URL. PUT the raw bytes here.
  @JsonKey(
    
    name: r'uploadUrl',
    required: true,
    includeIfNull: false,
  )


  final String uploadUrl;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final UploadSlotMethodEnum method;



  @JsonKey(
    
    name: r'headers',
    required: false,
    includeIfNull: false,
  )


  final Map<String, String>? headers;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadSlot &&
      other.uploadId == uploadId &&
      other.uploadUrl == uploadUrl &&
      other.method == method &&
      other.headers == headers &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        uploadId.hashCode +
        uploadUrl.hashCode +
        method.hashCode +
        headers.hashCode +
        expiresAt.hashCode;

  factory UploadSlot.fromJson(Map<String, dynamic> json) => _$UploadSlotFromJson(json);

  Map<String, dynamic> toJson() => _$UploadSlotToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UploadSlotMethodEnum {
@JsonValue(r'PUT')
PUT(r'PUT');

const UploadSlotMethodEnum(this.value);

final String value;

@override
String toString() => value;
}


