/**
 * THE ONLY FILE WITH RAW BRAND VALUES. A rebrand edits this file (and the font
 * imports below). Everything else reads semantic roles through CSS variables
 * built by `src/theme/theme.ts`.
 *
 * Values come from the Turbo landing page (https://turbo-lake.vercel.app/):
 * ink, paper, the `turbo` neon, Geist Sans and Geist Mono, pill buttons.
 */
import geistSans from '../../node_modules/geist/dist/fonts/geist-sans/Geist-Variable.woff2?url';
import geistMono from '../../node_modules/geist/dist/fonts/geist-mono/GeistMono-Variable.woff2?url';

/** Semantic roles for one colour scheme. Names follow `prompts/00-shared-rules.md`. */
export interface BrandPalette {
  background: string;
  surface: string;
  surfaceRaised: string;
  /** Dividers and card edges. */
  border: string;
  /** Edges of inputs and secondary buttons; must reach 3:1 on background and surface. */
  controlBorder: string;
  textPrimary: string;
  textSecondary: string;
  /** The single main action per screen. Fill only. */
  accent: string;
  onAccent: string;
  /** Accent used as text, icon or link. */
  accentText: string;
  /** Edge round an accent fill, needed where the fill fails 3:1 against the page. */
  accentBorder: string;
  focusRing: string;
  success: string;
  warning: string;
  danger: string;
}

export interface BrandFont {
  family: string;
  url: string;
  /** Variable font weight range, e.g. "100 900". */
  weights: string;
  fallback: string;
}

export interface Brand {
  appName: string;
  /** Text placeholder where a logo will go. */
  wordmark: string;
  ink: string;
  neon: string;
  fonts: { sans: BrandFont; mono: BrandFont };
  /** Type sizes in px, converted to rem by the theme so text scales with the browser. */
  typeScale: { display: number; title: number; bodyLarge: number; body: number; caption: number };
  /** Corner radii in px. */
  radius: { card: number; input: number; full: number };
  dark: BrandPalette;
  light: BrandPalette;
}

const ink = '#0B0C0A';
const ink2 = '#141612';
const ink3 = '#1D201A';
const paper = '#F3F1EA';
const paper2 = '#E8E5DB';
const neon = '#D4FF3A';

export const turboBrand: Brand = {
  appName: 'Turbo',
  wordmark: 'Turbo',
  ink,
  neon,
  fonts: {
    sans: {
      family: 'Geist',
      url: geistSans,
      weights: '100 900',
      fallback: 'ui-sans-serif, system-ui, sans-serif',
    },
    mono: {
      family: 'Geist Mono',
      url: geistMono,
      weights: '100 900',
      fallback: 'ui-monospace, SFMono-Regular, Menlo, monospace',
    },
  },
  typeScale: { display: 28, title: 22, bodyLarge: 17, body: 15, caption: 13 },
  radius: { card: 16, input: 12, full: 9999 },
  dark: {
    background: ink,
    surface: ink2,
    surfaceRaised: ink3,
    border: '#232423',
    controlBorder: '#797978',
    textPrimary: paper,
    textSecondary: '#969590',
    accent: neon,
    onAccent: ink,
    accentText: neon,
    accentBorder: 'transparent',
    focusRing: neon,
    success: '#4CC38A',
    warning: '#F5A524',
    danger: '#FF6B5E',
  },
  light: {
    background: paper,
    surface: paper2,
    surfaceRaised: '#FFFFFF',
    border: '#D7D6CF',
    controlBorder: '#686864',
    textPrimary: ink,
    textSecondary: '#5C5C58',
    accent: neon,
    onAccent: ink,
    accentText: ink,
    accentBorder: ink,
    focusRing: ink,
    success: '#0F6E50',
    warning: '#A3400A',
    danger: '#B42318',
  },
};
