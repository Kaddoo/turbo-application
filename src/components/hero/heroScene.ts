import {
  BoxGeometry,
  BufferGeometry,
  Color,
  CurvePath,
  CylinderGeometry,
  DirectionalLight,
  Float32BufferAttribute,
  Fog,
  Group,
  HemisphereLight,
  InstancedMesh,
  LineBasicMaterial,
  LineCurve3,
  LineSegments,
  Mesh,
  MeshBasicMaterial,
  MeshStandardMaterial,
  Object3D,
  PerspectiveCamera,
  PlaneGeometry,
  PointLight,
  QuadraticBezierCurve3,
  RingGeometry,
  Scene,
  SphereGeometry,
  TubeGeometry,
  Vector3,
  WebGLRenderer,
  type Curve,
} from "three";

const INK = 0x0b0c0a;
const TURBO = 0xd4ff3a;

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

/** Polyline along the street grid with rounded corners. */
function buildRoute(points: [number, number][], radius = 0.9) {
  const v = points.map(([x, z]) => new Vector3(x, 0.06, z));
  const path = new CurvePath<Vector3>();
  let cursor = v[0].clone();
  for (let i = 1; i < v.length; i++) {
    const corner = v[i];
    const isLast = i === v.length - 1;
    if (isLast) {
      path.add(new LineCurve3(cursor, corner.clone()));
      break;
    }
    const inDir = corner.clone().sub(v[i - 1]).normalize();
    const outDir = v[i + 1].clone().sub(corner).normalize();
    const a = corner.clone().addScaledVector(inDir, -radius);
    const b = corner.clone().addScaledVector(outDir, radius);
    path.add(new LineCurve3(cursor, a));
    path.add(new QuadraticBezierCurve3(a, corner.clone(), b));
    cursor = b;
  }
  return path;
}

export function mountHeroScene(canvas: HTMLCanvasElement, opts: { reduced: boolean }) {
  const renderer = new WebGLRenderer({ canvas, antialias: true, alpha: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.75));
  renderer.setClearColor(0x000000, 0);

  const scene = new Scene();
  scene.fog = new Fog(INK, 20, 46);

  const camera = new PerspectiveCamera(30, 1, 0.1, 120);
  const camBase = new Vector3(11, 21, 17);
  const lookAt = new Vector3(0.5, 0, -0.5);

  scene.add(new HemisphereLight(0xe9f0dc, INK, 0.75));
  const sun = new DirectionalLight(0xffffff, 1.7);
  sun.position.set(-8, 20, 10);
  scene.add(sun);

  const disposables: { dispose(): void }[] = [];
  const track = <T extends { dispose(): void }>(x: T) => (disposables.push(x), x);

  // Ground
  const ground = new Mesh(
    track(new PlaneGeometry(80, 80)),
    track(new MeshStandardMaterial({ color: 0x10120e, roughness: 1 })),
  );
  ground.rotation.x = -Math.PI / 2;
  scene.add(ground);

  // Street grid lines (streets run along odd coordinates)
  const N = 13;
  const linePos: number[] = [];
  for (let i = -N; i <= N; i += 2) {
    linePos.push(i, 0.01, -N - 1, i, 0.01, N + 1, -N - 1, 0.01, i, N + 1, 0.01, i);
  }
  const lineGeo = track(new BufferGeometry());
  lineGeo.setAttribute("position", new Float32BufferAttribute(linePos, 3));
  scene.add(new LineSegments(lineGeo, track(new LineBasicMaterial({ color: 0x262a22 }))));

  // City blocks
  const rand = mulberry32(7);
  const blockGeo = track(new BoxGeometry(1, 1, 1));
  blockGeo.translate(0, 0.5, 0);
  const blockMat = track(new MeshStandardMaterial({ color: 0xffffff, roughness: 0.85, metalness: 0.05 }));
  const cells: [number, number][] = [];
  for (let x = -12; x <= 12; x += 2) for (let z = -12; z <= 12; z += 2) cells.push([x, z]);
  const blocks = new InstancedMesh(blockGeo, blockMat, cells.length);
  const dummy = new Object3D();
  const cA = new Color(0x1b1e18);
  const cB = new Color(0x252920);
  const cLime = new Color(0x3a4416);
  let n = 0;
  for (const [x, z] of cells) {
    if (rand() < 0.12) continue; // little parks / open lots
    const dist = Math.hypot(x, z);
    const h = 0.2 + Math.pow(rand(), 2.6) * (dist > 9 ? 2.6 : 1.5);
    dummy.position.set(x + (rand() - 0.5) * 0.1, 0, z + (rand() - 0.5) * 0.1);
    dummy.scale.set(1.15 + rand() * 0.2, h, 1.15 + rand() * 0.2);
    dummy.updateMatrix();
    blocks.setMatrixAt(n, dummy.matrix);
    blocks.setColorAt(n, rand() < 0.06 ? cLime : rand() < 0.5 ? cA : cB);
    n++;
  }
  blocks.count = n;
  scene.add(blocks);

  // Route: pickup on the left, destination at top-right
  const route = buildRoute([
    [-11, 7],
    [-5, 7],
    [-5, 3],
    [1, 3],
    [1, -3],
    [7, -3],
    [7, -9],
  ]);
  const SEG = 400;
  const ghostGeo = track(new TubeGeometry(route as unknown as Curve<Vector3>, SEG, 0.06, 6, false));
  scene.add(new Mesh(ghostGeo, track(new MeshBasicMaterial({ color: TURBO, transparent: true, opacity: 0.16 }))));
  const liveGeo = track(new TubeGeometry(route as unknown as Curve<Vector3>, SEG, 0.1, 8, false));
  const liveCount = liveGeo.index!.count;
  scene.add(new Mesh(liveGeo, track(new MeshBasicMaterial({ color: TURBO }))));

  // Pins
  const pin = (color: number) => {
    const g = new Group();
    const stem = new Mesh(track(new CylinderGeometry(0.03, 0.03, 1.1, 8)), track(new MeshBasicMaterial({ color })));
    stem.position.y = 0.55;
    const head = new Mesh(track(new SphereGeometry(0.2, 20, 20)), track(new MeshBasicMaterial({ color })));
    head.position.y = 1.2;
    g.add(stem, head);
    return g;
  };
  const start = route.getPoint(0);
  const end = route.getPoint(1);
  const startPin = pin(0xf3f1ea);
  startPin.position.set(start.x, 0, start.z);
  const endPin = pin(TURBO);
  endPin.position.set(end.x, 0, end.z);
  scene.add(startPin, endPin);

  const ringGeo = track(new RingGeometry(0.35, 0.42, 48));
  const rings = [0, 1].map(() => {
    const m = new Mesh(ringGeo, track(new MeshBasicMaterial({ color: TURBO, transparent: true })));
    m.rotation.x = -Math.PI / 2;
    m.position.set(end.x, 0.03, end.z);
    scene.add(m);
    return m;
  });

  // Pickup-point dots along the way
  const dotGeo = track(new SphereGeometry(0.11, 12, 12));
  const dotMat = track(new MeshBasicMaterial({ color: 0xf3f1ea }));
  for (const t of [0.28, 0.52, 0.76]) {
    const p = route.getPoint(t);
    const d = new Mesh(dotGeo, dotMat);
    d.position.set(p.x, 0.12, p.z);
    scene.add(d);
  }

  // Car
  const car = new Group();
  const body = new Mesh(
    track(new BoxGeometry(0.62, 0.2, 0.34)),
    track(new MeshStandardMaterial({ color: TURBO, emissive: TURBO, emissiveIntensity: 0.25, roughness: 0.4 })),
  );
  body.position.y = 0.18;
  const cabin = new Mesh(
    track(new BoxGeometry(0.34, 0.16, 0.3)),
    track(new MeshStandardMaterial({ color: 0x0b0c0a, roughness: 0.2, metalness: 0.6 })),
  );
  cabin.position.set(-0.04, 0.35, 0);
  car.add(body, cabin);
  const glow = new PointLight(TURBO, 6, 3.5, 2);
  glow.position.y = 0.6;
  car.add(glow);
  scene.add(car);

  // State
  const pointer = { x: 0, y: 0, tx: 0, ty: 0 };
  const onPointer = (e: PointerEvent) => {
    pointer.tx = (e.clientX / window.innerWidth) * 2 - 1;
    pointer.ty = (e.clientY / window.innerHeight) * 2 - 1;
  };
  window.addEventListener("pointermove", onPointer, { passive: true });

  const resize = () => {
    const { clientWidth: w, clientHeight: h } = canvas.parentElement!;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    // Pull back on narrower viewports so the whole route stays in frame.
    camera.zoom = w / h < 1.2 ? 0.78 : 1;
    camera.updateProjectionMatrix();
  };
  const ro = new ResizeObserver(() => {
    resize();
    if (!raf) render(performance.now());
  });
  ro.observe(canvas.parentElement!);
  resize();

  const tangent = new Vector3();
  const LOOP = 10; // seconds per trip
  const placeCar = (t: number) => {
    const p = route.getPointAt(t);
    route.getTangentAt(Math.min(t, 0.999), tangent);
    car.position.set(p.x, 0, p.z);
    car.rotation.y = Math.atan2(-tangent.z, tangent.x);
    liveGeo.setDrawRange(0, Math.floor((liveCount * t) / 6) * 6);
  };

  const render = (time: number) => {
    const s = time / 1000;
    const cycle = (s % (LOOP + 2)) / LOOP; // 2s dwell at destination
    const t = Math.min(cycle, 1);
    const eased = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
    placeCar(opts.reduced ? 0.62 : eased);

    rings.forEach((r, i) => {
      const k = opts.reduced ? 0.4 : ((s * 0.6 + i * 0.5) % 1);
      r.scale.setScalar(1 + k * 3);
      (r.material as MeshBasicMaterial).opacity = 0.9 * (1 - k);
    });
    endPin.position.y = opts.reduced ? 0 : Math.sin(s * 2.2) * 0.08;

    pointer.x += (pointer.tx - pointer.x) * 0.04;
    pointer.y += (pointer.ty - pointer.y) * 0.04;
    const scroll = Math.min(window.scrollY / window.innerHeight, 1.2);
    const orbit = opts.reduced ? 0 : Math.sin(s * 0.08) * 0.12 + pointer.x * 0.12;
    const c = Math.cos(orbit);
    const sn = Math.sin(orbit);
    camera.position.set(
      camBase.x * c - camBase.z * sn,
      camBase.y + pointer.y * -1.2 + scroll * 6,
      camBase.x * sn + camBase.z * c,
    );
    camera.lookAt(lookAt.x, lookAt.y - scroll * 2, lookAt.z);
    renderer.render(scene, camera);
  };

  let raf = 0;
  let visible = true;
  const loop = (t: number) => {
    render(t);
    raf = requestAnimationFrame(loop);
  };
  const startLoop = () => {
    if (!raf && visible && !document.hidden && !opts.reduced) raf = requestAnimationFrame(loop);
  };
  const stopLoop = () => {
    cancelAnimationFrame(raf);
    raf = 0;
  };
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
    blocks.dispose();
    disposables.forEach((d) => d.dispose());
    renderer.dispose();
  };
}

