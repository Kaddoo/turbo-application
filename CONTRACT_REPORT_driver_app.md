# Driver app: what the API must add so the remaining screens show real data

For planning to apply (CLAUDE.md: the apps never edit `api/`). Each item says which screen waits, what is missing, the shape I suggest, and what the app does until then. All four are already in `CONTRACT_REQUESTS.md` (CR-5, CR-6, CR-10, and the approach-road line under CR-9).

Contract today: 0.4.0.

## 1. Document status and the expired-document problem (CR-5) — highest value

**Screens:** home Documents tile ("Valid / Expiring / Expired" with the document's name), the red "Your insurance expired on 12 Oct" banner, and the new Documents list under Me.

**Missing:**
- `DriverProfile` has no documents. `DriverDocument` (type, `expiresOn`) exists only on the admin side (`/admin/drivers/{id}/documents`), and drivers cannot call it.
- `409 document_expired` on `PUT /driver/duty` says only that "a document has expired". It does not say which one or when.

**Suggested:**
```yaml
DriverProfile:
  documents:
    type: array
    items:
      type: object
      required: [type, status]
      properties:
        type:      { enum: [drivers_licence, vehicle_registration, insurance, roadworthy] }  # as DriverDocument.type, minus other and ghana_card
        expiresOn: { type: [string, 'null'], format: date }
        daysLeft:  { type: [integer, 'null'] }     # server-computed, Africa/Accra, negative when expired
        status:    { enum: [valid, expiring, expired] }  # expiring = under 30 days
# no uploadId, no URL: drivers never need the file
```
And on the `document_expired` problem add extension members `documentType` and `expiredOn` (date).

**Why server-side status:** the phone clock can be wrong, and the 30-day rule should live in one place.

## 2. Supervisor and campus security phone numbers (CR-6)

**Screens:** "Call supervisor" on the PIN-locked screen, on the expired-document banner, and on the "This number isn't registered as a driver" sign-in error. Campus security call tile on Help (and the student app's Safety screens).

**Missing:** `GET /app-config` has `minVersion`, `maintenance`, `bookingsPaused`, `pauseMessage` and nothing else.

**Suggested:** add nullable `supervisorPhone` and `campusSecurityPhone` (E.164 strings) to `AppConfig`.

**Until then:** the apps show the 112 emergency number only. The "Call supervisor" buttons are not drawn.

## 3. Ride event times and who cancelled (CR-10)

**Screen:** trip detail timeline (Records → a trip).

**Missing:** `DriverRide` has `assignedAt` and `acknowledgedAt` only.

**Suggested:** nullable `arrivedAt`, `startedAt`, `completedAt`, `cancelledAt` on `DriverRide`, and optionally `cancelledBy` (`student | staff | system | driver`) and `cancelReasonCode`.

**Until then:** later steps show a state ("done") with no time, and a cancelled ride does not say who cancelled.

## 4. Approach-road line (under CR-9)

**Screen:** the map on "Go to pickup" (and the student's "Your driver is on the way").

**Missing:** 0.4.0 added `routePolyline` (pickup → drop-off) but not the driver's approach to the pickup.

**Suggested:** nullable `driverToPickupPolyline` on `DriverRide` and on the student's `Ride` while it is `assigned`, recomputed by the server when the driver is far off the line.

## Not needed from the API

- **Today's shift tile:** `GET /driver/shifts` already exists, so the tile uses it.
- **Dark map style:** a Google Cloud map style, not an API change.
- **Live Activity and widgets (pattern 15):** the first version updates from the app while it runs. Updating while the app is closed would need a push-token endpoint; we can ask for that when we get there.
- **Biometric lock (pattern 13):** on-device only.
