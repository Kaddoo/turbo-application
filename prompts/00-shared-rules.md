# Shared rules for every Turbo surface

Give your coding agent **this file plus one surface file** (`01` to `05`). Everything here applies to all five.
The brand guide does not exist yet. Build with the interim black-and-neon theme below; when a guide lands, only the brand layer changes (see "What the swap can and cannot absorb").

## What Turbo is

Cashless, wallet-based ride-hailing for verified Central University students at the Miotso campus (Prampram, Ghana). Students book a ride toward Ashaiman China Mall, pay from an in-app wallet, and watch a salaried driver arrive. Drivers are assigned automatically. Staff run everything from a web dashboard. Product name is a working name: **Turbo**. Do not invent a logo; use a plain text wordmark placeholder.

## Source of truth

- The API contract: `api/openapi.yaml` (0.2.0). It wins over anything written in a prompt. If a prompt and the contract disagree, follow the contract and note it in `LOG.md`.
- Business rules: `docs/04-business-rules.md`. Lifecycles: `docs/03-domain-and-state-machines.md`. Decisions still open: `docs/01-open-decisions.md` (build against the stated defaults).
- Run the mock and build against it from day one: `cd api && npx @stoplight/prism-cli mock openapi.yaml` (http://localhost:4010). Any bearer token works on the mock. Some new 0.2.0 schemas return placeholder strings.
- Generate the API client from the contract (Dart: `openapi-generator-cli -g dart-dio`; TypeScript: `openapi-typescript`). Never hand-edit generated code and never hand-type request or response shapes.
- Need a field or endpoint that is not in the contract? Stop and propose a change to `openapi.yaml` in its own pull request. Do not invent endpoints.

## Rules that apply everywhere

1. **Money** is an integer number of pesewas. Format only at the edge: `3500` shows as `GH₵35.00`. Never use floating point for money.
2. **Times** arrive in UTC (ISO 8601). Display in Africa/Accra. Ghana has no daylight saving.
3. **Errors**: the API returns RFC 9457 problem details with a stable `code`. Switch on `code`, never on the message. Show a plain-language sentence that says what happened and what the person can do. No stack traces, no raw codes in the UI.
4. **Idempotency**: every request with an `Idempotency-Key` header (booking, top-up, adjustments, SMS) gets one UUID per user intention, kept and reused if the request is retried. A new key only for a new intention.
5. **App version**: send `X-App-Version: <platform>/<semver>` on every request. On start and on resume call `GET /app-config`: below `minVersion` show a blocking update screen; `maintenance.active` shows a maintenance screen; `bookingsPaused` shows the pause message and disables booking. A 426 with code `upgrade_required` does the same.
6. **Rate limits**: any call can return 429 with `Retry-After`. Back off and show a calm message. Never retry in a tight loop.
7. **Terms**: if the API returns 403 `terms_not_accepted`, show the current terms from `GET /legal` and call `POST /me/terms-acceptance`.
8. **Every screen has four states designed and built**: loading (skeleton, not a spinner, if longer than 300 ms), empty (teaches and offers one action), error (what happened, how to retry), and the full state. A screen without them is not done.
9. **Accessibility is part of done**: dark mode, readable contrast (4.5:1 text, 3:1 large text and controls), minimum 44 by 44 pt tap targets, screen reader labels on every control, status never shown by colour alone, respects reduced motion, text scales to 200% without clipping.
10. **Copy is plain English**, short, no jargon, no exclamation marks, no emoji. Write like a helpful person at the campus transport office. Ghanaian context: amounts in cedis, phone numbers shown as `+233 24 123 4567`.
11. **Network is poor and expensive.** Light screens, cached last-known data with a "last updated" marker, no auto-playing media, images compressed.
12. **Secrets and personal data**: never log tokens, OTPs, document URLs or full phone numbers. Identity documents are only ever shown through short-lived signed URLs.
13. **Done means**: behaviour matches the contract against the mock; errors show the right message by `code`; the four states exist; a `LOG.md` entry is added (template in `docs/05-work-plan.md`); no brand assets invented.

## Interim theme: black and neon (replaced when a brand guide exists)

Turbo's two brand colours are **black and neon**. No brand guide exists and the shareholders have not chosen one, so we build now and make the look swappable. The exact neon is not confirmed: `#C6FF00` (lime) is an **assumption** used everywhere below. Changing it is a one-line edit.

**Three layers, and components may only touch the third.**

1. **Brand layer (raw values, the only file that changes at rebrand):** app name, wordmark and logo assets, the two brand colours, font family, corner radius scale, support contact strings. One file per codebase (`brand_tokens.dart`, `brand.ts`, `brand.css`).
2. **Semantic layer (built from the brand layer):** the roles in the table below. Light and dark both defined.
3. **Components:** read semantic roles only. **No colour literal, font size, radius or product-name string anywhere in screens or components.** A test or lint rule fails the build if one appears.

| Role | Dark (default design) | Light | Use |
| --- | --- | --- | --- |
| background | #0A0A0A | #FFFFFF | page |
| surface | #141414 | #F4F4F2 | cards, sheets |
| surfaceRaised | #1E1E1E | #FFFFFF | dialogs, menus |
| border | #2E2E2E | #D6D6D2 | dividers |
| textPrimary | #F5F5F5 | #0A0A0A | body, titles |
| textSecondary | #A8A8A8 | #5A5A5A | captions |
| accent | #C6FF00 | #C6FF00 | the single main action per screen (fill only) |
| onAccent | #0A0A0A | #0A0A0A | text and icons on accent |
| accentText | #C6FF00 | #0A0A0A | accent used as text, icon or link |
| focusRing | #C6FF00 | #0A0A0A | keyboard and screen-reader focus |
| success | #4CC38A | #12805C | confirmed, on duty |
| warning | #F5A524 | #B54708 | attention |
| danger | #FF6B5E | #D92D20 | errors, SOS, destructive |

**Rules that come from the colours (do not skip):**

- **Neon on white fails accessibility.** Contrast is about 1.2:1. So neon is only ever a **fill with black text on it** (16:1, passes), or text and icons on dark surfaces. On light backgrounds a neon button gets a 1.5 px black border (its edge would otherwise be invisible), and neon is never used as text or a thin icon there (`accentText` becomes black).
- **Dark first.** Design and review in dark mode (rides are often at night and the brand is black); light mode follows the system setting and is built from the same roles.
- **One neon element per screen**, the main action. Neon everywhere reads cheap and removes the signal.
- Status is never colour alone (icon plus word).

Type: platform default sans (system font) until a typeface is chosen, in sizes 28 / 22 / 17 / 15 / 13 with line height 1.3 to 1.5, weights 400 and 600 only. Spacing unit 4 (use 4, 8, 12, 16, 24, 32). Corner radius 12 for cards, 8 for inputs, full for chips and buttons. Elevation: borders instead of shadows. One outline icon set. Wordmark: the text "Turbo" in the semibold weight, as an image-free placeholder read from the brand layer.

**What the swap can and cannot absorb.** A brand guide that changes colours, typeface, radius, logo, icon set or the product name is a one-file change. A guide that changes layout, navigation, iconography style or motion language is real redesign work. Build so the first list is cheap and do not pretend the second is.

## Standard component set (build once, reuse)

Primary / secondary / destructive button · text field with inline error · OTP field (6 digits, paste and auto-advance) · money text · status chip · list row · card · bottom sheet or modal · toast with undo where possible · skeleton · empty state (icon, one sentence, one action) · error state (sentence, retry) · confirm dialog (type-to-confirm only for the irreversible) · map container · timeline.

## If you are generating screens in a design tool (Stitch, Figma, v0)

One screen and one state per generation. Paste the interim theme table above into every prompt (screens drift otherwise). Never describe animation. Use the real sample text given in the surface file, never lorem ipsum. Template:

```
Screen: <name>
Purpose: <one sentence>
Primary action: <exactly one>
State: <loading | empty | full | error | other>
Content: <elements in priority order with real sample text>
Tokens: <paste the interim theme table>
Layout: <navigation model, fixed vs scrolling, safe areas>
Platform: <iOS | Android | web> · <phone | desktop>
```

The screen blocks in each surface file are written to drop straight into this template.
