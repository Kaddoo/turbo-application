import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, relative } from 'node:path';
import { describe, expect, it } from 'vitest';

/**
 * Fails when anything outside the brand and theme layers carries raw styling
 * or the product name. This is what keeps a rebrand to one file.
 */
const root = join(__dirname, '..', 'src');
// demo/ is sample data for presentations (SVG document placeholders), not UI styling.
const allowed = [/^brand\//, /^theme\/theme\.ts$/, /^types\/schema\.d\.ts$/, /^demo\//];

export const patterns: Record<string, RegExp> = {
  'colour literal': /#[0-9a-fA-F]{3,8}\b|\brgba?\(|\bhsla?\(/,
  'literal font size': /font-size:\s*\d|fontSize:\s*['"]?\d/,
  'literal radius': /border-radius:\s*\d|borderRadius:\s*['"]?\d/,
  'font family': /font-family:\s*(?!var\()['"a-zA-Z]|fontFamily:/,
  'product name': /['"`][^'"`\n]*Turbo[^'"`\n]*['"`]/,
};

function files(dir: string): string[] {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? files(path) : [path];
  });
}

export function violations(source: string): string[] {
  const found: string[] = [];
  source.split('\n').forEach((line, i) => {
    const t = line.trimStart();
    if (t.startsWith('//') || t.startsWith('*') || t.startsWith('/*') || t.startsWith('import ')) return;
    for (const [name, re] of Object.entries(patterns)) {
      if (re.test(line)) found.push(`line ${i + 1}: ${name}`);
    }
  });
  return found;
}

const scanned = files(root)
  .map((f) => relative(root, f))
  .filter((f) => /\.(tsx?|css)$/.test(f) && !allowed.some((re) => re.test(f)));

describe('no raw styling outside the brand and theme layers', () => {
  it('has files to scan', () => expect(scanned.length).toBeGreaterThan(0));

  for (const file of scanned) {
    it(file, () => expect(violations(readFileSync(join(root, file), 'utf8'))).toEqual([]));
  }
});

describe('the guard catches each kind of violation', () => {
  const samples: Record<string, string> = {
    'colour literal': 'color: #C6FF00;',
    'literal font size': 'font-size: 14px;',
    'literal radius': 'border-radius: 8px;',
    'font family': "font-family: 'Inter';",
    'product name': "const title = 'Turbo Admin';",
  };
  for (const [kind, line] of Object.entries(samples)) {
    it(kind, () => expect(violations(line).join()).toContain(kind));
  }
});
