//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt_line.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReceiptLine {
  /// Returns a new [ReceiptLine] instance.
  ReceiptLine({

    required  this.label,

    required  this.amountPesewas,
  });

  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



      /// Signed pesewas. Positive credits the wallet, negative debits it.
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReceiptLine &&
      other.label == label &&
      other.amountPesewas == amountPesewas;

    @override
    int get hashCode =>
        label.hashCode +
        amountPesewas.hashCode;

  factory ReceiptLine.fromJson(Map<String, dynamic> json) => _$ReceiptLineFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptLineToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

