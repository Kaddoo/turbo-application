import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'fixtures/alt_brand.dart';

double _lum(Color c) {
  double ch(double v) => v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

double contrast(Color a, Color b) {
  final l1 = _lum(a), l2 = _lum(b);
  final hi = math.max(l1, l2), lo = math.min(l1, l2);
  return (hi + 0.05) / (lo + 0.05);
}

void _check(String name, BrandPalette p) {
  void text(String what, Color fg, Color bg) =>
      expect(contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: '$name $what');
  void edge(String what, Color fg, Color bg) =>
      expect(contrast(fg, bg), greaterThanOrEqualTo(3.0), reason: '$name $what');

  group(name, () {
    test('text on every surface reaches 4.5:1', () {
      for (final bg in [p.background, p.surface, p.surfaceRaised]) {
        text('textPrimary', p.textPrimary, bg);
        text('textSecondary', p.textSecondary, bg);
        text('accentText', p.accentText, bg);
        text('success', p.success, bg);
        text('warning', p.warning, bg);
        text('danger', p.danger, bg);
      }
    });

    test('accent is a fill with readable text on it', () {
      text('onAccent on accent', p.onAccent, p.accent);
      text('background on danger (onDanger)', p.background, p.danger);
    });

    test('control edges and focus ring reach 3:1', () {
      for (final bg in [p.background, p.surface]) {
        edge('controlBorder', p.controlBorder, bg);
        edge('focusRing', p.focusRing, bg);
      }
    });

    test('accent button edge is visible where the fill is not', () {
      // Where the accent fill fails 3:1 against the page, the border must not.
      if (contrast(p.accent, p.background) < 3) {
        edge('accentBorder', p.accentBorder, p.background);
      }
    });
  });
}

void main() {
  _check('turbo dark', turboBrand.dark);
  _check('turbo light', turboBrand.light);
  _check('alt dark', altBrand.dark);
  _check('alt light', altBrand.light);

  test('neon on white would fail, which is why light accentText is black', () {
    expect(contrast(turboBrand.brandNeon, turboBrand.light.background), lessThan(3));
    expect(turboBrand.light.accentText, turboBrand.brandBlack);
  });
}
