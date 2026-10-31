//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Session {
  /// Returns a new [Session] instance.
  Session({

    required  this.id,

    required  this.platform,

     this.deviceName,

    required  this.lastUsedAt,

    required  this.current,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final SessionPlatformEnum platform;



  @JsonKey(
    
    name: r'deviceName',
    required: false,
    includeIfNull: false,
  )


  final String? deviceName;



  @JsonKey(
    
    name: r'lastUsedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime lastUsedAt;



  @JsonKey(
    
    name: r'current',
    required: true,
    includeIfNull: false,
  )


  final bool current;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Session &&
      other.id == id &&
      other.platform == platform &&
      other.deviceName == deviceName &&
      other.lastUsedAt == lastUsedAt &&
      other.current == current;

    @override
    int get hashCode =>
        id.hashCode +
        platform.hashCode +
        (deviceName == null ? 0 : deviceName.hashCode) +
        lastUsedAt.hashCode +
        current.hashCode;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SessionPlatformEnum {
@JsonValue(r'ios')
ios(r'ios'),
@JsonValue(r'android')
android(r'android'),
@JsonValue(r'web')
web(r'web');

const SessionPlatformEnum(this.value);

final String value;

@override
String toString() => value;
}


