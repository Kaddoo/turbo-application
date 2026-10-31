//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_min_version.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfigMinVersion {
  /// Returns a new [AppConfigMinVersion] instance.
  AppConfigMinVersion({

    required  this.ios,

    required  this.android,

    required  this.web,
  });

  @JsonKey(
    
    name: r'ios',
    required: true,
    includeIfNull: false,
  )


  final String ios;



  @JsonKey(
    
    name: r'android',
    required: true,
    includeIfNull: false,
  )


  final String android;



  @JsonKey(
    
    name: r'web',
    required: true,
    includeIfNull: false,
  )


  final String web;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppConfigMinVersion &&
      other.ios == ios &&
      other.android == android &&
      other.web == web;

    @override
    int get hashCode =>
        ios.hashCode +
        android.hashCode +
        web.hashCode;

  factory AppConfigMinVersion.fromJson(Map<String, dynamic> json) => _$AppConfigMinVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigMinVersionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

