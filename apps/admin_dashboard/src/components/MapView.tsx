import { useEffect, useRef } from 'react';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

export interface MapMarker {
  id: string;
  lat: number;
  lng: number;
  /** Semantic role name, e.g. 'success' -> var(--color-success). */
  tone: 'success' | 'warning' | 'danger' | 'accent' | 'neutral';
  label: string;
  onClick?: () => void;
}

export interface MapLine {
  id: string;
  points: [number, number][];
  tone: MapMarker['tone'];
}

const roleVar: Record<MapMarker['tone'], string> = {
  success: '--color-success',
  warning: '--color-warning',
  danger: '--color-danger',
  accent: '--color-accent',
  neutral: '--color-text-secondary',
};
const cssVar = (name: string) => getComputedStyle(document.documentElement).getPropertyValue(name).trim();

/** Miotso campus area; used until a boundary exists. */
const DEFAULT_CENTER: [number, number] = [5.7425, 0.0675];

/**
 * Interim map on OpenStreetMap tiles. Google Maps replaces it once Turbo's
 * restricted key exists (decision D7); the props stay the same.
 */
export function MapView({
  markers,
  lines = [],
  boundary,
  height = 420,
  fit = true,
  onMapClick,
}: {
  markers: MapMarker[];
  lines?: MapLine[];
  boundary?: [number, number][] | null;
  height?: number;
  fit?: boolean;
  onMapClick?: (lat: number, lng: number) => void;
}) {
  const clickRef = useRef(onMapClick);
  clickRef.current = onMapClick;
  const el = useRef<HTMLDivElement>(null);
  const map = useRef<L.Map | null>(null);
  const layer = useRef<L.LayerGroup | null>(null);
  const fitted = useRef(false);

  useEffect(() => {
    if (!el.current || map.current) return;
    map.current = L.map(el.current, { zoomControl: true, attributionControl: true }).setView(DEFAULT_CENTER, 13);
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; OpenStreetMap contributors',
    }).addTo(map.current);
    layer.current = L.layerGroup().addTo(map.current);
    map.current.on('click', (e: L.LeafletMouseEvent) => clickRef.current?.(e.latlng.lat, e.latlng.lng));
    return () => {
      map.current?.remove();
      map.current = null;
    };
  }, []);

  useEffect(() => {
    const m = map.current;
    const g = layer.current;
    if (!m || !g) return;
    g.clearLayers();
    const bg = cssVar('--color-background');
    if (boundary?.length) {
      L.polygon(boundary, { color: cssVar('--color-accent-text'), weight: 2, fillOpacity: 0.05 }).addTo(g);
    }
    for (const line of lines) {
      L.polyline(line.points, { color: cssVar(roleVar[line.tone]), weight: 3, dashArray: '6 6' }).addTo(g);
    }
    for (const mk of markers) {
      const c = L.circleMarker([mk.lat, mk.lng], {
        radius: 8,
        color: bg,
        weight: 2,
        fillColor: cssVar(roleVar[mk.tone]),
        fillOpacity: 1,
      })
        .bindTooltip(mk.label)
        .addTo(g);
      if (mk.onClick) c.on('click', mk.onClick);
    }
    if (fit && !fitted.current) {
      const pts: [number, number][] = [
        ...markers.map((x) => [x.lat, x.lng] as [number, number]),
        ...lines.flatMap((x) => x.points),
        ...(boundary ?? []),
      ];
      if (pts.length > 1) {
        m.fitBounds(L.latLngBounds(pts), { padding: [32, 32], maxZoom: 16 });
        fitted.current = true;
      } else if (pts.length === 1) {
        m.setView(pts[0]!, 15);
        fitted.current = true;
      }
    }
  }, [markers, lines, boundary, fit]);

  return (
    <div
      ref={el}
      style={{
        height,
        width: '100%',
        borderRadius: 'var(--radius-card)',
        overflow: 'hidden',
        border: '1px solid var(--color-border)',
      }}
      role="application"
      aria-label="Map"
    />
  );
}
