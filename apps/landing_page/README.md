# Turbo — landing site

The public landing site for Turbo, the campus ride service for verified Central University students at Miotso. It's a static Next.js export: no server, no login, no cookies, no analytics.

## Stack

- **Next.js 16** (App Router, `output: "export"`), so `out/` can be deployed to any static host.
- **Tailwind CSS v4**, **lucide-react** icons, **Geist** fonts (self-hosted through the `geist` package).
- **three.js**: the hero's 3D city with the route and moving car (`src/components/hero/heroScene.ts`). It loads lazily when the browser is idle, and only on screens ≥768px. It is skipped on Save-Data or low-memory devices, which see a static SVG instead. It pauses when off-screen.
- **GSAP + ScrollTrigger** and **Lenis**: word-by-word headline reveals, fade-ups, the pinned horizontal "How it works" (≥1024px), parallax cards, the route-drawing SVG and fare bars. All are loaded after hydration (`src/components/Motion.tsx`) and all are turned off when the visitor prefers reduced motion. If the motion code never loads, content is never left hidden.
- Component patterns (shine button, spotlight bento, marquee, disclosure FAQ) are written by hand in the 21st.dev / shadcn idiom (`cn()` + Tailwind).

## Run

```bash
npm install
npm run dev            # http://localhost:3000, reads the mock API (public/mock-api), so fares and pickup points show
npm run build:mock     # static build against the bundled mock API (public/mock-api)
npm run build          # static build; API from PUBLIC_API_BASE_URL
npm run check          # after a build: axe WCAG 2.1 AA scan, link check, console errors
```

`npm run dev` uses the mock by default. To try another API, set it: `PUBLIC_API_BASE_URL=https://api.example/v1 npm run dev`. To see the no-API fallbacks, use `PUBLIC_API_BASE_URL= npx next dev`.

## Configuration

| What | Where |
| --- | --- |
| API base URL | `PUBLIC_API_BASE_URL` env var (see `.env.example`). Empty means no API calls. |
| Site origin (canonical, OG, sitemap) | `PUBLIC_SITE_URL` |
| Store badges, web app URL, email, WhatsApp, campus security | `src/config/links.ts` (**all placeholders**) |
| Legal version fallback | `src/config/legal.ts` |

## API use (read-only, no tokens)

- `GET /service-area`: fare bands, max trip distance, pickup points, operating hours. Used by Fares, Where we go and Support.
- `GET /legal`: terms and privacy URLs and versions. Used by the footer links and the version labels on the policy pages.
- `GET /app-config`: maintenance state, shown as a banner.

Every call has a 6s timeout. On failure the page still renders completely: Fares shows "Fares are shown in the app before you book.", pickup chips become a sentence, and legal links fall back to the pages hosted here. There is no full-page spinner.

The response shapes are assumed (the shared rules file wasn't supplied). `src/lib/api.ts` parses them tolerantly, so align the field names there once the API contract is final. **The values in `public/mock-api/` are made up for development and are not real prices or places.**

## Pages

`/`, `/privacy/`, `/terms/`, `/delete-account/`, `/support/`, a 404 page, `sitemap.xml`, `robots.txt`, OG/Twitter images and the favicon.

## Open items for Turbo

- Privacy and Terms are **structural drafts** and must be replaced with approved text.
- To confirm: verification time ("usually within a day"), how long account deletion takes, what happens to a remaining wallet balance on deletion, and the campus security number.
- Real store, web app and contact links.
- Interactive map stays off until boundary decision D1 is approved; the corridor drawing is schematic.
