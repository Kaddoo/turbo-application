/// Turns what someone typed in cedis, such as `12`, `12.5` or `12.50`, into
/// integer pesewas. No floating point. Null when it is not a plain amount.
int? parsePesewas(String input) {
  final s = input.trim().replaceAll(',', '');
  final m = RegExp(r'^(\d{1,7})(?:\.(\d{1,2}))?$').firstMatch(s);
  if (m == null) return null;
  final cedis = int.parse(m.group(1)!);
  final frac = (m.group(2) ?? '').padRight(2, '0');
  return cedis * 100 + int.parse(frac.isEmpty ? '0' : frac);
}

/// Limits from decision D20 (GH₵5 to GH₵500). The server decides; these only
/// stop an obviously wrong entry before it is sent.
const topupMinPesewas = 500;
const topupMaxPesewas = 50000;

const topupChipsPesewas = [1000, 2000, 5000, 10000];
