/**
 * Renders the iPhone 17 Pro model into transparent device images, one per
 * pose, with the display left as a hole. Writes public/mockups/<pose>.webp and
 * src/components/ui/devicePoses.json (image size + the four display corners
 * in pixels), which DevicePhone uses to warp a live HTML screen into the hole.
 *
 * Usage: node scripts/mockups/render.mjs <path to model .glb> [--probe | --grid]
 * The model is not committed; pass its path each time you re-render.
 */
import { chromium } from "playwright";
import { createServer } from "node:http";
import { readFile, writeFile, mkdir, stat } from "node:fs/promises";
import { join, extname, resolve } from "node:path";

const ROOT = resolve(new URL("../..", import.meta.url).pathname);
const [glb, flag] = process.argv.slice(2);
if (!glb) throw new Error("Pass the path to the .glb model");

// Upright, display facing the camera. Found with --probe / --grid.
const ORIENT = JSON.parse(process.env.ORIENT ?? "[0,0,0]");

/** rot: Euler XYZ in degrees applied to the upright phone. */
export const poses = {
  front: { rot: [0, 0, 0], width: 900, height: 1800 },
  tiltLeft: { rot: [4, 9, -13], width: 1000, height: 1800 },
  tiltRight: { rot: [4, -9, 13], width: 1000, height: 1800 },
};

const types = { ".html": "text/html", ".js": "text/javascript" };
const server = createServer(async (req, res) => {
  const url = decodeURIComponent(new URL(req.url, "http://x").pathname);
  try {
    const p = url === "/model.glb" ? glb : join(ROOT, url);
    await stat(p);
    res.writeHead(200, { "content-type": types[extname(p)] ?? "application/octet-stream" });
    res.end(await readFile(p));
  } catch {
    res.writeHead(404);
    res.end();
  }
}).listen(4180);

const browser = await chromium.launch({ args: ["--use-gl=angle", "--use-angle=swiftshader", "--enable-unsafe-swiftshader"] });
const page = await browser.newPage();
page.on("console", (m) => m.type() === "error" && console.error(m.text()));
page.on("pageerror", (e) => console.error(e.message));
await page.goto("http://localhost:4180/scripts/mockups/render.html");
await page.waitForFunction(() => window.__ready, null, { timeout: 120000 });

const rad = (a) => a.map((d) => (d * Math.PI) / 180);

if (flag === "--probe") {
  console.log(JSON.stringify(await page.evaluate(() => window.__info()), null, 1));
} else {
  console.log("upright size", await page.evaluate((o) => window.__orient(o), rad(ORIENT)));
  const outDir = flag === "--grid" ? process.env.OUT : join(ROOT, "public/mockups");
  await mkdir(outDir, { recursive: true });
  const manifest = {};
  for (const [name, p] of Object.entries(poses)) {
    const r = await page.evaluate((o) => window.__render(o), { ...p, rot: rad(p.rot), screen: flag === "--grid" ? "grid" : "hole" });
    await writeFile(join(outDir, `${name}.webp`), Buffer.from(r.dataUrl.split(",")[1], "base64"));
    manifest[name] = { width: r.width, height: r.height, corners: r.corners };
    console.log(name, r.corners);
  }
  if (flag !== "--grid") {
    await writeFile(join(ROOT, "src/components/ui/devicePoses.json"), JSON.stringify(manifest, null, 2) + "\n");
  }
}

await browser.close();
server.close();
