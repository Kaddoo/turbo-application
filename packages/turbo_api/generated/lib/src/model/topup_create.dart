//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topup_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TopupCreate {
  /// Returns a new [TopupCreate] instance.
  TopupCreate({

    required  this.amountPesewas,

    required  this.channel,
  });

      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;



  @JsonKey(
    
    name: r'channel',
    required: true,
    includeIfNull: false,
  )


  final TopupCreateChannelEnum channel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TopupCreate &&
      other.amountPesewas == amountPesewas &&
      other.channel == channel;

    @override
    int get hashCode =>
        amountPesewas.hashCode +
        channel.hashCode;

  factory TopupCreate.fromJson(Map<String, dynamic> json) => _$TopupCreateFromJson(json);

  Map<String, dynamic> toJson() => _$TopupCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TopupCreateChannelEnum {
@JsonValue(r'mobile_money')
mobileMoney(r'mobile_money'),
@JsonValue(r'card')
card(r'card');

const TopupCreateChannelEnum(this.value);

final String value;

@override
String toString() => value;
}


