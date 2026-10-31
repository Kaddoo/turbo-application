import { ImageResponse } from "next/og";

export const dynamic = "force-static";
export const alt = "Turbo — Rides around campus, paid from your wallet.";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default function OG() {
  return new ImageResponse(
    (
      <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", justifyContent: "space-between", background: "#0b0c0a", color: "#f3f1ea", padding: 80 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 16, fontSize: 44, fontWeight: 700 }}>
          <div style={{ width: 28, height: 28, borderRadius: 99, background: "#d4ff3a" }} />
          Turbo
        </div>
        <div style={{ display: "flex", fontSize: 84, fontWeight: 700, lineHeight: 1, letterSpacing: -3, maxWidth: 960 }}>
          Rides around campus, paid from your wallet.
        </div>
        <div style={{ display: "flex", fontSize: 30, color: "#a3a89b" }}>Central University · Miotso</div>
      </div>
    ),
    size,
  );
}
