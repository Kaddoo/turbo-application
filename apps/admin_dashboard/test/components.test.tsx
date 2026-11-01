// @vitest-environment jsdom
import { afterEach, describe, expect, it, vi } from 'vitest';
import { cleanup, fireEvent, render, screen, within } from '@testing-library/react';
import { useState } from 'react';
import { Badge, DataTable, FilterChip, SegmentedControl, Sparkline } from '@/components';
import { compare, nextSort } from '@/hooks/useSort';
import { bucketCounts, countInPeriod } from '@/utils/series';
import { GlobalSearch } from '@/app/shell/GlobalSearch';

afterEach(cleanup);

describe('sorting helpers', () => {
  it('cycles none -> asc -> desc -> none', () => {
    const a = nextSort(null, 'name');
    expect(a).toEqual({ key: 'name', dir: 'asc' });
    const b = nextSort(a, 'name');
    expect(b).toEqual({ key: 'name', dir: 'desc' });
    expect(nextSort(b, 'name')).toBeNull();
    expect(nextSort(b, 'other')).toEqual({ key: 'other', dir: 'asc' });
  });
  it('compares numbers, text with numbers, and puts missing values last', () => {
    expect(compare(2, 10)).toBeLessThan(0);
    expect(compare('item 2', 'item 10')).toBeLessThan(0);
    expect(compare(undefined, 1)).toBeGreaterThan(0);
  });
});

describe('time buckets for the Overview charts', () => {
  const now = Date.parse('2026-11-01T12:00:00Z');
  const ago = (h: number) => new Date(now - h * 3_600_000).toISOString();
  it('counts per hour, oldest first, ignoring rows outside the window', () => {
    const b = bucketCounts([ago(0.5), ago(0.2), ago(5.5), ago(30), null], '24h', now);
    expect(b).toHaveLength(24);
    expect(b[23]).toBe(2);
    expect(b[18]).toBe(1);
    expect(countInPeriod([ago(0.5), ago(30)], '24h', now)).toBe(1);
    expect(countInPeriod([ago(0.5), ago(30)], '7d', now)).toBe(2);
  });
});

describe('Badge', () => {
  it('caps large counts', () => {
    render(<Badge count={150} />);
    expect(screen.getByText('99+')).toBeTruthy();
  });
});

describe('SegmentedControl', () => {
  function Harness() {
    const [v, setV] = useState<'a' | 'b'>('a');
    return (
      <SegmentedControl
        label="Side"
        value={v}
        onChange={setV}
        options={[
          { value: 'a', label: 'Operations' },
          { value: 'b', label: 'Back office' },
        ]}
      />
    );
  }
  it('moves the choice with the arrow keys', () => {
    render(<Harness />);
    const group = screen.getByRole('radiogroup', { name: 'Side' });
    fireEvent.keyDown(group, { key: 'ArrowRight' });
    expect(screen.getByRole('radio', { name: 'Back office' }).getAttribute('aria-checked')).toBe('true');
    fireEvent.keyDown(group, { key: 'ArrowRight' });
    expect(screen.getByRole('radio', { name: 'Operations' }).getAttribute('aria-checked')).toBe('true');
  });
});

describe('FilterChip', () => {
  it('opens a menu and picks an option', () => {
    const onChange = vi.fn();
    render(
      <FilterChip
        label="Period"
        value="24h"
        onChange={onChange}
        options={[
          { value: '24h', label: '24H' },
          { value: '7d', label: '7D' },
        ]}
      />,
    );
    fireEvent.click(screen.getByRole('button', { name: 'Period: 24H' }));
    fireEvent.click(screen.getByRole('menuitemradio', { name: '7D' }));
    expect(onChange).toHaveBeenCalledWith('7d');
    expect(screen.queryByRole('menu')).toBeNull();
  });
});

describe('DataTable', () => {
  const rows = [
    { id: '1', name: 'Kofi', fare: 300 },
    { id: '2', name: 'Ama', fare: 100 },
    { id: '3', name: 'Efua', fare: 200 },
  ];
  const columns = [
    { header: 'Name', cell: (r: (typeof rows)[0]) => r.name, sortValue: (r: (typeof rows)[0]) => r.name },
    { header: 'Fare', cell: (r: (typeof rows)[0]) => r.fare, sortValue: (r: (typeof rows)[0]) => r.fare },
  ];
  const names = () =>
    within(screen.getByRole('table'))
      .getAllByRole('row')
      .slice(1)
      .map((r) => r.querySelector('td')?.textContent);

  it('sorts by a column and reports it with aria-sort', () => {
    render(<DataTable label="People" rows={rows} rowKey={(r) => r.id} columns={columns} empty={{ title: 'None' }} />);
    expect(names()).toEqual(['Kofi', 'Ama', 'Efua']);
    fireEvent.click(screen.getByRole('button', { name: /Fare/ }));
    expect(names()).toEqual(['Ama', 'Efua', 'Kofi']);
    expect(screen.getByRole('columnheader', { name: /Fare/ }).getAttribute('aria-sort')).toBe('ascending');
    fireEvent.click(screen.getByRole('button', { name: /Fare/ }));
    expect(names()).toEqual(['Kofi', 'Efua', 'Ama']);
  });

  it('labels each cell for the phone card layout', () => {
    render(<DataTable label="People" rows={rows} rowKey={(r) => r.id} columns={columns} empty={{ title: 'None' }} />);
    expect(screen.getAllByRole('cell')[0]!.getAttribute('data-label')).toBe('Name');
  });

  it('shows the empty state', () => {
    render(
      <DataTable label="People" rows={[]} rowKey={(r) => r.id} columns={columns} empty={{ title: 'No people yet.' }} />,
    );
    expect(screen.getByText('No people yet.')).toBeTruthy();
  });
});

describe('Sparkline', () => {
  it('is one image named by its summary', () => {
    render(<Sparkline values={[1, 3, 2]} summary="3 at peak" />);
    expect(screen.getByRole('img', { name: '3 at peak' })).toBeTruthy();
  });
});

describe('GlobalSearch', () => {
  const targets = [
    { to: '/verification', label: 'Verification', group: 'People', icon: 'verification' as const },
    { to: '/finance/topups', label: 'Top-ups', group: 'Finance', icon: 'topups' as const },
  ];
  it('filters the pages and opens the highlighted one with Enter', () => {
    const onOpen = vi.fn();
    render(<GlobalSearch targets={targets} onOpen={onOpen} />);
    const box = screen.getByRole('combobox', { name: 'Search pages' });
    fireEvent.change(box, { target: { value: 'fin' } });
    expect(screen.getAllByRole('option').map((o) => o.textContent)).toEqual(['Top-upsFinance']);
    fireEvent.keyDown(box, { key: 'Enter' });
    expect(onOpen).toHaveBeenCalledWith('/finance/topups');
  });
  it('says when nothing matches', () => {
    render(<GlobalSearch targets={targets} onOpen={() => {}} />);
    fireEvent.change(screen.getByRole('combobox'), { target: { value: 'zzz' } });
    expect(screen.getByText(/No pages match/)).toBeTruthy();
  });
});
