/**
 * Post-build checks against a served `out/` folder:
 *  - axe accessibility scan (WCAG 2.1 A/AA) on every page, desktop + mobile
 *  - every internal link and asset resolves (no 404s)
 *  - no console errors
 * Usage: npm run build && npm run check   (serves out/ on :4173 itself)
 */
import { chromium } from "playwright";
import AxeBuilder from "@axe-core/playwright";
import { createServer } from "node:http";
import { readFile, stat } from "node:fs/promises";
import { join, extname } from "node:path";

const ROOT = new URL("../out/", import.meta.url).pathname;
const PORT = 4173;
const types = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".svg": "image/svg+xml", ".png": "image/png", ".xml": "application/xml", ".txt": "text/plain", ".woff2": "font/woff2" };

const server = createServer(async (req, res) => {
  let p = join(ROOT, decodeURIComponent(new URL(req.url, "http://x").pathname));
  try {
    if ((await stat(p)).isDirectory()) p = join(p, "index.html");
    res.writeHead(200, { "content-type": types[extname(p)] ?? "application/json" });
    res.end(await readFile(p));
  } catch {
    res.writeHead(404, { "content-type": "text/html" });
    res.end(await readFile(join(ROOT, "404.html")).catch(() => "404"));
  }
}).listen(PORT);

const base = `http://localhost:${PORT}`;
const pages = ["/", "/privacy/", "/terms/", "/delete-account/", "/support/", "/this-does-not-exist/"];
const browser = await chromium.launch();
let failures = 0;
const seen = new Set();

for (const vp of [{ width: 1440, height: 900 }, { width: 390, height: 844 }]) {
  for (const path of pages) {
    const ctx = await browser.newContext({ viewport: vp, reducedMotion: "reduce" });
    const page = await ctx.newPage();
    const errors = [];
    page.on("console", (m) => m.type() === "error" && !/404 \(File not found\)|status of 404/.test(m.text()) && errors.push(m.text()));
    page.on("pageerror", (e) => errors.push(e.message));
    page.on("response", (r) => {
      if (r.url().startsWith(base) && r.status() >= 400 && !r.url().endsWith("/this-does-not-exist/")) errors.push(`${r.status()} ${r.url()}`);
    });
    await page.goto(base + path, { waitUntil: "networkidle" });
    const axe = await new AxeBuilder({ page }).withTags(["wcag2a", "wcag2aa", "wcag21a", "wcag21aa"]).analyze();
    const h1 = await page.locator("h1").count();
    const label = `${vp.width}px ${path}`;
    if (axe.violations.length || errors.length || h1 !== 1) failures++;
    console.log(`${axe.violations.length || errors.length || h1 !== 1 ? "✗" : "✓"} ${label}  axe:${axe.violations.length} errors:${errors.length} h1:${h1}`);
    for (const v of axe.violations) console.log(`   axe ${v.id}: ${v.help} → ${v.nodes.slice(0, 3).map((n) => n.target.join(" ")).join(" | ")}`);
    for (const e of errors) console.log(`   ${e}`);
    const hrefs = await page.$$eval("a[href]", (as) => as.map((a) => a.getAttribute("href")));
    hrefs.forEach((h) => h.startsWith("/") && seen.add(h.split("#")[0] || "/"));
    await ctx.close();
  }
}

for (const h of seen) {
  const r = await fetch(base + h);
  if (!r.ok) {
    failures++;
    console.log(`✗ link ${h} → ${r.status}`);
  }
}
console.log(`internal links checked: ${[...seen].join(", ")}`);
await browser.close();
server.close();
process.exit(failures ? 1 : 0);
