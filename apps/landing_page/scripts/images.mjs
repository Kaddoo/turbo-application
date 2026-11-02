/**
 * Responsive photo variants. Run: npm run images (after adding or replacing a
 * photo in public/photos/). Writes AVIF and WebP copies at 1x/2x widths to
 * public/img/ and the sizes to src/components/ui/photos.json, which <Photo>
 * reads. Never upscales: a 600 px original gives 300 and 600 px variants.
 */
import sharp from "sharp";
import { mkdirSync, readdirSync, writeFileSync } from "node:fs";

const src = new URL("../public/photos/", import.meta.url);
const out = new URL("../public/img/", import.meta.url);
mkdirSync(out, { recursive: true });
const manifest = {};
for (const file of readdirSync(src).filter((f) => f.endsWith(".jpg")).sort()) {
  const name = file.replace(/\.jpg$/, "");
  const img = sharp(new URL(file, src).pathname);
  const { width, height } = await img.metadata();
  const widths = [...new Set([Math.round(width / 2), width])];
  for (const w of widths) {
    await img.clone().resize({ width: w }).avif({ quality: 55 }).toFile(new URL(`${name}-${w}.avif`, out).pathname);
    await img.clone().resize({ width: w }).webp({ quality: 75 }).toFile(new URL(`${name}-${w}.webp`, out).pathname);
  }
  manifest[name] = { width, height, widths };
}
writeFileSync(new URL("../src/components/ui/photos.json", import.meta.url), JSON.stringify(manifest, null, 2) + "\n");
console.log("photos:", Object.keys(manifest).join(", "));
