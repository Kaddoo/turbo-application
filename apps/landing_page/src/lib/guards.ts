/**
 * Runtime checks that a 200 body is what api/contract/openapi.yaml says. They
 * do not repair anything: a body that fails is reported (console.error with the
 * field names) and treated as a failed call, so the page falls back instead of
 * guessing. Each returns the list of problems; empty means it matches.
 */

const rec = (v: unknown): Record<string, unknown> | null => (v && typeof v === "object" && !Array.isArray(v) ? (v as Record<string, unknown>) : null);
const isInt = (v: unknown) => typeof v === "number" && Number.isInteger(v);
const isStr = (v: unknown) => typeof v === "string";
const isTime = (v: unknown) => typeof v === "string" && /^[0-2][0-9]:[0-5][0-9]$/.test(v);
const optional = (v: unknown, ok: (x: unknown) => boolean) => v === undefined || v === null || ok(v);

export function serviceAreaIssues(body: unknown): string[] {
  const d = rec(body);
  if (!d) return ["body is not an object"];
  const issues: string[] = [];
  if (!isInt(d.version)) issues.push("version");
  if (!isInt(d.maxTripDistanceMeters)) issues.push("maxTripDistanceMeters");
  if (!Array.isArray(d.fareBands)) issues.push("fareBands");
  else
    d.fareBands.forEach((raw, i) => {
      const b = rec(raw);
      if (!b || !isInt(b.upToMeters) || (b.upToMeters as number) < 1) issues.push(`fareBands[${i}].upToMeters`);
      if (!b || !isInt(b.farePesewas) || (b.farePesewas as number) < 0) issues.push(`fareBands[${i}].farePesewas`);
    });
  if (!Array.isArray(d.pickupPoints)) issues.push("pickupPoints");
  else
    d.pickupPoints.forEach((raw, i) => {
      const p = rec(raw);
      if (!p || !isStr(p.id)) issues.push(`pickupPoints[${i}].id`);
      if (!p || !isStr(p.name)) issues.push(`pickupPoints[${i}].name`);
      if (!p || typeof p.isActive !== "boolean") issues.push(`pickupPoints[${i}].isActive`);
    });
  if (!optional(d.operatingHours, Array.isArray)) issues.push("operatingHours");
  else if (Array.isArray(d.operatingHours))
    d.operatingHours.forEach((raw, i) => {
      const w = rec(raw);
      if (!w || !isInt(w.dayOfWeek) || (w.dayOfWeek as number) < 0 || (w.dayOfWeek as number) > 6) issues.push(`operatingHours[${i}].dayOfWeek`);
      if (!w || !isTime(w.opensAt)) issues.push(`operatingHours[${i}].opensAt`);
      if (!w || !isTime(w.closesAt)) issues.push(`operatingHours[${i}].closesAt`);
    });
  return issues;
}

export function legalIssues(body: unknown): string[] {
  const d = rec(body);
  if (!d) return ["body is not an object"];
  const issues = ["termsVersion", "privacyVersion", "termsUrl", "privacyUrl"].filter((k) => !isStr(d[k]));
  if (!optional(d.locationNoticeUrl, isStr)) issues.push("locationNoticeUrl");
  return issues;
}

export function appConfigIssues(body: unknown): string[] {
  const d = rec(body);
  if (!d) return ["body is not an object"];
  const issues: string[] = [];
  const m = rec(d.maintenance);
  if (!m || typeof m.active !== "boolean") issues.push("maintenance.active");
  else if (!optional(m.message, isStr)) issues.push("maintenance.message");
  if (typeof d.bookingsPaused !== "boolean") issues.push("bookingsPaused");
  if (!optional(d.pauseMessage, isStr)) issues.push("pauseMessage");
  const v = rec(d.minVersion);
  if (!v || !isStr(v.ios) || !isStr(v.android) || !isStr(v.web)) issues.push("minVersion");
  return issues;
}
