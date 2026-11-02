/** One opening window from `ServiceArea.operatingHours` (contract `OperatingWindow`). */
export type OpeningWindow = { dayOfWeek: number; opensAt: string; closesAt: string };

const NAMES = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
/** Week as people read it: Monday first. */
const WEEK = [1, 2, 3, 4, 5, 6, 0];

/**
 * "every day, 06:00–22:00", or "Mon–Fri 06:00–22:00; Sat 08:00–20:00" when days
 * differ. Days with no window are closed and left out. Null when there are no
 * windows at all (the contract's `null` means hours are not set).
 */
export function formatHours(windows: readonly OpeningWindow[] | null | undefined): string | null {
  if (!windows?.length) return null;
  const perDay = new Map<number, string>();
  for (const day of WEEK) {
    const today = windows
      .filter((w) => w.dayOfWeek === day)
      .sort((a, b) => a.opensAt.localeCompare(b.opensAt))
      .map((w) => `${w.opensAt}–${w.closesAt}`);
    if (today.length) perDay.set(day, today.join(", "));
  }
  if (!perDay.size) return null;

  const groups: { days: number[]; text: string }[] = [];
  let prev: number | null = null;
  for (const day of WEEK) {
    const text = perDay.get(day);
    const last = groups[groups.length - 1];
    if (text && last && last.text === text && prev !== null && perDay.get(prev) === text) last.days.push(day);
    else if (text) groups.push({ days: [day], text });
    prev = text ? day : null;
  }

  if (groups.length === 1 && groups[0].days.length === 7) return `every day, ${groups[0].text}`;
  return groups
    .map(({ days, text }) => {
      const first = NAMES[days[0]];
      const range = days.length === 1 ? first : `${first}–${NAMES[days[days.length - 1]]}`;
      return `${range} ${text}`;
    })
    .join("; ");
}
