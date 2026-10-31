import {
  ACESFilmicToneMapping,
  BoxGeometry,
  BufferGeometry,
  CanvasTexture,
  Color,
  CurvePath,
  CylinderGeometry,
  DirectionalLight,
  ExtrudeGeometry,
  Float32BufferAttribute,
  Fog,
  Group,
  HemisphereLight,
  InstancedMesh,
  LineCurve3,
  MathUtils,
  Mesh,
  MeshBasicMaterial,
  MeshPhysicalMaterial,
  MeshStandardMaterial,
  Object3D,
  PerspectiveCamera,
  PlaneGeometry,
  PMREMGenerator,
  QuadraticBezierCurve3,
  RepeatWrapping,
  RingGeometry,
  Scene,
  Shape,
  ShaderMaterial,
  SphereGeometry,
  SpotLight,
  SRGBColorSpace,
  Vector3,
  WebGLRenderer,
  type WebGLProgramParametersWithUniforms,
} from "three";
import { RoomEnvironment } from "three/examples/jsm/environments/RoomEnvironment.js";

const INK = 0x0b0c0a;
const TURBO = 0xd4ff3a;

/** City grid: streets every BLOCK units along x and z, ROAD wide, lots edged by SIDEWALK-wide raised pavement. */
const BLOCK = 10;
const ROAD = 3.4;
const SIDEWALK = 0.75;
const GRID = 3; // streets at -GRID..GRID × BLOCK

/** Seconds of street-level chase before the camera lifts into the map, and how long the lift takes. */
const CHASE = 4.2;
const LIFT = 3.2;
const SPEED = 7.5; // units per second

/** Deterministic PRNG so the city looks the same on every visit. */
function mulberry32(seed: number) {
  return () => {
    seed |= 0;
    seed = (seed + 0x6d2b79f5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const smooth = (t: number) => t * t * (3 - 2 * t);

/** Closed loop along street centre lines with rounded corners. */
function buildLoop(points: [number, number][], radius: number) {
  const v = points.map(([x, z]) => new Vector3(x, 0, z));
  const n = v.length;
  const ends = v.map((c, i) => {
    const prev = v[(i - 1 + n) % n];
    const next = v[(i + 1) % n];
    return {
      a: c.clone().addScaledVector(c.clone().sub(prev).normalize(), -radius),
      b: c.clone().addScaledVector(next.clone().sub(c).normalize(), radius),
      c,
    };
  });
  const path = new CurvePath<Vector3>();
  for (let i = 0; i < n; i++) {
    const cur = ends[i];
    const nxt = ends[(i + 1) % n];
    path.add(new LineCurve3(cur.b.clone(), nxt.a.clone()));
    path.add(new QuadraticBezierCurve3(nxt.a.clone(), nxt.c.clone(), nxt.b.clone()));
  }
  path.updateArcLengths();
  return path;
}

/** Facade texture: a tile of floors × windows, some lit warm, most dark. */
function windowTexture(rand: () => number) {
  const c = document.createElement("canvas");
  c.width = 256;
  c.height = 512;
  const g = c.getContext("2d")!;
  g.fillStyle = "#000";
  g.fillRect(0, 0, c.width, c.height);
  const cols = 8;
  const rows = 16;
  const cw = c.width / cols;
  const rh = c.height / rows;
  for (let r = 0; r < rows; r++) {
    for (let k = 0; k < cols; k++) {
      const lit = rand() < 0.32;
      const warm = rand();
      g.fillStyle = lit
        ? warm < 0.7
          ? `rgb(255 ${190 + Math.floor(rand() * 40)} ${120 + Math.floor(rand() * 50)})`
          : `rgb(${200 + Math.floor(rand() * 40)} 225 255)`
        : `rgb(${10 + Math.floor(rand() * 14)} ${12 + Math.floor(rand() * 14)} ${16 + Math.floor(rand() * 16)})`;
      g.fillRect(k * cw + cw * 0.16, r * rh + rh * 0.2, cw * 0.68, rh * 0.56);
    }
  }
  const t = new CanvasTexture(c);
  t.wrapS = t.wrapT = RepeatWrapping;
  t.colorSpace = SRGBColorSpace;
  t.anisotropy = 4;
  return t;
}

/** Soft dark blob used as the car's contact shadow. */
function shadowTexture() {
  const c = document.createElement("canvas");
  c.width = c.height = 128;
  const g = c.getContext("2d")!;
  const grd = g.createRadialGradient(64, 64, 4, 64, 64, 64);
  grd.addColorStop(0, "rgba(0,0,0,0.85)");
  grd.addColorStop(1, "rgba(0,0,0,0)");
  g.fillStyle = grd;
  g.fillRect(0, 0, 128, 128);
  return new CanvasTexture(c);
}

type Uniform = { value: number };

/**
 * Patches a standard material so that, as `uMap` goes 0 → 1, instances fold
 * into the map (`flatten`: height only, `shrink`: whole object), blend to the
 * map colour, and (for facades) windows go dark with roofs never lit.
 */
function mapMorph(mat: MeshStandardMaterial, uMap: Uniform, mode: "flatten" | "shrink", mapColor: Color, facade = false) {
  mat.onBeforeCompile = (sh: WebGLProgramParametersWithUniforms) => {
    sh.uniforms.uMap = uMap;
    sh.uniforms.uMapColor = { value: mapColor };
    sh.vertexShader = sh.vertexShader
      .replace("#include <common>", "#include <common>\nuniform float uMap;\nvarying float vTop;")
      .replace(
        "#include <uv_vertex>",
        `#include <uv_vertex>
        vTop = step(0.9, normal.y);
        #if defined(USE_EMISSIVEMAP) && defined(USE_INSTANCING)
          vec2 sc = vec2(length(instanceMatrix[0].xyz), length(instanceMatrix[1].xyz));
          vEmissiveMapUv = uv * sc * vec2(1.0 / 2.6, 1.0 / 5.0) + vec2(instanceMatrix[3].x * 0.37, instanceMatrix[3].z * 0.21);
        #endif`,
      )
      .replace(
        "#include <begin_vertex>",
        mode === "flatten"
          ? "#include <begin_vertex>\ntransformed.y *= mix(1.0, 0.035, uMap);"
          : "#include <begin_vertex>\ntransformed *= 1.0 - uMap;",
      );
    sh.fragmentShader = sh.fragmentShader
      .replace("#include <common>", "#include <common>\nuniform float uMap;\nuniform vec3 uMapColor;\nvarying float vTop;")
      .replace("#include <color_fragment>", "#include <color_fragment>\ndiffuseColor.rgb = mix(diffuseColor.rgb, uMapColor, uMap);")
      .replace(
        "#include <emissivemap_fragment>",
        facade
          ? "#include <emissivemap_fragment>\ntotalEmissiveRadiance *= (1.0 - vTop) * (1.0 - uMap);"
          : "#include <emissivemap_fragment>\ntotalEmissiveRadiance *= 1.0 - uMap;",
      );
  };
}

/** A compact hatchback in Turbo lime: extruded body, glass greenhouse, wheels, lights. */
function makeCar(track: <T extends { dispose(): void }>(x: T) => T) {
  const car = new Group();
  const L = 2.3;
  const W = 1.02;

  const paint = track(new MeshPhysicalMaterial({ color: TURBO, metalness: 0.35, roughness: 0.32, clearcoat: 1, clearcoatRoughness: 0.08 }));
  const glass = track(new MeshPhysicalMaterial({ color: 0x0c0f12, metalness: 0.9, roughness: 0.05, clearcoat: 1 }));
  const trim = track(new MeshStandardMaterial({ color: 0x0d0e0f, roughness: 0.6 }));
  const rubber = track(new MeshStandardMaterial({ color: 0x111111, roughness: 0.9 }));
  const alloy = track(new MeshStandardMaterial({ color: 0xc9ccd0, metalness: 1, roughness: 0.25 }));

  // Lower body: side profile extruded across the width.
  const body = new Shape();
  body.moveTo(-L / 2, 0.22);
  body.lineTo(-L / 2, 0.55);
  body.quadraticCurveTo(-L / 2 + 0.04, 0.68, -L / 2 + 0.3, 0.7);
  body.lineTo(L / 2 - 0.55, 0.68);
  body.quadraticCurveTo(L / 2 - 0.12, 0.62, L / 2, 0.48);
  body.lineTo(L / 2, 0.24);
  body.quadraticCurveTo(L / 2 - 0.02, 0.17, L / 2 - 0.12, 0.17);
  body.lineTo(-L / 2 + 0.12, 0.17);
  body.quadraticCurveTo(-L / 2, 0.17, -L / 2, 0.22);
  const bodyGeo = track(
    new ExtrudeGeometry(body, { depth: W - 0.12, bevelEnabled: true, bevelSize: 0.06, bevelThickness: 0.06, bevelSegments: 4, curveSegments: 10 }),
  );
  bodyGeo.translate(0, 0, -(W - 0.12) / 2);
  car.add(new Mesh(bodyGeo, paint));

  // Greenhouse (windows) and roof.
  const cabin = new Shape();
  cabin.moveTo(-L / 2 + 0.22, 0.68);
  cabin.lineTo(-L / 2 + 0.34, 1.02);
  cabin.quadraticCurveTo(-L / 2 + 0.38, 1.08, -L / 2 + 0.5, 1.08);
  cabin.lineTo(0.22, 1.08);
  cabin.quadraticCurveTo(0.3, 1.08, 0.36, 1.02);
  cabin.lineTo(L / 2 - 0.58, 0.68);
  const cabinGeo = track(
    new ExtrudeGeometry(cabin, { depth: W - 0.3, bevelEnabled: true, bevelSize: 0.04, bevelThickness: 0.04, bevelSegments: 3, curveSegments: 8 }),
  );
  cabinGeo.translate(0, 0, -(W - 0.3) / 2);
  car.add(new Mesh(cabinGeo, glass));
  const roof = new Mesh(track(new BoxGeometry(0.98, 0.04, W - 0.26)), paint);
  roof.position.set(-0.22, 1.1, 0);
  car.add(roof);

  const sill = new Mesh(track(new BoxGeometry(L - 0.2, 0.08, W + 0.02)), trim);
  sill.position.y = 0.2;
  car.add(sill);

  // Lights.
  const headMat = track(new MeshStandardMaterial({ color: 0xffffff, emissive: 0xfff6e0, emissiveIntensity: 3 }));
  const tailMat = track(new MeshStandardMaterial({ color: 0x400000, emissive: 0xff2a1a, emissiveIntensity: 2.4 }));
  for (const s of [-1, 1]) {
    const h = new Mesh(track(new BoxGeometry(0.06, 0.08, 0.26)), headMat);
    h.position.set(L / 2 + 0.03, 0.46, s * 0.33);
    const t = new Mesh(track(new BoxGeometry(0.05, 0.08, 0.28)), tailMat);
    t.position.set(-L / 2 - 0.04, 0.55, s * 0.32);
    car.add(h, t);
  }

  // Wheels.
  const tireGeo = track(new CylinderGeometry(0.24, 0.24, 0.2, 28));
  tireGeo.rotateX(Math.PI / 2);
  const rimGeo = track(new CylinderGeometry(0.15, 0.15, 0.21, 14));
  rimGeo.rotateX(Math.PI / 2);
  const wheels: Group[] = [];
  for (const x of [L / 2 - 0.5, -L / 2 + 0.48]) {
    for (const s of [-1, 1]) {
      const w = new Group();
      w.add(new Mesh(tireGeo, rubber), new Mesh(rimGeo, alloy));
      w.position.set(x, 0.24, s * (W / 2 - 0.02));
      wheels.push(w);
      car.add(w);
    }
  }

  // Headlight beam on the road ahead.
  const beam = new SpotLight(0xfff1d6, 60, 26, 0.52, 0.65, 1.6);
  beam.position.set(L / 2, 0.5, 0);
  beam.target.position.set(L / 2 + 8, 0, 0);
  car.add(beam, beam.target);

  return { car, wheels, beam };
}

/**
 * Hero scene: a street-level chase of a Turbo car through a dusk city, then
 * a crane move up into the map, where buildings fold flat and the car keeps
 * driving its loop as a marker with a glowing trail.
 */
export function mountHeroScene(canvas: HTMLCanvasElement, opts: { reduced: boolean }) {
  const renderer = new WebGLRenderer({ canvas, antialias: true, alpha: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.5));
  renderer.setClearColor(0x000000, 0);
  renderer.toneMapping = ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.05;

  const disposables: { dispose(): void }[] = [];
  const track = <T extends { dispose(): void }>(x: T) => (disposables.push(x), x);

  const scene = new Scene();
  const fog = new Fog(INK, 14, 60);
  scene.fog = fog;
  const pmrem = new PMREMGenerator(renderer);
  const envRT = track(pmrem.fromScene(new RoomEnvironment(), 0.04));
  pmrem.dispose();
  scene.environment = envRT.texture;
  scene.environmentIntensity = 0.32;

  scene.add(new HemisphereLight(0x9fb2ff, 0x1a1810, 0.55));
  const sun = new DirectionalLight(0xffc98f, 1.6);
  sun.position.set(-30, 18, 12);
  scene.add(sun);

  const uMap: Uniform = { value: 0 };
  const rand = mulberry32(11);
  const mapBlock = new Color(0x161814);
  const span = GRID * BLOCK + BLOCK / 2;
  const dummy = new Object3D();

  // Asphalt everywhere; lots sit on top as raised slabs (kerb + pavement).
  const asphaltA = new Color(0x1c1d1f);
  const asphaltB = new Color(0x262a22);
  const asphaltMat = track(new MeshStandardMaterial({ color: asphaltA.clone(), roughness: 0.92 }));
  const ground = new Mesh(track(new PlaneGeometry(span * 2 + 40, span * 2 + 40)), asphaltMat);
  ground.rotation.x = -Math.PI / 2;
  scene.add(ground);

  const lots: [number, number][] = [];
  for (let i = -GRID; i < GRID; i++) for (let j = -GRID; j < GRID; j++) lots.push([(i + 0.5) * BLOCK, (j + 0.5) * BLOCK]);
  const lotSize = BLOCK - ROAD;
  const pavementA = new Color(0x55534e);
  const pavementMat = track(new MeshStandardMaterial({ color: pavementA.clone(), roughness: 0.95 }));
  const slabGeo = track(new BoxGeometry(lotSize, 0.14, lotSize));
  slabGeo.translate(0, 0.07, 0);
  const slabs = new InstancedMesh(slabGeo, pavementMat, lots.length);
  lots.forEach(([x, z], i) => {
    dummy.position.set(x, 0, z);
    dummy.updateMatrix();
    slabs.setMatrixAt(i, dummy.matrix);
  });
  scene.add(slabs);

  // Lane markings: dashed centre lines on every street, junctions kept clear.
  const dashGeo = track(new BoxGeometry(1.1, 0.02, 0.1));
  const dashMat = track(new MeshStandardMaterial({ color: 0xe9e4d4, emissive: 0x6b675d, roughness: 0.6, transparent: true }));
  const dashSpots: [number, number, number][] = [];
  for (let k = -GRID; k <= GRID; k++) {
    for (let s = -span; s < span; s += 2.4) {
      const m = (((s + BLOCK / 2) % BLOCK) + BLOCK) % BLOCK; // distance into the block, junction at BLOCK/2
      if (Math.abs(m - BLOCK / 2) < ROAD / 2 + 0.6) continue;
      dashSpots.push([s, k * BLOCK, 0], [k * BLOCK, s, Math.PI / 2]);
    }
  }
  const dashes = new InstancedMesh(dashGeo, dashMat, dashSpots.length);
  dashSpots.forEach(([x, z, r], i) => {
    dummy.position.set(x, 0.01, z);
    dummy.rotation.set(0, r, 0);
    dummy.updateMatrix();
    dashes.setMatrixAt(i, dummy.matrix);
  });
  dummy.rotation.set(0, 0, 0);
  scene.add(dashes);

  // Buildings: up to four per lot, taller toward the edges, lit windows.
  const facade = track(
    new MeshStandardMaterial({
      color: 0xffffff,
      roughness: 0.78,
      metalness: 0.1,
      emissive: 0xffffff,
      emissiveIntensity: 1.25,
      emissiveMap: track(windowTexture(rand)),
    }),
  );
  mapMorph(facade, uMap, "flatten", new Color(0x1d201a), true);
  const bGeo = track(new BoxGeometry(1, 1, 1));
  bGeo.translate(0, 0.5, 0);
  const inner = lotSize - SIDEWALK * 2;
  const cell = inner / 2;
  const tones = [0x2b2d30, 0x34312d, 0x24272b, 0x3a3833, 0x2e3330].map((c) => new Color(c));
  const buildings = new InstancedMesh(bGeo, facade, lots.length * 4);
  let nb = 0;
  for (const [x, z] of lots) {
    for (let a = 0; a < 2; a++) {
      for (let b = 0; b < 2; b++) {
        if (rand() < 0.08) continue; // a plaza now and then
        const edge = Math.max(Math.abs(x), Math.abs(z)) / span;
        const h = 1.6 + Math.pow(rand(), 1.8) * (3 + edge * 9);
        dummy.position.set(x - inner / 2 + cell * (a + 0.5), 0.14, z - inner / 2 + cell * (b + 0.5));
        dummy.scale.set(cell * (0.78 + rand() * 0.18), h, cell * (0.78 + rand() * 0.18));
        dummy.updateMatrix();
        buildings.setMatrixAt(nb, dummy.matrix);
        buildings.setColorAt(nb, tones[Math.floor(rand() * tones.length)]);
        nb++;
      }
    }
  }
  buildings.count = nb;
  scene.add(buildings);

  // Street trees and lamps along the pavements.
  const leafMat = track(new MeshStandardMaterial({ color: 0x2f4a24, roughness: 0.9 }));
  const trunkMat = track(new MeshStandardMaterial({ color: 0x3b2c20, roughness: 1 }));
  const poleMat = track(new MeshStandardMaterial({ color: 0x3a3c40, metalness: 0.6, roughness: 0.4 }));
  const bulbMat = track(new MeshStandardMaterial({ color: 0xffe2b0, emissive: 0xffd08a, emissiveIntensity: 4 }));
  [leafMat, trunkMat, poleMat, bulbMat].forEach((m) => mapMorph(m, uMap, "shrink", mapBlock));

  const treeSpots: [number, number][] = [];
  const lampSpots: [number, number][] = [];
  for (const [x, z] of lots) {
    const e = lotSize / 2 - SIDEWALK / 2;
    for (const s of [-1, 1]) {
      for (const f of [-0.3, 0.3]) treeSpots.push([x + f * lotSize, z + s * e], [x + s * e, z + f * lotSize]);
      lampSpots.push([x + s * e, z + s * e]);
    }
  }
  const canopyGeo = track(new SphereGeometry(0.55, 10, 8));
  canopyGeo.translate(0, 1.55, 0);
  const trunkGeo = track(new CylinderGeometry(0.06, 0.08, 1.1, 6));
  trunkGeo.translate(0, 0.69, 0);
  const canopies = new InstancedMesh(canopyGeo, leafMat, treeSpots.length);
  const trunks = new InstancedMesh(trunkGeo, trunkMat, treeSpots.length);
  treeSpots.forEach(([x, z], i) => {
    const k = 0.8 + rand() * 0.45;
    dummy.position.set(x, 0.14, z);
    dummy.rotation.set(0, rand() * Math.PI, 0);
    dummy.scale.set(k, k, k);
    dummy.updateMatrix();
    canopies.setMatrixAt(i, dummy.matrix);
    trunks.setMatrixAt(i, dummy.matrix);
  });
  const poleGeo = track(new CylinderGeometry(0.04, 0.05, 2.6, 6));
  poleGeo.translate(0, 1.44, 0);
  const bulbGeo = track(new SphereGeometry(0.12, 10, 8));
  bulbGeo.translate(0, 2.74, 0);
  const poles = new InstancedMesh(poleGeo, poleMat, lampSpots.length);
  const bulbs = new InstancedMesh(bulbGeo, bulbMat, lampSpots.length);
  dummy.rotation.set(0, 0, 0);
  dummy.scale.set(1, 1, 1);
  lampSpots.forEach(([x, z], i) => {
    dummy.position.set(x, 0.14, z);
    dummy.updateMatrix();
    poles.setMatrixAt(i, dummy.matrix);
    bulbs.setMatrixAt(i, dummy.matrix);
  });
  scene.add(canopies, trunks, poles, bulbs);

  // The ride: a loop around several blocks.
  const route = buildLoop(
    [
      [-2 * BLOCK, BLOCK],
      [BLOCK, BLOCK],
      [BLOCK, -2 * BLOCK],
      [-BLOCK, -2 * BLOCK],
      [-BLOCK, 0],
      [-2 * BLOCK, 0],
    ],
    3,
  );
  const routeLen = route.getLength();
  const LANE = ROAD / 4;
  const up = new Vector3(0, 1, 0);
  const tmpT = new Vector3();
  const tmpR = new Vector3();
  /** Point in the right-hand lane at arc fraction t. */
  const lanePoint = (t: number, out: Vector3) => {
    const u = ((t % 1) + 1) % 1;
    route.getPointAt(u, out);
    route.getTangentAt(u, tmpT);
    tmpR.crossVectors(tmpT, up).normalize();
    return out.addScaledVector(tmpR, LANE);
  };

  // Route ribbon for the map: bright trail behind the car, faint ahead.
  const SAMPLES = 700;
  const pos: number[] = [];
  const along: number[] = [];
  const idx: number[] = [];
  const p = new Vector3();
  for (let i = 0; i <= SAMPLES; i++) {
    const t = i / SAMPLES;
    lanePoint(t, p);
    route.getTangentAt(t % 1, tmpT);
    tmpR.crossVectors(tmpT, up).normalize();
    const hw = 0.42;
    pos.push(p.x - tmpR.x * hw, 0.05, p.z - tmpR.z * hw, p.x + tmpR.x * hw, 0.05, p.z + tmpR.z * hw);
    along.push(t, t);
    if (i < SAMPLES) {
      const a = i * 2;
      idx.push(a, a + 1, a + 2, a + 1, a + 3, a + 2);
    }
  }
  const ribbonGeo = track(new BufferGeometry());
  ribbonGeo.setAttribute("position", new Float32BufferAttribute(pos, 3));
  ribbonGeo.setAttribute("aT", new Float32BufferAttribute(along, 1));
  ribbonGeo.setIndex(idx);
  const uCar: Uniform = { value: 0 };
  const ribbonMat = track(
    new ShaderMaterial({
      transparent: true,
      depthWrite: false,
      uniforms: { uMap, uCar, uColor: { value: new Color(TURBO) } },
      vertexShader:
        "attribute float aT; varying float vT; void main(){ vT = aT; gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0); }",
      fragmentShader:
        "uniform float uMap; uniform float uCar; uniform vec3 uColor; varying float vT; void main(){ float behind = fract(uCar - vT); float trail = behind < 0.55 ? 1.0 - behind / 0.55 : 0.0; gl_FragColor = vec4(uColor, uMap * (0.22 + 0.78 * trail)); }",
    }),
  );
  const ribbon = new Mesh(ribbonGeo, ribbonMat);
  ribbon.renderOrder = 2;
  scene.add(ribbon);

  // Destination pin and pulse rings under the car (map only).
  const pinMat = track(new MeshBasicMaterial({ color: TURBO, transparent: true }));
  const pin = new Group();
  const stem = new Mesh(track(new CylinderGeometry(0.08, 0.08, 2.2, 8)), pinMat);
  stem.position.y = 1.1;
  const head = new Mesh(track(new SphereGeometry(0.55, 20, 16)), pinMat);
  head.position.y = 2.6;
  pin.add(stem, head);
  const dest = lanePoint(0.62, new Vector3());
  pin.position.set(dest.x, 0, dest.z);
  scene.add(pin);
  const ringGeo = track(new RingGeometry(0.8, 0.95, 48));
  const rings = [0, 1].map(() => {
    const m = new Mesh(ringGeo, track(new MeshBasicMaterial({ color: TURBO, transparent: true, depthWrite: false })));
    m.rotation.x = -Math.PI / 2;
    scene.add(m);
    return m;
  });

  // Car with contact shadow.
  const { car, wheels, beam } = makeCar(track);
  const shadow = new Mesh(
    track(new PlaneGeometry(3.2, 1.8)),
    track(new MeshBasicMaterial({ map: track(shadowTexture()), transparent: true, depthWrite: false })),
  );
  shadow.rotation.x = -Math.PI / 2;
  shadow.position.y = 0.02;
  const rig = new Group();
  rig.add(car, shadow);
  scene.add(rig);

  const camera = new PerspectiveCamera(42, 1, 0.1, 220);
  const chasePos = new Vector3();
  const chaseLook = new Vector3();
  const mapCentre = new Vector3(-BLOCK / 2, 0, -BLOCK / 2);
  const mapPos = new Vector3();
  const mapLook = new Vector3();
  const camPos = new Vector3();
  const camLook = new Vector3();

  const pointer = { x: 0, y: 0, tx: 0, ty: 0 };
  const onPointer = (e: PointerEvent) => {
    pointer.tx = (e.clientX / window.innerWidth) * 2 - 1;
    pointer.ty = (e.clientY / window.innerHeight) * 2 - 1;
  };
  window.addEventListener("pointermove", onPointer, { passive: true });

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
  const fwd = new Vector3();
  const side = new Vector3();
  const START = 0.02; // on the long straight heading east
  let clock = 0; // seconds of animation actually shown (pauses while off screen)
  let last = -1;

  const render = (now: number) => {
    if (last >= 0) clock += Math.min((now - last) / 1000, 0.1);
    last = now;
    const s = opts.reduced ? CHASE + LIFT + 2 : clock;
    const k = smooth(MathUtils.clamp((s - CHASE) / LIFT, 0, 1));
    uMap.value = k;

    // Car along the loop.
    const tCar = START + (opts.reduced ? 0.3 : (s * SPEED) / routeLen);
    lanePoint(tCar, carPos);
    lanePoint(tCar + 0.004, ahead);
    fwd.subVectors(ahead, carPos).normalize();
    side.crossVectors(fwd, up).normalize();
    rig.position.copy(carPos);
    rig.rotation.y = Math.atan2(-fwd.z, fwd.x);
    rig.scale.setScalar(MathUtils.lerp(1, 2.4, k));
    wheels.forEach((w) => (w.rotation.z = -(s * SPEED) / 0.24));
    beam.intensity = 60 * (1 - k);
    uCar.value = ((tCar % 1) + 1) % 1;

    // Streets turn into map.
    asphaltMat.color.lerpColors(asphaltA, asphaltB, k);
    pavementMat.color.lerpColors(pavementA, mapBlock, k);
    dashMat.opacity = 1 - k;
    pinMat.opacity = k;
    pin.position.y = k * (0.2 + Math.sin(s * 2.4) * 0.25);
    pin.scale.setScalar(Math.max(0.001, k));
    rings.forEach((r, i) => {
      const q = (s * 0.7 + i * 0.5) % 1;
      r.position.set(carPos.x, 0.06, carPos.z);
      r.scale.setScalar(1 + q * 3.2);
      (r.material as MeshBasicMaterial).opacity = k * 0.9 * (1 - q);
    });
    fog.near = MathUtils.lerp(14, 70, k);
    fog.far = MathUtils.lerp(60, 160, k);

    // Camera: low chase behind the car, then a crane move up into the map.
    // Behind and slightly toward the centre line, so kerbside trees never block the shot.
    chasePos.copy(carPos).addScaledVector(fwd, -6.8).addScaledVector(side, -1.1).setY(2.4);
    chaseLook.copy(carPos).addScaledVector(fwd, 4).setY(0.7);
    pointer.x += (pointer.tx - pointer.x) * 0.04;
    pointer.y += (pointer.ty - pointer.y) * 0.04;
    const scroll = Math.min(window.scrollY / window.innerHeight, 1.2);
    const pull = aspect < 1.2 ? 1.25 : 1;
    mapPos.set(mapCentre.x + 22 * pull + pointer.x * 3, 46 * pull - pointer.y * 3 + scroll * 10, mapCentre.z + 34 * pull);
    mapLook.copy(mapCentre).setY(-scroll * 4);
    camPos.lerpVectors(chasePos, mapPos, k);
    camPos.y += Math.sin(k * Math.PI) * 8;
    camLook.lerpVectors(chaseLook, mapLook, k);
    camera.fov = MathUtils.lerp(42, 34, k);
    camera.updateProjectionMatrix();
    camera.position.copy(camPos);
    camera.lookAt(camLook);
    renderer.render(scene, camera);
  };

  let raf = 0;
  let visible = true;
  const loop = (t: number) => {
    render(t);
    raf = requestAnimationFrame(loop);
  };
  const startLoop = () => {
    if (raf || !visible || document.hidden || opts.reduced) return;
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

  if (opts.reduced) render(0);
  else startLoop();

  return () => {
    stopLoop();
    io.disconnect();
    ro.disconnect();
    document.removeEventListener("visibilitychange", onVis);
    window.removeEventListener("pointermove", onPointer);
    [slabs, dashes, buildings, canopies, trunks, poles, bulbs].forEach((m) => m.dispose());
    disposables.forEach((d) => d.dispose());
    renderer.dispose();
  };
}
