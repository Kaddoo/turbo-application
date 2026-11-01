import type { Brand, BrandPalette } from '@/brand/brand';

/** Semantic role -> CSS custom property name. Components use only these. */
const roleVars: Record<keyof BrandPalette, string> = {
  background: '--color-background',
  surface: '--color-surface',
  surfaceRaised: '--color-surface-raised',
  border: '--color-border',
  controlBorder: '--color-control-border',
  textPrimary: '--color-text-primary',
  textSecondary: '--color-text-secondary',
  accent: '--color-accent',
  onAccent: '--color-on-accent',
  accentText: '--color-accent-text',
  accentBorder: '--color-accent-border',
  focusRing: '--color-focus-ring',
  success: '--color-success',
  warning: '--color-warning',
  danger: '--color-danger',
  heroFrom: '--color-hero-from',
  heroTo: '--color-hero-to',
  scrim: '--color-scrim',
  shadow: '--shadow-raised',
};

const rem = (px: number) => `${px / 16}rem`;

function paletteVars(p: BrandPalette): string {
  return (Object.keys(roleVars) as (keyof BrandPalette)[]).map((role) => `${roleVars[role]}: ${p[role]};`).join('\n  ');
}

/**
 * Builds the stylesheet for a brand: font faces, the dark palette (default),
 * the light palette for `prefers-color-scheme: light` or `data-theme="light"`,
 * type scale, radii and spacing.
 */
export function buildThemeCss(brand: Brand): string {
  const { sans, mono } = brand.fonts;
  const t = brand.typeScale;
  const r = brand.radius;
  const space = Object.entries(brand.space)
    .map(([k, v]) => `--space-${k}: ${rem(v)};`)
    .join('\n  ');
  const l = brand.layout;
  return `
@font-face { font-family: '${sans.family}'; src: url('${sans.url}') format('woff2'); font-weight: ${sans.weights}; font-display: swap; }
@font-face { font-family: '${mono.family}'; src: url('${mono.url}') format('woff2'); font-weight: ${mono.weights}; font-display: swap; }
:root {
  color-scheme: dark;
  ${paletteVars(brand.dark)}
  --font-sans: '${sans.family}', ${sans.fallback};
  --font-mono: '${mono.family}', ${mono.fallback};
  --text-hero: ${rem(t.hero)};
  --text-display: ${rem(t.display)};
  --text-title: ${rem(t.title)};
  --text-body-large: ${rem(t.bodyLarge)};
  --text-body: ${rem(t.body)};
  --text-caption: ${rem(t.caption)};
  --text-micro: ${rem(t.micro)};
  --radius-panel: ${r.panel}px;
  --radius-card: ${r.card}px;
  --radius-input: ${r.input}px;
  --radius-small: ${r.small}px;
  --radius-full: ${r.full}px;
  ${space}
  --size-sidebar: ${rem(l.sidebar)};
  --size-sidebar-collapsed: ${rem(l.sidebarCollapsed)};
  --size-top-bar: ${rem(l.topBar)};
  --size-bottom-nav: ${rem(l.bottomNav)};
  --size-target: ${rem(l.target)};
  --size-content-max: ${rem(l.contentMax)};
  --motion-fast: ${brand.motion.fast}ms;
  --motion-base: ${brand.motion.base}ms;
}
@media (prefers-color-scheme: light) {
  :root:not([data-theme="dark"]) { color-scheme: light; ${paletteVars(brand.light)} }
}
:root[data-theme="light"] { color-scheme: light; ${paletteVars(brand.light)} }
`;
}

/** Injects the theme once at start-up. */
export function applyTheme(brand: Brand): void {
  const id = 'brand-theme';
  let el = document.getElementById(id) as HTMLStyleElement | null;
  if (!el) {
    el = document.createElement('style');
    el.id = id;
    document.head.prepend(el);
  }
  el.textContent = buildThemeCss(brand);
}
