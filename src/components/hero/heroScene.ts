import {
  ACESFilmicToneMapping,
  BufferGeometry,
  CanvasTexture,
  CircleGeometry,
  Color,
  DirectionalLight,
  DoubleSide,
  ExtrudeGeometry,
  Float32BufferAttribute,
  Fog,
  Group,
  HemisphereLight,
  MathUtils,
  Mesh,
  MeshBasicMaterial,
  MeshLambertMaterial,
  MeshStandardMaterial,
  PerspectiveCamera,
  PlaneGeometry,
  RingGeometry,
  Scene,
  Shape,
  ShapeGeometry,
  ShaderMaterial,
  SRGBColorSpace,
  Vector3,
  WebGLRenderer,
  type Material,
} from "three";
import { RoundedBoxGeometry } from "three/examples/jsm/geometries/RoundedBoxGeometry.js";
import { mergeGeometries } from "three/examples/jsm/utils/BufferGeometryUtils.js";
import mapJson from "./mapData.json";

/** Streets, buildings and land use around the Miotso campus (scripts/map/campus.mjs, © OpenStreetMap contributors). */
type MapData = {
  nodes: number[];
  roads: { k: string; n: number[] }[];
  buildings: { p: number[]; l?: number }[];
  areas: { k: string; p: number[]; name?: string }[];
  labels: { text: string; n: number[] }[];
  tour: number[];
};
const map = mapJson as MapData;

const INK = 0x0b0c0a;
const TURBO = 0xd4ff3a;

/** Dark navigation-app palette. */
const PALETTE = {
  ground: 0x141618,
  campus: 0x17221b,
  field: 0x161b15,
  pitch: 0x1d3424,
  water: 0x13283b,
  commercial: 0x1b1920,
  service: 0x2a2f34,
  minor: 0x3a4047,
  major: 0x5c5640,
  building: 0x2c3138,
  label: "#7f868e",
};
const ROAD_WIDTH: Record<string, number> = { service: 5, minor: 8, major: 15 };

/** Camera: straight down over the car (matching the drone shot), then up and back into the overview. */
const ZOOM = 4.5; // seconds
const NEAR_DIST = 110; // metres above the car at the start
const FAR_DIST = 950; // overview camera distance
const TILT = 0.86; // overview tilt from vertical, radians
const OVERVIEW_AZIMUTH = -0.32; // slight turn off north for depth

/** Driving. */
const SPEED_START = 12; // m/s, close to the car in the clip
const SPEED_CRUISE = 30; // m/s once zoomed out, so rides read at map scale
const DECEL = 9; // m/s², braking into the drop-off
const HOLD = 1.8; // seconds parked at a drop-off before the next ride

const smooth = (t: number) => t * t * (3 - 2 * t);
const node = (i: number, y = 0) => new Vector3(map.nodes[2 * i], y, map.nodes[2 * i + 1]);

/** Flat polygon on the ground (x east, z south). */
function groundShape(ring: number[]) {
  const shape = new Shape();
  for (let i = 0; i < ring.length; i += 2) {
    if (i === 0) shape.moveTo(ring[i], -ring[i + 1]);
    else shape.lineTo(ring[i], -ring[i + 1]);
  }
  return shape;
}

/** Flat ribbons with round joins for every polyline, merged into one geometry. */
function strokes(lines: number[][], width: number) {
  const pos: number[] = [];
  const hw = width / 2;
  const SEG = 10;
  const disc = (x: number, z: number) => {
    for (let i = 0; i < SEG; i++) {
      const a0 = (i / SEG) * Math.PI * 2;
      const a1 = ((i + 1) / SEG) * Math.PI * 2;
      pos.push(x, 0, z, x + Math.cos(a1) * hw, 0, z + Math.sin(a1) * hw, x + Math.cos(a0) * hw, 0, z + Math.sin(a0) * hw);
    }
  };
  for (const l of lines) {
    for (let i = 0; i < l.length; i += 2) {
      disc(l[i], l[i + 1]);
      if (i === 0) continue;
      const [ax, az, bx, bz] = [l[i - 2], l[i - 1], l[i], l[i + 1]];
      const len = Math.hypot(bx - ax, bz - az) || 1;
      const nx = (-(bz - az) / len) * hw;
      const nz = ((bx - ax) / len) * hw;
      pos.push(ax + nx, 0, az + nz, bx + nx, 0, bz + nz, ax - nx, 0, az - nz);
      pos.push(bx + nx, 0, bz + nz, bx - nx, 0, bz - nz, ax - nx, 0, az - nz);
    }
  }
  const g = new BufferGeometry();
  g.setAttribute("position", new Float32BufferAttribute(pos, 3));
  return g;
}

/** Flat layer material: drawn in `layer` order without z-fighting on the ground plane. */
function flat(color: number, layer: number) {
  return new MeshBasicMaterial({
    color,
    side: DoubleSide,
    polygonOffset: true,
    polygonOffsetFactor: -layer,
    polygonOffsetUnits: -layer * 4,
  });
}

/** Text lying on the ground, like a map label. */
function label(text: string, height: number) {
  const c = document.createElement("canvas");
  const ctx = c.getContext("2d")!;
  const font = "600 64px Geist, system-ui, sans-serif";
  ctx.font = font;
  c.width = Math.ceil(ctx.measureText(text).width) + 24;
  c.height = 88;
  ctx.font = font;
  ctx.fillStyle = PALETTE.label;
  ctx.textBaseline = "middle";
  ctx.fillText(text, 12, 46);
  const tex = new CanvasTexture(c);
  tex.colorSpace = SRGBColorSpace;
  tex.anisotropy = 4;
  const mesh = new Mesh(
    new PlaneGeometry((height * c.width) / c.height, height),
    new MeshBasicMaterial({ map: tex, transparent: true, depthWrite: false }),
  );
  mesh.rotation.x = -Math.PI / 2;
  mesh.renderOrder = 3;
  return mesh;
}

/** Rounded lime hatchback; forward is +x. */
function makeCar() {
  const car = new Group();
  const body = new Mesh(
    new RoundedBoxGeometry(4.6, 1.1, 2.0, 3, 0.45),
    new MeshStandardMaterial({ color: TURBO, roughness: 0.35, metalness: 0.15 }),
  );
  body.position.y = 0.75;
  const cabin = new Mesh(
    new RoundedBoxGeometry(2.6, 0.85, 1.76, 3, 0.36),
    new MeshStandardMaterial({ color: 0x0d0f11, roughness: 0.15, metalness: 0.6 }),
  );
  cabin.position.set(-0.35, 1.45, 0);
  const lamp = (color: number, x: number, z: number) => {
    const m = new Mesh(new RoundedBoxGeometry(0.2, 0.22, 0.5, 2, 0.08), new MeshBasicMaterial({ color }));
    m.position.set(x, 0.85, z);
    return m;
  };
  const shadow = new Mesh(
    new CircleGeometry(1, 24),
    new MeshBasicMaterial({ color: 0x000000, transparent: true, opacity: 0.45, depthWrite: false }),
  );
  shadow.rotation.x = -Math.PI / 2;
  shadow.scale.set(3, 1.6, 1);
  shadow.position.y = 0.05;
  car.add(shadow, body, cabin, lamp(0xfff6d8, 2.25, 0.6), lamp(0xfff6d8, 2.25, -0.6), lamp(0xff3b30, -2.25, 0.62), lamp(0xff3b30, -2.25, -0.62));
  return car;
}

/** Route ribbon whose width is a uniform, so it stays readable at every zoom; the part already driven fades away. */
function routeMesh(pts: Vector3[], cum: number[], width: { value: number }, car: { value: number }, opacity: number) {
  const pos: number[] = [];
  const side: number[] = [];
  const dir: number[] = [];
  const along: number[] = [];
  const idx: number[] = [];
  pts.forEach((p, i) => {
    const a = pts[Math.max(0, i - 1)];
    const b = pts[Math.min(pts.length - 1, i + 1)];
    const dx = b.x - a.x;
    const dz = b.z - a.z;
    const l = Math.hypot(dx, dz) || 1;
    for (const s of [-1, 1]) {
      pos.push(p.x, 0.8, p.z);
      side.push(s);
      dir.push(dx / l, dz / l);
      along.push(cum[i]);
    }
    if (i > 0) {
      const k = (i - 1) * 2;
      idx.push(k, k + 1, k + 2, k + 1, k + 3, k + 2);
    }
  });
  const g = new BufferGeometry();
  g.setAttribute("position", new Float32BufferAttribute(pos, 3));
  g.setAttribute("aSide", new Float32BufferAttribute(side, 1));
  g.setAttribute("aDir", new Float32BufferAttribute(dir, 2));
  g.setAttribute("aT", new Float32BufferAttribute(along, 1));
  g.setIndex(idx);
  const m = new ShaderMaterial({
    transparent: true,
    depthWrite: false,
    side: DoubleSide,
    // Sit above the road layers, which are themselves pulled forward with polygon offset.
    polygonOffset: true,
    polygonOffsetFactor: -10,
    polygonOffsetUnits: -60,
    uniforms: { uWidth: width, uCar: car, uColor: { value: new Color(TURBO) }, uOpacity: { value: opacity } },
    vertexShader: `
      attribute float aSide; attribute vec2 aDir; attribute float aT;
      uniform float uWidth; varying float vT;
      void main() {
        vT = aT;
        vec3 p = position + vec3(-aDir.y, 0.0, aDir.x) * aSide * uWidth * 0.5;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(p, 1.0);
      }`,
    fragmentShader: `
      uniform float uCar; uniform vec3 uColor; uniform float uOpacity; varying float vT;
      void main() { gl_FragColor = vec4(uColor, uOpacity * smoothstep(uCar - 4.0, uCar + 2.0, vT)); }`,
  });
  const mesh = new Mesh(g, m);
  mesh.renderOrder = 4;
  return mesh;
}

/** Street graph for picking and routing the rides after the first. */
function buildGraph() {
  const adj = new Map<number, [number, number][]>();
  for (const { n } of map.roads) {
    for (let i = 1; i < n.length; i++) {
      const w = node(n[i - 1]).distanceTo(node(n[i]));
      for (const [a, b] of [
        [n[i - 1], n[i]],
        [n[i], n[i - 1]],
      ]) {
        if (!adj.has(a)) adj.set(a, []);
        adj.get(a)!.push([b, w]);
      }
    }
  }
  const shortest = (from: number, to: number) => {
    const d = new Map([[from, 0]]);
    const prev = new Map<number, number>();
    const open = new Set([from]);
    while (open.size) {
      let u = -1;
      for (const v of open) if (u < 0 || d.get(v)! < d.get(u)!) u = v;
      open.delete(u);
      if (u === to) break;
      for (const [v, w] of adj.get(u) ?? []) {
        const nd = d.get(u)! + w;
        if (nd < (d.get(v) ?? Infinity)) {
          d.set(v, nd);
          prev.set(v, u);
          open.add(v);
        }
      }
    }
    if (!prev.has(to)) return null;
    const path = [to];
    while (path[0] !== from) path.unshift(prev.get(path[0])!);
    return path;
  };
  return { nodes: [...adj.keys()], shortest };
}

type Trip = { pts: Vector3[]; cum: number[]; len: number; end: number; meshes: Mesh[] };

/**
 * Hero map: a dark navigation-style map of the real streets around the
 * Miotso campus with a lime car driving booked rides. `play()` starts the
 * drive from straight overhead (matching the end of the hero video), the
 * camera rises into the overview, `onMap` fires once it has, and rides
 * then follow one another from wherever the last one ended.
 */
export function mountHeroScene(canvas: HTMLCanvasElement, opts: { reduced: boolean; onMap?: () => void }) {
  const renderer = new WebGLRenderer({ canvas, antialias: true, alpha: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.25));
  renderer.toneMapping = ACESFilmicToneMapping;
  renderer.outputColorSpace = SRGBColorSpace;
  renderer.setClearColor(INK, 0);

  const scene = new Scene();
  const fog = new Fog(INK, 200, 600);
  scene.fog = fog;
  scene.add(new HemisphereLight(0xc9d3dd, 0x0b0c0a, 1.6));
  const sun = new DirectionalLight(0xffffff, 1.4);
  sun.position.set(-300, 600, 200);
  scene.add(sun);

  // Ground, land use, streets, buildings, labels.
  const ground = new Mesh(new PlaneGeometry(6000, 6000), flat(PALETTE.ground, 0));
  ground.rotation.x = -Math.PI / 2;
  scene.add(ground);

  const areaLayer: Record<string, number> = { field: 1, commercial: 1, campus: 1, pitch: 2, water: 2 };
  for (const a of map.areas) {
    const g = new ShapeGeometry(groundShape(a.p));
    g.rotateX(-Math.PI / 2);
    const colour = PALETTE[a.k as keyof typeof PALETTE];
    scene.add(new Mesh(g, flat(typeof colour === "number" ? colour : PALETTE.field, areaLayer[a.k] ?? 1)));
  }

  (["service", "minor", "major"] as const).forEach((k, i) => {
    const lines = map.roads.filter((r) => r.k === k).map((r) => r.n.flatMap((n) => [map.nodes[2 * n], map.nodes[2 * n + 1]]));
    scene.add(new Mesh(strokes(lines, ROAD_WIDTH[k]), flat(PALETTE[k], 3 + i)));
  });

  const blocks = map.buildings.map(({ p, l }, i) => {
    const h = l ? l * 3.4 : 5 + ((i * 2654435761) % 1000) / 160;
    const g = new ExtrudeGeometry(groundShape(p), { depth: h, bevelEnabled: false });
    g.rotateX(-Math.PI / 2);
    return g;
  });
  const merged = mergeGeometries(blocks);
  blocks.forEach((g) => g.dispose());
  if (merged) scene.add(new Mesh(merged, new MeshLambertMaterial({ color: PALETTE.building })));

  const campus = map.areas.find((a) => a.k === "campus");
  if (campus) {
    let cx = 0;
    let cz = 0;
    for (let i = 0; i < campus.p.length; i += 2) [cx, cz] = [cx + campus.p[i], cz + campus.p[i + 1]];
    const l = label("Central University", 34);
    l.position.set((2 * cx) / campus.p.length, 0.5, (2 * cz) / campus.p.length - 60);
    scene.add(l);
  }
  for (const { text, n } of map.labels) {
    const a = node(n[Math.max(0, Math.floor(n.length / 2) - 1)]);
    const b = node(n[Math.floor(n.length / 2)]);
    let angle = Math.atan2(-(b.z - a.z), b.x - a.x);
    if (angle > Math.PI / 2) angle -= Math.PI;
    if (angle < -Math.PI / 2) angle += Math.PI;
    const l = label(text, 26);
    l.position.copy(a.lerp(b, 0.5)).setY(0.5);
    l.rotation.z = angle;
    scene.add(l);
  }

  // Markers: pickup ring and drop-off pin with a pulse.
  const markerMat = (color: number) => new MeshBasicMaterial({ color, transparent: true, depthWrite: false });
  const pickup = new Group();
  pickup.add(new Mesh(new CircleGeometry(1, 32), markerMat(0xf3f1ea)), new Mesh(new CircleGeometry(0.55, 32), markerMat(INK)));
  pickup.children[1].position.z = 0.01;
  const dropoff = new Group();
  dropoff.add(new Mesh(new CircleGeometry(1, 32), markerMat(TURBO)), new Mesh(new CircleGeometry(0.42, 32), markerMat(INK)));
  dropoff.children[1].position.z = 0.01;
  const pulse = new Mesh(new RingGeometry(0.9, 1.05, 48), markerMat(TURBO));
  for (const m of [pickup, dropoff, pulse]) {
    m.rotation.x = -Math.PI / 2;
    m.renderOrder = 5;
    m.traverse((o) => (o.renderOrder = 5));
    scene.add(m);
  }

  const car = makeCar();
  scene.add(car);

  // Rides.
  const graph = buildGraph();
  let seed = 7;
  const rand = () => ((seed = (seed * 16807) % 2147483647) - 1) / 2147483646;
  const routeWidth = { value: 8 };
  const glowWidth = { value: 20 };
  const driven = { value: 0 };
  const makeTrip = (path: number[]): Trip => {
    const pts = path.map((n) => node(n));
    const cum = [0];
    for (let i = 1; i < pts.length; i++) cum.push(cum[i - 1] + pts[i].distanceTo(pts[i - 1]));
    const glow = routeMesh(pts, cum, glowWidth, driven, 0.16);
    glow.renderOrder = 3;
    const line = routeMesh(pts, cum, routeWidth, driven, 1);
    scene.add(glow, line);
    pickup.position.set(pts[0].x, 0.6, pts[0].z);
    dropoff.position.set(pts[pts.length - 1].x, 0.7, pts[pts.length - 1].z);
    pulse.position.copy(dropoff.position);
    return { pts, cum, len: cum[cum.length - 1], end: path[path.length - 1], meshes: [glow, line] };
  };
  const nextPath = (from: number) => {
    const here = node(from);
    for (let tries = 0; tries < 40; tries++) {
      const to = graph.nodes[Math.floor(rand() * graph.nodes.length)];
      const there = node(to);
      if (Math.abs(there.x) > 900 || Math.abs(there.z) > 900) continue;
      const d = here.distanceTo(there);
      if (d < 450 || d > 950) continue;
      const path = graph.shortest(from, to);
      if (path && path.length > 3) return path;
    }
    return [...map.tour].reverse();
  };
  const dropTrip = (t: Trip) => {
    for (const m of t.meshes) {
      scene.remove(m);
      m.geometry.dispose();
      (m.material as Material).dispose();
    }
  };

  let trip = makeTrip(map.tour);
  let dist = 0;
  let parkedFor = -1;

  const pointAt = (d: number, out: Vector3) => {
    const { pts, cum } = trip;
    let i = 1;
    while (i < cum.length - 1 && cum[i] < d) i++;
    const t = MathUtils.clamp((d - cum[i - 1]) / (cum[i] - cum[i - 1] || 1), 0, 1);
    return out.lerpVectors(pts[i - 1], pts[i], t);
  };

  // Camera.
  const camera = new PerspectiveCamera(40, 1, 5, 7000);
  let aspect = 1;
  const resize = () => {
    const { clientWidth: w, clientHeight: h } = canvas.parentElement!;
    renderer.setSize(w, h, false);
    aspect = w / h;
    camera.aspect = aspect;
    camera.updateProjectionMatrix();
  };

  const carPos = new Vector3();
  const ahead = new Vector3();
  const target = new Vector3();
  const desired = new Vector3();
  const fwd = new Vector3();
  const right = new Vector3();
  let heading = 0; // azimuth of the car, 0 = north (-z), clockwise
  let headingInit = false;
  let playing = false;
  let clock = 0;
  let mapShown = false;
  let last = -1;

  const angleLerp = (a: number, b: number, t: number) => a + Math.atan2(Math.sin(b - a), Math.cos(b - a)) * t;

  const step = (dt: number) => {
    const k = opts.reduced ? 1 : smooth(MathUtils.clamp(clock / ZOOM, 0, 1));
    if (!mapShown && k > 0.85) {
      mapShown = true;
      opts.onMap?.();
    }

    // Drive: ease up to cruise as the camera pulls out, brake into the drop-off, wait, then the next ride.
    if (parkedFor >= 0) {
      parkedFor += dt;
      if (parkedFor > HOLD) {
        const from = trip.end;
        dropTrip(trip);
        trip = makeTrip(nextPath(from));
        dist = 0;
        parkedFor = -1;
      }
    } else if (dt > 0) {
      const remaining = trip.len - dist;
      const cruise = MathUtils.lerp(SPEED_START, SPEED_CRUISE, k);
      const speed = Math.min(cruise, Math.sqrt(2 * DECEL * Math.max(remaining, 0)) + 0.5);
      dist = Math.min(trip.len, dist + speed * dt);
      if (trip.len - dist < 0.5) parkedFor = 0;
    }
    driven.value = dist;

    pointAt(dist, carPos);
    pointAt(Math.min(dist + 8, trip.len), ahead);
    if (ahead.distanceToSquared(carPos) > 0.01) {
      const h = Math.atan2(ahead.x - carPos.x, -(ahead.z - carPos.z));
      heading = headingInit ? angleLerp(heading, h, Math.min(1, dt * 6)) : h;
      headingInit = true;
    }
    car.position.copy(carPos);
    car.rotation.y = Math.PI / 2 - heading;

    // Camera rig: distance grows exponentially (reads as a steady zoom), tilt and azimuth ease to the overview.
    const camDist = NEAR_DIST * Math.pow(FAR_DIST / NEAR_DIST, k);
    const tilt = TILT * k;
    const azimuth = angleLerp(heading, OVERVIEW_AZIMUTH, k);
    fwd.set(Math.sin(azimuth), 0, -Math.cos(azimuth));
    right.set(-fwd.z, 0, fwd.x);
    const viewW = 2 * camDist * Math.tan(MathUtils.degToRad(camera.fov / 2)) * aspect;
    desired.copy(carPos).lerp(trip.pts[trip.pts.length - 1], 0.25 * k);
    // Keep the ride right of the hero copy on wide screens.
    if (aspect > 1.25) desired.addScaledVector(right, -0.3 * viewW * k);
    if (k < 1) target.copy(desired);
    else target.lerp(desired, 1 - Math.exp(-dt * 1.2));

    camera.up.copy(fwd);
    camera.position.copy(target).addScaledVector(fwd, -Math.sin(tilt) * camDist);
    camera.position.y = Math.cos(tilt) * camDist;
    camera.lookAt(target);
    fog.near = camDist * 1.25;
    fog.far = camDist * 3.4;

    // Sizes that should read the same at every zoom.
    const s = MathUtils.clamp(camDist / 50, 1, 15);
    car.scale.setScalar(s);
    routeWidth.value = MathUtils.clamp(camDist / 70, 2.5, 12);
    glowWidth.value = routeWidth.value * 2.6;
    pickup.scale.setScalar(1.4 * s);
    dropoff.scale.setScalar(1.8 * s);
    const q = (clock * 0.8) % 1;
    pulse.scale.setScalar(1.8 * s * (1 + q * 1.6));
    (pulse.material as MeshBasicMaterial).opacity = (1 - q) * 0.8;
  };

  const render = (now: number) => {
    const dt = last >= 0 && playing ? Math.min((now - last) / 1000, 0.1) : 0;
    last = now;
    clock += dt;
    step(dt);
    renderer.render(scene, camera);
  };

  let raf = 0;
  let visible = true;
  const loop = (t: number) => {
    raf = requestAnimationFrame(loop);
    render(t);
  };
  const startLoop = () => {
    if (raf || !playing || !visible || document.hidden) return;
    last = -1; // resume without a jump
    raf = requestAnimationFrame(loop);
  };
  const stopLoop = () => {
    cancelAnimationFrame(raf);
    raf = 0;
  };

  const ro = new ResizeObserver(() => {
    resize();
    if (!raf) render(performance.now());
  });
  ro.observe(canvas.parentElement!);
  resize();

  const io = new IntersectionObserver(([e]) => {
    visible = e.isIntersecting;
    if (visible) startLoop();
    else stopLoop();
  });
  io.observe(canvas);
  const onVis = () => (document.hidden ? stopLoop() : startLoop());
  document.addEventListener("visibilitychange", onVis);

  if (opts.reduced) {
    // One still frame of the overview with a ride under way.
    dist = trip.len * 0.45;
    clock = ZOOM;
  }
  render(performance.now());

  return {
    play() {
      if (playing || opts.reduced) return;
      playing = true;
      startLoop();
    },
    dispose() {
      stopLoop();
      io.disconnect();
      ro.disconnect();
      document.removeEventListener("visibilitychange", onVis);
      scene.traverse((o) => {
        if (o instanceof Mesh) {
          o.geometry.dispose();
          const m = o.material as Material & { map?: { dispose(): void } | null };
          m.map?.dispose();
          m.dispose();
        }
      });
      renderer.dispose();
    },
  };
}
