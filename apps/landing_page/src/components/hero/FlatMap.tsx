import mapJson from "./mapData.json";

type MapData = {
  nodes: number[];
  roads: { k: string; n: number[] }[];
  areas: { k: string; p: number[] }[];
  tour: number[];
};
const map = mapJson as MapData;

const PAD = 380; // metres shown around the showcase ride
const AREA_FILL: Record<string, string> = { campus: "#17221b", pitch: "#1d3424", water: "#13283b", field: "#161b15", commercial: "#1b1920" };
const ROAD: Record<string, [string, number]> = { service: ["#2a2f34", 5], minor: ["#3a4047", 8], major: ["#5c5640", 15] };

const xy = (n: number) => [Math.round(map.nodes[2 * n]), Math.round(map.nodes[2 * n + 1])] as const;

/**
 * The real streets around the campus as a flat dark map with the showcase
 * ride, drawn at build time (© OpenStreetMap contributors). It is the hero
 * map on phones and wherever WebGL is unavailable. The car waits until
 * HeroStage begins its animateMotion, so it starts as the video ends.
 */
export function FlatMap() {
  const tour = map.tour.map(xy);
  const xs = tour.map((p) => p[0]);
  const zs = tour.map((p) => p[1]);
  const [x0, x1, z0, z1] = [Math.min(...xs) - PAD, Math.max(...xs) + PAD, Math.min(...zs) - PAD, Math.max(...zs) + PAD];
  const inView = (n: number) => {
    const [x, z] = xy(n);
    return x > x0 - 200 && x < x1 + 200 && z > z0 - 200 && z < z1 + 200;
  };

  const roads: Record<string, string> = { service: "", minor: "", major: "" };
  for (const r of map.roads) {
    if (!r.n.some(inView)) continue;
    roads[r.k] += r.n.map((n, i) => `${i ? "L" : "M"}${xy(n).join(" ")}`).join("");
  }
  const route = tour.map((p, i) => `${i ? "L" : "M"}${p.join(" ")}`).join("");
  const [sx, sz] = tour[0];
  const relRoute = tour.map(([x, z], i) => `${i ? "L" : "M"}${x - sx} ${z - sz}`).join("");
  const [ex, ez] = tour[tour.length - 1];

  return (
    <svg
      viewBox={`${x0} ${z0} ${x1 - x0} ${z1 - z0}`}
      preserveAspectRatio="xMidYMid slice"
      className="absolute inset-0 size-full bg-[#141618]"
      aria-hidden
      fill="none"
    >
      {map.areas.map((a, i) => (
        <polygon key={i} points={a.p.map((v) => Math.round(v)).join(" ")} fill={AREA_FILL[a.k] ?? AREA_FILL.field} />
      ))}
      {Object.entries(ROAD).map(([k, [stroke, width]]) => (
        <path key={k} d={roads[k]} stroke={stroke} strokeWidth={width} strokeLinecap="round" strokeLinejoin="round" />
      ))}
      <text x={-330} y={-40} fill="#7f868e" fontSize="30" fontWeight="600">
        Central University
      </text>

      <path d={route} stroke="#d4ff3a" strokeOpacity=".18" strokeWidth="26" strokeLinecap="round" strokeLinejoin="round" />
      <path d={route} stroke="#d4ff3a" strokeWidth="9" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx={sx} cy={sz} r="16" fill="#f3f1ea" />
      <circle cx={sx} cy={sz} r="8" fill="#0b0c0a" />
      <circle cx={ex} cy={ez} r="34" stroke="#d4ff3a" strokeWidth="4" className="origin-center animate-pulse-ring transform-fill" />
      <circle cx={ex} cy={ez} r="18" fill="#d4ff3a" />
      <circle cx={ex} cy={ez} r="8" fill="#0b0c0a" />

      {/* Top-down car, nose along +x so animateMotion's auto-rotate points it down the road. */}
      <g transform={`translate(${sx} ${sz})`}>
        <g data-flat-car>
          <rect x="-22" y="-11" width="44" height="22" rx="8" fill="#d4ff3a" />
          <rect x="-12" y="-9" width="20" height="18" rx="5" fill="#0d0f11" />
          {/* Drive, hold at the drop-off for a moment, then the ride starts again. */}
          <animateMotion
            data-flat-drive
            begin="indefinite"
            dur="30s"
            repeatCount="indefinite"
            rotate="auto"
            keyPoints="0;1;1"
            keyTimes="0;0.9;1"
            calcMode="linear"
            path={relRoute}
          />
        </g>
      </g>
    </svg>
  );
}
