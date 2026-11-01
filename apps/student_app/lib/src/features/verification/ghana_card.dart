import 'package:flutter/services.dart';

final _pattern = RegExp(r'^GHA-[0-9]{9}-[0-9]$');

bool isValidGhanaCardNumber(String value) => _pattern.hasMatch(value);

/// Formats what was typed as `GHA-123456789-0`. Accepts it with or without the
/// prefix and dashes, in any case.
String formatGhanaCardNumber(String input) {
  var s = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  if (s.startsWith('GHA')) s = s.substring(3);
  s = s.replaceAll(RegExp(r'[^0-9]'), '');
  if (s.length > 10) s = s.substring(0, 10);
  if (s.isEmpty) return input.isEmpty ? '' : 'GHA-';
  final body = s.length > 9 ? '${s.substring(0, 9)}-${s.substring(9)}' : s;
  return 'GHA-$body';
}

class GhanaCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Let the person delete the prefix back to empty.
    if (newValue.text.isEmpty) return newValue;
    final text = formatGhanaCardNumber(newValue.text);
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
