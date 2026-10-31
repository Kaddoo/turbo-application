//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/quick_message.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quick_message_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuickMessageList {
  /// Returns a new [QuickMessageList] instance.
  QuickMessageList({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<QuickMessage> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuickMessageList &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory QuickMessageList.fromJson(Map<String, dynamic> json) => _$QuickMessageListFromJson(json);

  Map<String, dynamic> toJson() => _$QuickMessageListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

