/**
 * Mock answers for local builds (`npm run build:mock`). MOCK DATA: not real
 * Turbo prices, places or hours. Each object is checked against the types
 * generated from api/contract/openapi.yaml, so a contract change that breaks
 * the mock fails `npm run lint`. `npm run mock:write` writes them to
 * public/mock-api/; never edit those files by hand.
 */
import type { components } from "./schema";

type S = components["schemas"];
const id = (n: number) => `0190a1b2-0000-7e4f-8a5b-${String(n).padStart(12, "0")}`;

export const mockServiceArea = {
  version: 1,
  boundary: null,
  pickupPoints: [
    { id: id(1), name: "CU Main Gate", point: { lat: 5.77604, lng: 0.08321 }, isActive: true },
    { id: id(2), name: "CU Hostels", point: { lat: 5.7675, lng: 0.0863 }, isActive: true },
    { id: id(3), name: "Miotso Junction", point: { lat: 5.76647, lng: 0.06189 }, isActive: true },
    { id: id(4), name: "Dawhenya", point: { lat: 5.76478, lng: 0.05632 }, isActive: true },
    { id: id(5), name: "Ashaiman China Mall", point: { lat: 5.68437, lng: -0.024 }, isActive: true },
    // Closed: must not appear on the page.
    { id: id(6), name: "Old Lorry Station", point: { lat: 5.7601, lng: 0.0702 }, isActive: false },
  ],
  maxTripDistanceMeters: 18000,
  fareBands: [
    { upToMeters: 3000, farePesewas: 1800 },
    { upToMeters: 6000, farePesewas: 2500 },
    { upToMeters: 12000, farePesewas: 3500 },
    { upToMeters: 18000, farePesewas: 5000 },
  ],
  operatingHours: [1, 2, 3, 4, 5]
    .map((dayOfWeek) => ({ dayOfWeek, opensAt: "06:00", closesAt: "22:00" }))
    .concat([6, 0].map((dayOfWeek) => ({ dayOfWeek, opensAt: "08:00", closesAt: "20:00" }))),
} satisfies S["ServiceArea"];

export const mockLegal = {
  termsVersion: "1.0",
  privacyVersion: "1.0",
  termsUrl: "https://turbo.example/terms/",
  privacyUrl: "https://turbo.example/privacy/",
} satisfies S["LegalVersions"];

export const mockAppConfig = {
  minVersion: { ios: "1.0.0", android: "1.0.0", web: "0.0.0" },
  maintenance: { active: false, message: null },
  bookingsPaused: false,
  pauseMessage: null,
} satisfies S["AppConfig"];
