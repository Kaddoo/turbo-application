import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

void main() {
  test('decodes the example from Google\'s documentation', () {
    final p = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    expect(p.length, 3);
    expect(p[0].lat, closeTo(38.5, 1e-9));
    expect(p[0].lng, closeTo(-120.2, 1e-9));
    expect(p[2].lat, closeTo(43.252, 1e-9));
    expect(p[2].lng, closeTo(-126.453, 1e-9));
  });

  test('null, empty and broken text give no line', () {
    expect(decodePolyline(null), isEmpty);
    expect(decodePolyline(''), isEmpty);
    expect(decodePolyline('\u0001\u0002'), isEmpty);
    expect(decodePolyline('_p~iF'), isEmpty);
  });
}
