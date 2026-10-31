/// Formats integer pesewas for display: `3500` becomes `GH₵35.00`.
/// No floating point is used anywhere in the path.
String formatPesewas(int pesewas) {
  final negative = pesewas < 0;
  final abs = pesewas.abs();
  final cedis = (abs ~/ 100).toString();
  final grouped = cedis.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final rem = (abs % 100).toString().padLeft(2, '0');
  return '${negative ? '-' : ''}GH₵$grouped.$rem';
}
