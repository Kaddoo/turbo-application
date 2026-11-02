import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { describe, expect, it } from 'vitest';

const read = (p: string) => readFileSync(resolve(process.cwd(), p), 'utf8');

describe('crawlers', () => {
  const robots = read('public/robots.txt');

  it('robots.txt disallows everything for everyone', () => {
    expect(robots).toMatch(/User-agent: \*\nDisallow: \/\n/);
    expect(robots).not.toMatch(/^Allow:/m);
  });

  it('robots.txt names the main AI crawlers', () => {
    for (const bot of ['GPTBot', 'ClaudeBot', 'PerplexityBot', 'CCBot', 'Google-Extended', 'Applebot-Extended']) {
      expect(robots).toContain(`User-agent: ${bot}\nDisallow: /`);
    }
  });

  it('the page asks not to be indexed, cached or used by AI', () => {
    const html = read('index.html');
    const content = /<meta name="robots" content="([^"]+)"/.exec(html)?.[1] ?? '';
    for (const d of ['noindex', 'nofollow', 'noarchive', 'nosnippet', 'noai', 'noimageai'])
      expect(content).toContain(d);
  });
});
