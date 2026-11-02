//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_settings.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NotificationSettings {
  /// Returns a new [NotificationSettings] instance.
  NotificationSettings({

    required  this.newsAndOffers,

    required  this.tips,
  });

  @JsonKey(
    
    name: r'newsAndOffers',
    required: true,
    includeIfNull: false,
  )


  final bool newsAndOffers;



  @JsonKey(
    
    name: r'tips',
    required: true,
    includeIfNull: false,
  )


  final bool tips;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NotificationSettings &&
      other.newsAndOffers == newsAndOffers &&
      other.tips == tips;

    @override
    int get hashCode =>
        newsAndOffers.hashCode +
        tips.hashCode;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

