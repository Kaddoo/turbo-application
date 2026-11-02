import { useEffect, useRef, useState } from 'react';

export interface MapMarker {
  id: string;
  lat: number;
  lng: number;
  /** Semantic role name, e.g. 'success' -> var(--color-success). */
  tone: 'success' | 'warning' | 'danger' | 'accent' | 'neutral';
  label: string;
  /** `car` for a vehicle (drivers); `dot` (default) for places and events. */
  kind?: 'car' | 'dot';
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
const DEFAULT_CENTER = { lat: 5.7425, lng: 0.0675 };

const apiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;

let loading: Promise<typeof google.maps> | null = null;

/** Maps on screen that want to hear Google reject the key (it reports that through one global). */
const keyRejected = new Set<() => void>();
(window as unknown as Record<string, unknown>).gm_authFailure = () => keyRejected.forEach((f) => f());

/** Loads the Maps JavaScript API once, on first use, so it stays out of the main bundle. */
function loadGoogleMaps(): Promise<typeof google.maps> {
  if (typeof google !== 'undefined' && google.maps?.Map) return Promise.resolve(google.maps);
  loading ??= new Promise((resolve, reject) => {
    const fail = () => {
      loading = null;
      reject(new Error('Google Maps failed to load'));
    };
    // Google calls this once the API is ready to use.
    (window as unknown as Record<string, unknown>).__turboMapsReady = () => resolve(google.maps);
    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey ?? '')}&v=weekly&callback=__turboMapsReady`;
    script.async = true;
    script.onerror = fail;
    document.head.append(script);
  });
  return loading;
}

/** A filled car in a 24-unit box, centred on (12, 12). */
const CAR_PATH =
  'M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z';

const toLatLng = ([lat, lng]: [number, number]) => ({ lat, lng });

/** Google Maps. Same props as the interim map it replaced. */
export function MapView({
  markers,
  lines = [],
  boundary,
  height = 420,
  fit = true,
  onMapClick,
  className,
}: {
  markers: MapMarker[];
  lines?: MapLine[];
  boundary?: [number, number][] | null;
  height?: number;
  fit?: boolean;
  onMapClick?: (lat: number, lng: number) => void;
  /** Size the map from a stylesheet instead of `height` (for responsive layouts). */
  className?: string;
}) {
  const clickRef = useRef(onMapClick);
  clickRef.current = onMapClick;
  const el = useRef<HTMLDivElement>(null);
  const map = useRef<google.maps.Map | null>(null);
  const overlays = useRef<{ setMap(map: google.maps.Map | null): void }[]>([]);
  const fitted = useRef(false);
  const [ready, setReady] = useState(false);
  const [failed, setFailed] = useState(!apiKey);
  const [rejected, setRejected] = useState(false);

  useEffect(() => {
    if (!apiKey) return;
    let cancelled = false;
    const rejected = () => {
      if (cancelled) return;
      setRejected(true);
      setFailed(true);
    };
    keyRejected.add(rejected);
    loadGoogleMaps().then(
      (maps) => {
        if (cancelled || !el.current) return;
        try {
          map.current = new maps.Map(el.current, {
            center: DEFAULT_CENTER,
            zoom: 13,
            clickableIcons: false,
            fullscreenControl: false,
            streetViewControl: false,
            mapTypeControl: false,
          });
        } catch {
          return setFailed(true);
        }
        map.current.addListener('click', (e: google.maps.MapMouseEvent) => {
          if (e.latLng) clickRef.current?.(e.latLng.lat(), e.latLng.lng());
        });
        setReady(true);
      },
      () => !cancelled && setFailed(true),
    );
    return () => {
      cancelled = true;
      keyRejected.delete(rejected);
      overlays.current.forEach((o) => o.setMap(null));
      overlays.current = [];
      map.current = null;
    };
  }, []);

  useEffect(() => {
    const m = map.current;
    if (!ready || !m) return;
    overlays.current.forEach((o) => o.setMap(null));
    overlays.current = [];
    const bg = cssVar('--color-background');
    if (boundary?.length) {
      overlays.current.push(
        new google.maps.Polygon({
          map: m,
          paths: boundary.map(toLatLng),
          strokeColor: cssVar('--color-accent-text'),
          strokeWeight: 2,
          fillColor: cssVar('--color-accent-text'),
          fillOpacity: 0.08,
          clickable: false,
        }),
      );
    }
    for (const line of lines) {
      overlays.current.push(
        new google.maps.Polyline({
          map: m,
          path: line.points.map(toLatLng),
          strokeOpacity: 0,
          icons: [
            {
              icon: { path: 'M 0,-1 0,1', strokeColor: cssVar(roleVar[line.tone]), strokeOpacity: 1, scale: 3 },
              offset: '0',
              repeat: '12px',
            },
          ],
          clickable: false,
        }),
      );
    }
    for (const mk of markers) {
      const marker = new google.maps.Marker({
        map: m,
        position: { lat: mk.lat, lng: mk.lng },
        title: mk.label,
        icon:
          mk.kind === 'car'
            ? {
                path: CAR_PATH,
                scale: 1.7,
                anchor: new google.maps.Point(12, 12),
                fillColor: cssVar(roleVar[mk.tone]),
                fillOpacity: 1,
                strokeColor: bg,
                strokeWeight: 1.5,
              }
            : {
                path: google.maps.SymbolPath.CIRCLE,
                scale: 8,
                fillColor: cssVar(roleVar[mk.tone]),
                fillOpacity: 1,
                strokeColor: bg,
                strokeWeight: 2,
              },
      });
      if (mk.onClick) marker.addListener('click', mk.onClick);
      overlays.current.push(marker);
    }
    if (fit && !fitted.current) {
      const pts: [number, number][] = [
        ...markers.map((x) => [x.lat, x.lng] as [number, number]),
        ...lines.flatMap((x) => x.points),
        ...(boundary ?? []),
      ];
      if (pts.length > 1) {
        const bounds = new google.maps.LatLngBounds();
        pts.forEach((p) => bounds.extend(toLatLng(p)));
        m.fitBounds(bounds, 32);
        fitted.current = true;
        // fitBounds can zoom in too far on a tight cluster.
        google.maps.event.addListenerOnce(m, 'idle', () => {
          if ((m.getZoom() ?? 0) > 16) m.setZoom(16);
        });
      } else if (pts.length === 1) {
        m.setCenter(toLatLng(pts[0]!));
        m.setZoom(15);
        fitted.current = true;
      }
    }
  }, [ready, markers, lines, boundary, fit]);

  return (
    <div
      className={className}
      style={{
        position: 'relative',
        height: className ? undefined : height,
        width: '100%',
        borderRadius: 'var(--radius-card)',
        overflow: 'hidden',
        border: '1px solid var(--color-border)',
        background: 'var(--color-surface)',
      }}
    >
      <div ref={el} role="application" aria-label="Map" style={{ position: 'absolute', inset: 0 }} />
      {failed && (
        <p
          role="status"
          style={{
            position: 'absolute',
            inset: 0,
            display: 'grid',
            placeItems: 'center',
            margin: 0,
            padding: 'var(--space-6)',
            textAlign: 'center',
            color: 'var(--color-text-secondary)',
            background: 'var(--color-surface)',
          }}
        >
          {!apiKey
            ? 'The map needs a Google Maps key. Set VITE_GOOGLE_MAPS_API_KEY and restart.'
            : rejected
              ? 'Google rejected the map key. Its allowed websites and allowed APIs (Maps JavaScript API) need checking.'
              : 'The map could not load. Check your connection and try again.'}
        </p>
      )}
    </div>
  );
}
