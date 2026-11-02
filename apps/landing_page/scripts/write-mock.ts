// Writes public/mock-api/* from the typed fixtures in src/api/mock.ts. Run: npm run mock:write
import { writeFileSync } from "node:fs";
import { mockAppConfig, mockLegal, mockServiceArea } from "../src/api/mock.ts";

const out = new URL("../public/mock-api/", import.meta.url);
const files = { "service-area": mockServiceArea, legal: mockLegal, "app-config": mockAppConfig };
for (const [name, body] of Object.entries(files)) writeFileSync(new URL(name, out), JSON.stringify(body, null, 2) + "\n");
console.log(`mock-api written: ${Object.keys(files).join(", ")}`);
