import { chromium } from "playwright";
import { createServer } from "node:http";
import { readFile, stat } from "node:fs/promises";
import { join, extname } from "node:path";
const ROOT = process.argv[2], OUT = process.argv[3];
const types = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".svg": "image/svg+xml", ".woff2": "font/woff2", ".webp": "image/webp", ".jpg": "image/jpeg", ".json": "application/json" };
const server = createServer(async (req, res) => {
  let p = join(ROOT, decodeURIComponent(new URL(req.url, "http://x").pathname));
  try { if ((await stat(p)).isDirectory()) p = join(p, "index.html"); res.writeHead(200, { "content-type": types[extname(p)] ?? "application/octet-stream" }); res.end(await readFile(p)); }
  catch { res.writeHead(404); res.end(); }
}).listen(4174);
const b = await chromium.launch({ args: ["--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--ignore-gpu-blocklist"] });
for (const [w, h, tag] of [[1440, 900, "d"], [390, 844, "m"]]) {
  const p = await b.newPage({ viewport: { width: w, height: h } });
  const errs = []; p.on("pageerror", e => errs.push(e.message));
  await p.goto("http://localhost:4174/", { waitUntil: "networkidle" });
  if (false) for (const t of []) {
    await p.waitForTimeout(t === 2 ? 2000 : 3000);
    await p.screenshot({ path: `${OUT}/hero_${t}.jpg`, quality: 60 });
  }
  const ids = ["tap-away", "how-it-works", "features-title", "fares", "where-we-go", "safety", "faq", "download"];
  for (const id of ids) {
    await p.evaluate((id) => { const el = document.getElementById(id); if (!el) return; window.scrollTo(0, el.getBoundingClientRect().top + scrollY + (id==="tap-away" ? innerHeight*0.9 : -40)); }, id);
    await p.waitForTimeout(1500);
    await p.screenshot({ path: `${OUT}/${tag}_${id}.jpg`, quality: 60 });
  }
  await p.evaluate(() => window.scrollTo(0, document.body.scrollHeight)); await p.waitForTimeout(1200);
  await p.screenshot({ path: `${OUT}/${tag}_footer.jpg`, quality: 60 });
  console.log(tag, "errors:", errs);
}
await b.close(); server.close();
