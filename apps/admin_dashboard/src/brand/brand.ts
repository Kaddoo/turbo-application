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
  /** Start and end of the accent gradient on hero cards; text on it is `onAccent`. */
  heroFrom: string;
  heroTo: string;
  /** Dims the page behind dialogs, drawers and sheets. */
  scrim: string;
  /** Lift for popovers, menus and dialogs. */
  shadow: string;
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
  typeScale: {
    /** The one big number on a panel. */
    hero: number;
    display: number;
    title: number;
    bodyLarge: number;
    body: number;
    caption: number;
    /** Badges, axis labels and over-lines. */
    micro: number;
  };
  /** Corner radii in px. */
  radius: { panel: number; card: number; input: number; small: number; full: number };
  /** Spacing steps in px. Every gap, padding and margin uses one of these. */
  space: { 1: number; 2: number; 3: number; 4: number; 5: number; 6: number; 8: number; 10: number; 12: number };
  /** Fixed sizes of the shell, in px. */
  layout: {
    sidebar: number;
    sidebarCollapsed: number;
    topBar: number;
    bottomNav: number;
    /** Smallest touch target. */
    target: number;
    contentMax: number;
  };
  /** Transition durations in ms. */
  motion: { fast: number; base: number };
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
  typeScale: { hero: 64, display: 36, title: 22, bodyLarge: 17, body: 15, caption: 13, micro: 12 },
  radius: { panel: 22, card: 18, input: 10, small: 6, full: 9999 },
  space: { 1: 4, 2: 8, 3: 12, 4: 16, 5: 20, 6: 24, 8: 32, 10: 40, 12: 48 },
  layout: { sidebar: 256, sidebarCollapsed: 80, topBar: 80, bottomNav: 64, target: 44, contentMax: 1680 },
  motion: { fast: 120, base: 200 },
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
    heroFrom: neon,
    heroTo: '#8FCC1F',
    scrim: 'rgba(5, 6, 4, 0.72)',
    shadow: '0 16px 40px rgba(0, 0, 0, 0.5)',
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
    heroFrom: neon,
    heroTo: '#A8E02A',
    scrim: 'rgba(11, 12, 10, 0.45)',
    shadow: '0 16px 40px rgba(11, 12, 10, 0.16)',
  },
};
