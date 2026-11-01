import { describe, expect, it } from 'vitest';
import { turboBrand, type BrandPalette } from '@/brand/brand';

function channel(v: number): number {
  const c = v / 255;
  return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
}

function luminance(hex: string): number {
  const h = hex.replace('#', '');
  const [r, g, b] = [0, 2, 4].map((i) => channel(parseInt(h.slice(i, i + 2), 16)));
  return 0.2126 * r! + 0.7152 * g! + 0.0722 * b!;
}

export function contrast(a: string, b: string): number {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi! + 0.05) / (lo! + 0.05);
}

function check(name: string, p: BrandPalette) {
  describe(name, () => {
    it('text on every surface reaches 4.5:1', () => {
      for (const bg of [p.background, p.surface, p.surfaceRaised]) {
        for (const role of ['textPrimary', 'textSecondary', 'accentText', 'success', 'warning', 'danger'] as const) {
          expect(contrast(p[role], bg), `${role} on ${bg}`).toBeGreaterThanOrEqual(4.5);
        }
      }
    });

    it('accent, danger and warning fills carry readable text', () => {
      expect(contrast(p.onAccent, p.accent)).toBeGreaterThanOrEqual(4.5);
      expect(contrast(p.background, p.danger)).toBeGreaterThanOrEqual(4.5);
      expect(contrast(p.background, p.warning), 'environment badge').toBeGreaterThanOrEqual(4.5);
    });

    it('control edges and focus ring reach 3:1', () => {
      for (const bg of [p.background, p.surface]) {
        expect(contrast(p.controlBorder, bg)).toBeGreaterThanOrEqual(3);
        expect(contrast(p.focusRing, bg)).toBeGreaterThanOrEqual(3);
      }
    });

    it('accent button edge is visible where the fill is not', () => {
      if (contrast(p.accent, p.background) < 3) {
        expect(contrast(p.accentBorder, p.background)).toBeGreaterThanOrEqual(3);
      }
    });
  });
}

check('turbo dark', turboBrand.dark);
check('turbo light', turboBrand.light);

it('neon on paper fails, which is why light accentText is ink', () => {
  expect(contrast(turboBrand.neon, turboBrand.light.background)).toBeLessThan(3);
  expect(turboBrand.light.accentText).toBe(turboBrand.ink);
});
