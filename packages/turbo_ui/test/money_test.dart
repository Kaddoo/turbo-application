import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

void main() {
  test('formats integer pesewas as cedis', () {
    expect(formatPesewas(3500), 'GH₵35.00');
    expect(formatPesewas(0), 'GH₵0.00');
    expect(formatPesewas(5), 'GH₵0.05');
    expect(formatPesewas(1725), 'GH₵17.25');
    expect(formatPesewas(125050), 'GH₵1,250.50');
    expect(formatPesewas(-600), '-GH₵6.00');
    expect(formatPesewas(100000000), 'GH₵1,000,000.00');
  });
}
