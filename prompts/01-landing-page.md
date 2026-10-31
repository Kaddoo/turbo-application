# Prompt 01: Landing page

Owner: Emmanuel. Give the agent `00-shared-rules.md` and this file. No login, no backend of its own.

## Job

Tell a student what Turbo is in ten seconds, show what a ride costs, build trust on safety, and send them to the app or the web app. Also host the public pages the app stores require.

## Build

A fast, static-first site (Astro, or Vite with React, your choice). Server-side nothing. Target: first load under 150 KB of HTML, CSS and JS excluding images, good Lighthouse scores on a mid-range Android phone over slow mobile data. Images in modern formats, lazy-loaded, with fixed dimensions so nothing jumps. Mobile first; most visitors are students on phones. English only for v1.

Read-only API use (no tokens): `GET /service-area` for fare bands, pickup points and operating hours; `GET /legal` for the current terms and privacy URLs and versions; `GET /app-config` for maintenance state. Config via `PUBLIC_API_BASE_URL`. If any call fails, the page must still render completely with the sections that need data hidden or showing static fallback text. Never show a spinner over the whole page.

Placeholder wordmark "Turbo" in text. Store badges and the web app link are placeholders in one `links` config file (`appStoreUrl`, `playStoreUrl`, `webAppUrl`), not hard-coded in components.

## Sections (in order)

| Section | Purpose | Content (use this wording as the starting copy) | Data |
| --- | --- | --- | --- |
| Header | Orient and give the main action | Wordmark, links: How it works, Fares, Safety, FAQ. Button "Get the app" | none |
| Hero | Say what it is | Headline: "Rides around campus, paid from your wallet." Sub: "For verified Central University students at Miotso. No cash, no haggling, a driver assigned for you." Primary button "Get the app"; secondary link "Use on the web" | none |
| How it works | Remove doubt about steps | 1 "Verify once" (Ghana Card and student ID) · 2 "Top up your wallet" (mobile money) · 3 "Book and ride" (pick a destination, see the fare, meet your driver with a 4-digit PIN) | none |
| Fares | Answer the first question everyone has | A simple table of distance bands and prices: "Up to 3 km GH₵18" and so on. Note: "You see the exact fare before you confirm. It never changes after." Trips over the limit are not available | `fareBands`, `maxTripDistanceMeters` from `/service-area` |
| Where we go | Set coverage expectation | "Miotso toward Ashaiman China Mall." List of pickup points as chips. Static illustration or simple map image only; **no interactive map until the boundary is approved (open decision D1)** | `pickupPoints` |
| Safety | Build trust | Verified students only · salaried, vetted drivers · PIN check before every trip · share your trip with trusted contacts · SOS button in the app watched by staff · "We never ask you for your wallet PIN" | none |
| Drivers and wallet | Reassure on money | "Your wallet balance is separate from ride fares until you book. Cancel for free, always, with no penalty." | none |
| FAQ | Cut support load | Who can use it · How verification works and how long it takes (placeholder "usually within a day", confirm with Turbo) · How to top up · What if my driver does not show · Can I cancel · What if I lose my phone · How to delete my account | none |
| Download | Convert | Store badges, "Use on the web" button, QR code of the web app | links config |
| Footer | Legal and contact | Links: Privacy, Terms, Delete my account, Contact. Contact is a mailto and WhatsApp link from config (no form, there is no contact endpoint) | `/legal` |

## Required pages (stores and law)

- **Privacy policy** and **Terms**: render the documents at the URLs returned by `GET /legal`, or host the text here and keep the version label visible ("Version 1.0, updated <date>"). Apple and Google both require a public privacy URL.
- **Delete my account**: a public page explaining the in-app path (Profile, Delete account), what is removed, what is kept (ledger entries are anonymised, not deleted), and how long it takes. Google Play requires a public URL for this.
- **Support/Contact**: email and WhatsApp, operating hours, the campus security number placeholder.
- **404** page with a link home.

## Screens to generate in a design tool (one state each)

1. Home, mobile, full. 2. Home, desktop, full. 3. Fares section with data loaded. 4. Fares section when the API failed (section hidden, replaced by one sentence "Fares are shown in the app before you book."). 5. Delete-my-account page. 6. Privacy page layout.

## Quality bar

- Headings in order, one H1, landmarks, skip link, focus outlines, alt text, contrast, reduced motion respected.
- Open Graph and Twitter tags, a favicon placeholder, `sitemap.xml`, `robots.txt`.
- No cookies, no analytics in v1. If analytics are added later, they need a consent banner first (ask Turbo).
- No invented testimonials, ratings, student counts or press logos. Real numbers only, added later.
- Done when: it renders with the mock and with the API down, passes an accessibility check, and all links resolve.
