/** Money is integer pesewas everywhere; formatting happens only here, with integer maths. */
export function formatPesewas(pesewas: number): string {
  const sign = pesewas < 0 ? '-' : '';
  const abs = Math.abs(Math.trunc(pesewas));
  const cedis = Math.floor(abs / 100).toLocaleString('en-GH');
  const rest = String(abs % 100).padStart(2, '0');
  return `${sign}GH₵${cedis}.${rest}`;
}

/** Parses a cedi amount typed by staff ("35", "35.5", "35.50") into pesewas without floats. */
export function parseCedis(input: string): number | null {
  const m = input.trim().match(/^(-)?(\d{1,7})(?:\.(\d{1,2}))?$/);
  if (!m) return null;
  const cedis = Number(m[2]);
  const pesewas = Number((m[3] ?? '').padEnd(2, '0'));
  const value = cedis * 100 + pesewas;
  return m[1] ? -value : value;
}

const TZ = 'Africa/Accra';

export function formatDateTime(iso: string | null | undefined): string {
  if (!iso) return '—';
  return new Intl.DateTimeFormat('en-GB', {
    timeZone: TZ, day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit',
  }).format(new Date(iso));
}

export function formatDate(iso: string | null | undefined): string {
  if (!iso) return '—';
  return new Intl.DateTimeFormat('en-GB', { timeZone: TZ, day: 'numeric', month: 'short', year: 'numeric' })
    .format(new Date(iso));
}

export function formatTime(iso: string | null | undefined): string {
  if (!iso) return '—';
  return new Intl.DateTimeFormat('en-GB', { timeZone: TZ, hour: '2-digit', minute: '2-digit' }).format(new Date(iso));
}

/** "3 min ago", "2 h ago", "4 days ago". */
export function formatRelative(iso: string | null | undefined, now = Date.now()): string {
  if (!iso) return '—';
  const s = Math.round((now - new Date(iso).getTime()) / 1000);
  if (s < 0) {
    const f = -s;
    if (f < 3600) return `in ${Math.max(1, Math.round(f / 60))} min`;
    if (f < 86400) return `in ${Math.round(f / 3600)} h`;
    return `in ${Math.round(f / 86400)} days`;
  }
  if (s < 60) return `${s} s ago`;
  if (s < 3600) return `${Math.round(s / 60)} min ago`;
  if (s < 86400) return `${Math.round(s / 3600)} h ago`;
  const d = Math.round(s / 86400);
  return `${d} day${d === 1 ? '' : 's'} ago`;
}

/** Phone numbers are shown masked by default: +233 24 *** 4567. */
export function maskPhone(e164: string | null | undefined): string {
  if (!e164) return '—';
  const m = e164.match(/^\+233(\d{2})(\d{3})(\d{4})$/);
  return m ? `+233 ${m[1]} *** ${m[3]}` : e164;
}

export function formatPhone(e164: string | null | undefined): string {
  if (!e164) return '—';
  const m = e164.match(/^\+233(\d{2})(\d{3})(\d{4})$/);
  return m ? `+233 ${m[1]} ${m[2]} ${m[3]}` : e164;
}

export function formatKm(meters: number): string {
  return `${(Math.round(meters / 100) / 10).toFixed(1)} km`;
}

export function formatMinutes(min: number): string {
  const h = Math.floor(min / 60);
  const m = min % 60;
  return h ? `${h} h ${String(m).padStart(2, '0')} min` : `${m} min`;
}

/** snake_case enum value -> "Sentence case". */
export function humanize(value: string | null | undefined): string {
  if (!value) return '—';
  const s = value.replace(/_/g, ' ');
  return s.charAt(0).toUpperCase() + s.slice(1);
}

export function shortId(id: string): string {
  return id.slice(0, 8);
}
