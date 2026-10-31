# Turbo API contract

`openapi.yaml` is **OpenAPI 3.1**, version `0.2.0` (draft). 135 operations across 22 tags. It lints clean with Redocly.

## Use it

```bash
# Mock server, with example responses (new 0.2.0 schemas still return placeholder strings), on http://localhost:4010
npx @stoplight/prism-cli mock openapi.yaml

# Lint (config in redocly.yaml)
npx @redocly/cli lint openapi.yaml

# Browsable documentation
npx @redocly/cli preview-docs openapi.yaml
```

Try it: `curl localhost:4010/service-area`. Operations that need a token accept any `Authorization: Bearer x` against the mock.
Booking without an `Idempotency-Key` returns 422, exactly as the real API will.

## Generate clients

| Consumer | Tool |
| --- | --- |
| Flutter apps | `openapi-generator-cli generate -g dart-dio -i openapi.yaml -o packages/turbo_api` |
| Admin dashboard | `npx openapi-typescript openapi.yaml -o src/api/schema.d.ts` |

Check the generated Dart client against the `oneOf` and nullable fields early; if the generator struggles, report it and we adjust the contract shape rather than hand-edit generated code.

## Who can call what

Each operation carries `x-roles` (`student`, `driver`, `admin:<staffRole>`, `public`, or `any`) and `x-release` (`v1` or `v1.1`).
Operations tagged `v1.1` are specified but **must not be built** for the first release. `x-internal` marks the payment webhook, which no client calls.

## Error codes

Errors are RFC 9457 problem details. Clients switch on `code`, never on the message text. The full list is the `ProblemCode` schema; the ones apps meet most:

| Code | Meaning | App behaviour |
| --- | --- | --- |
| `verification_required` | Student is not yet approved | Send to verification status screen |
| `outside_service_area` | Pickup or drop-off is outside the boundary | Explain, let the student change a location |
| `route_too_long` | Road distance is over the limit | Explain the limit, let the student change a location |
| `no_drivers_on_duty` | Nobody is available | Show message, offer to retry |
| `insufficient_balance` | Wallet cannot cover the fare | Show shortfall and a top-up button |
| `quote_expired` | Quote older than its life | Re-quote silently and ask to confirm again |
| `active_ride_exists` | Student already has a ride | Open that ride |
| `ride_not_cancellable` | Trip already started | Explain; offer support |
| `invalid_pin` / `pin_locked` | Wrong start PIN / too many tries | Retry / ask staff |
| `idempotency_key_reused` | Same key, different body | Developer error, fix the client |

## Changing the contract

1. Edit `openapi.yaml` in its own pull request. Keep `lint` green.
2. Optional fields and new endpoints are non-breaking. Renames, removals, type changes and tighter validation are breaking: bump the version and get all three approvals.
3. Update `docs/` if the change touches a rule.
4. Merge before the code that depends on it.

## Illustrative values

Coordinates and ids in examples are placeholders, not real campus locations. The boundary is `null` until Turbo approves it (decision D1).

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.2.0 | 2026-10-30 | From the feature audit (`docs/09`). Stuck rides: `POST /admin/rides/{id}/complete`, ride `flags`. Staff accounts: invite accept, MFA confirm, password forgot/reset/change, revoke sessions. Reconciliation: top-up `validation`/`flagged`, `resolve`, statement reports. Wallet adjustments over a threshold need a second approver. Driver `no-show`, quick ride messages, pickup `landmark`. Terms acceptance and `/legal`. Ghana Card number and selfie on verification. `/app-config` and `X-App-Version`/426. Expiring driver documents. Phone change by staff. Verification claim lock. Announcements and `bookingsPaused`. Session list/revoke. 429 on every endpoint. New settings and problem codes. `VerificationDetail` now includes `ghanaCardNumber` for reviewers. **Breaking:** `POST /me/verification` now requires `ghanaCardNumber` and `selfieUploadId` |
| 0.1.1 | 2026-10-30 | Added `payaza` as a webhook provider |
| 0.1.0 | 2026-10-30 | First draft from Turbo's requirements PDF |
