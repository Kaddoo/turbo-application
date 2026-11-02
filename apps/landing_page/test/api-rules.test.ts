// Run: npm test (node --test, no build needed)
import assert from "node:assert/strict";
import { test } from "node:test";
import { mockAppConfig, mockLegal, mockServiceArea } from "../src/api/mock.ts";
import { appConfigIssues, legalIssues, serviceAreaIssues } from "../src/lib/guards.ts";
import { formatHours } from "../src/lib/hours.ts";
import { publishedUrl } from "../src/lib/legal.ts";
import { fromResponse, fromThrown, isRetryable, problemText } from "../src/lib/problems.ts";

test("the mock answers match the contract checks", () => {
  assert.deepEqual(serviceAreaIssues(mockServiceArea), []);
  assert.deepEqual(legalIssues(mockLegal), []);
  assert.deepEqual(appConfigIssues(mockAppConfig), []);
});

test("staging's real answers (2026-11-02) pass the checks", () => {
  const live = {
    version: 4,
    boundary: { type: "Polygon", coordinates: [] },
    pickupPoints: [{ id: "3d2c", name: "Central Gate", point: { lat: 5.72, lng: 0.07 }, isActive: true }],
    maxTripDistanceMeters: 18000,
    fareBands: [{ upToMeters: 3000, farePesewas: 1800 }],
  };
  assert.deepEqual(serviceAreaIssues(live), [], "operatingHours may be left out");
  assert.deepEqual(legalIssues({ termsVersion: "1.0", privacyVersion: "1.0", termsUrl: "https://x/t", privacyUrl: "https://x/p" }), []);
});

test("the old hand-written shapes are reported, not guessed at", () => {
  const old = {
    fareBands: [{ maxDistanceMeters: 3000, fareMinor: 1800 }],
    maxTripDistanceMeters: 15000,
    pickupPoints: [{ id: "cu-main-gate", name: "CU Main Gate" }],
  };
  assert.deepEqual(serviceAreaIssues(old), ["version", "fareBands[0].upToMeters", "fareBands[0].farePesewas", "pickupPoints[0].isActive"]);
  assert.deepEqual(legalIssues({ terms: { url: null, version: "1.0" }, privacy: {} }), ["termsVersion", "privacyVersion", "termsUrl", "privacyUrl"]);
  assert.deepEqual(appConfigIssues({ maintenance: { active: false } }), ["bookingsPaused", "minVersion"]);
  assert.deepEqual(serviceAreaIssues(null), ["body is not an object"]);
});

test("opening hours read like a person would say them", () => {
  assert.equal(formatHours(null), null);
  assert.equal(formatHours([]), null);
  const everyDay = [0, 1, 2, 3, 4, 5, 6].map((dayOfWeek) => ({ dayOfWeek, opensAt: "06:00", closesAt: "22:00" }));
  assert.equal(formatHours(everyDay), "every day, 06:00–22:00");
  assert.equal(formatHours(mockServiceArea.operatingHours), "Mon–Fri 06:00–22:00; Sat–Sun 08:00–20:00");
  // Closed on Wednesday breaks the run; two windows on one day are both shown.
  const gaps = [
    { dayOfWeek: 1, opensAt: "06:00", closesAt: "22:00" },
    { dayOfWeek: 2, opensAt: "06:00", closesAt: "22:00" },
    { dayOfWeek: 4, opensAt: "06:00", closesAt: "22:00" },
    { dayOfWeek: 5, opensAt: "16:00", closesAt: "22:00" },
    { dayOfWeek: 5, opensAt: "06:00", closesAt: "12:00" },
  ];
  assert.equal(formatHours(gaps), "Mon–Tue 06:00–22:00; Thu 06:00–22:00; Fri 06:00–12:00, 16:00–22:00");
});

test("status codes become problems by status and code, never by message", () => {
  assert.deepEqual(fromResponse(429, { code: "rate_limited", retryAfterSeconds: 54 }, null), { status: 429, code: "rate_limited", kind: "rate_limited", retryAfterSeconds: 54 });
  assert.equal(fromResponse(429, {}, "30").retryAfterSeconds, 30, "falls back to the Retry-After header");
  assert.equal(fromResponse(503, { code: "service_busy" }, null).kind, "busy");
  assert.equal(fromResponse(426, { code: "upgrade_required" }, null).kind, "upgrade");
  assert.equal(fromResponse(400, {}, null).kind, "bad_request");
  assert.equal(fromResponse(422, { code: "validation_failed" }, null).kind, "bad_request");
  assert.equal(fromResponse(401, {}, null).kind, "unauthorized");
  assert.equal(fromResponse(403, {}, null).kind, "forbidden");
  assert.equal(fromResponse(404, {}, null).kind, "not_found");
  assert.equal(fromResponse(409, {}, null).kind, "conflict");
  assert.equal(fromResponse(500, "not json", null).kind, "server");
  assert.equal(fromResponse(418, {}, null).kind, "http");
});

test("thrown errors: leaving is not an error, timeouts and offline are told apart", () => {
  assert.equal(fromThrown({ cancelled: true, timedOut: false, online: true }).kind, "cancelled");
  assert.equal(fromThrown({ cancelled: false, timedOut: true, online: true }).kind, "timeout");
  assert.equal(fromThrown({ cancelled: false, timedOut: false, online: false }).kind, "offline");
  assert.equal(fromThrown({ cancelled: false, timedOut: false, online: true }).kind, "network");
});

test("only problems a retry can fix offer Try again", () => {
  for (const kind of ["offline", "network", "timeout", "rate_limited", "busy", "server"] as const) assert.ok(isRetryable({ kind }), kind);
  for (const kind of ["forbidden", "not_found", "bad_request", "contract_mismatch", "upgrade", "cancelled"] as const) assert.ok(!isRetryable({ kind }), kind);
  assert.equal(problemText({ kind: "rate_limited", retryAfterSeconds: 54 }, "x"), "Too many requests right now. Try again in 54 seconds.");
  assert.equal(problemText({ kind: "network" }, "the current fares"), "We couldn't reach Turbo to load the current fares.");
});

test("legal links: placeholders until an admin publishes the documents", () => {
  assert.equal(publishedUrl("https://turbo.example/terms"), null, "staging's placeholder");
  assert.equal(publishedUrl("http://turbogh.app/terms"), null, "not https");
  assert.equal(publishedUrl("not a url"), null);
  assert.equal(publishedUrl(null), null);
  assert.equal(publishedUrl("https://turbogh.app/terms/"), "https://turbogh.app/terms/");
});
