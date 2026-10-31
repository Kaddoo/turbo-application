//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topup_checkout.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TopupCheckout {
  /// Returns a new [TopupCheckout] instance.
  TopupCheckout({

     this.type,

     this.url,

     this.message,
  });

  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final TopupCheckoutTypeEnum? type;



  @JsonKey(
    
    name: r'url',
    required: false,
    includeIfNull: false,
  )


  final String? url;



  @JsonKey(
    
    name: r'message',
    required: false,
    includeIfNull: false,
  )


  final String? message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TopupCheckout &&
      other.type == type &&
      other.url == url &&
      other.message == message;

    @override
    int get hashCode =>
        type.hashCode +
        (url == null ? 0 : url.hashCode) +
        (message == null ? 0 : message.hashCode);

  factory TopupCheckout.fromJson(Map<String, dynamic> json) => _$TopupCheckoutFromJson(json);

  Map<String, dynamic> toJson() => _$TopupCheckoutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TopupCheckoutTypeEnum {
@JsonValue(r'redirect')
redirect(r'redirect'),
@JsonValue(r'prompt')
prompt(r'prompt');

const TopupCheckoutTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


