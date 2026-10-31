# Prompt 03: Student web app

Owner: Kevin. Give the agent `00-shared-rules.md`, `04-student-mobile-app.md` (for screen behaviour) and this file. This is the **Flutter web build of the same codebase** as the student mobile app, limited in scope: account, booking, wallet and history. If anything below conflicts with prompt 04, this file wins for the web build.

## Job

Let a verified student who is at a laptop or on a phone browser book a ride, top up and check history without installing the app. It is a convenience, not the main product.

## Scope

In: sign in, terms, verification **status** (not capture), booking (destination, quote, confirm), searching, assigned (PIN, driver, plate, live map), in trip view, trip done and rating, cancel, wallet and top-up, transactions, activity and receipts, profile (devices, deletion request), support tickets, safety page with SOS and trip share, trusted contacts.

Out of v1 web (confirm with Turbo, open item in `docs/05`): **identity document capture and selfie** (send the student to the app: "To verify your identity, open the Turbo app. Camera capture works best on your phone."), push notifications (use polling every 3 to 5 seconds on active rides and refresh on focus), background anything.

Safety note: SOS on the web works only while the page is open and has location permission. Say so on the safety page and recommend the app for rides.

## Web-specific requirements

- **Sign-in**: `clientType: web`; the refresh token comes as an httpOnly cookie, so never store it; keep the access token in memory. OTP request requires a `captchaToken` (an invisible challenge) and a `deviceId` stored in local storage. Show a friendly "Checking you're a person…" state.
- **Sessions**: the app must survive a page reload by calling `POST /auth/refresh` first; show a skeleton, not a login flash.
- **Responsive layout**: designed for a phone browser width first (360 to 430), then two-column on tablets and desktop (map on one side, panel on the other, max content width 1100). Booking on desktop uses a left panel with a persistent map.
- **Maps**: Google Maps JS through the Flutter plugin; keyboard operable controls; a text list alternative for pickup points.
- **Navigation**: real URLs (`/ride`, `/wallet`, `/activity`, `/profile`, `/safety`), back button works, deep link to an active ride, refresh keeps place. Use path URLs (not hash) and make the hosting fall back to the app for unknown routes.
- **Performance**: tree-shaken build, deferred loading of maps and heavy screens, a lightweight splash. Target usable in under 5 seconds on a mid-range phone on mobile data. Use the CanvasKit or Skwasm renderer choice that gives the best accessibility result; verify that screen readers can read the content.
- **Accessibility on Flutter web**: enable semantics, ensure focus order, visible focus rings, labels on every control, and test with a screen reader and keyboard only. This is the weak point of Flutter web, so treat it as a first-class requirement and report gaps.
- **Not an installable app**: if a PWA manifest is added, no offline booking; the offline page says so.
- **Payment**: the mobile money prompt arrives on the student's phone, so the waiting screen says "Check your phone" and works well when the browser is the same device (no leaving the page).
- **Security**: strict content security policy, no tokens in URLs or local storage, same-site cookies, clear sign-out that revokes the session, idle timeout of 30 minutes.

## Screens (only where they differ from prompt 04)

**Landing inside the web app (signed out).** Purpose: sign in quickly. Content: wordmark, phone field, "Get the app" link, link to the landing page. 

**Verification status (web).** Same states as the app, plus for `not_submitted` and `needs_attention`: a card explaining that capture happens in the app, with store buttons and a QR code.

**Booking (desktop).** Left panel: pickup, destination, quote, confirm. Right: map. Same codes and messages as the app.

**Active ride (desktop).** Left panel: PIN, driver, plate, quick messages, cancel, share, SOS. Right: live map.

**Wallet and top-up (desktop).** Balance and transactions on the left; top-up form and waiting state on the right.

## Screens to generate in a design tool (one state each)

Sign in (phone) · Code · Verification: use the app · Booking desktop with quote · Booking mobile browser with quote · Driver assigned desktop with PIN · Wallet desktop · Top-up waiting on mobile browser · Activity list · Error: update required.

## Done when

A verified test student can book, ride-track, pay and review a ride in a desktop browser and a phone browser against the mock then staging, the page survives a reload mid-ride, keyboard-only and screen-reader use works for the main journey, and every screen has its four states.
