import { chromium } from "playwright";
const OUT = process.argv[2];
const b = await chromium.launch({ args: ["--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--ignore-gpu-blocklist", "--autoplay-policy=no-user-gesture-required"] });
const p = await b.newPage({ viewport: { width: 1440, height: 900 } });
const errs = []; p.on("pageerror", e => errs.push(e.message)); p.on("console", m => m.type() === "error" && errs.push(m.text()));
const t0 = Date.now();
await p.goto("http://localhost:3000/", { waitUntil: "domcontentloaded" });
for (const t of [1.5, 6, 10.5, 12, 14, 17, 21, 28, 40, 55]) {
  const wait = t * 1000 - (Date.now() - t0); if (wait > 0) await p.waitForTimeout(wait);
  const info = await p.evaluate(() => { const v = document.querySelector("video"); return [v && v.currentTime.toFixed(1), window.__heroRevealed]; });
  console.log(t, info);
  await p.screenshot({ path: `${OUT}/t${String(t).padStart(4, "0")}.jpg`, quality: 60 });
}
console.log("errors:", errs.slice(0, 5));
await b.close();
