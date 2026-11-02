// @vitest-environment jsdom
import { afterEach, describe, expect, it, vi } from 'vitest';
import { cleanup, fireEvent, render, screen, within } from '@testing-library/react';
import { useState } from 'react';
import {
  ActionList,
  ActionRow,
  Badge,
  DataTable,
  FilterChip,
  SegmentedControl,
  Select,
  Sparkline,
  WalletCard,
} from '@/components';
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

describe('ActionRow', () => {
  it('is one button naming the action and what it does, and runs on click', () => {
    const onClick = vi.fn();
    render(
      <ActionList label="Account actions">
        <ActionRow
          icon="lock"
          tone="danger"
          title="Suspend account"
          description="They cannot book rides."
          onClick={onClick}
        />
      </ActionList>,
    );
    const button = screen.getByRole('button', { name: /Suspend account/ });
    expect(button.textContent).toContain('They cannot book rides.');
    fireEvent.click(button);
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it('does nothing when disabled', () => {
    const onClick = vi.fn();
    render(
      <ActionList label="Actions">
        <ActionRow icon="signOut" title="Sign out" description="Ends sessions." onClick={onClick} disabled />
      </ActionList>,
    );
    fireEvent.click(screen.getByRole('button', { name: /Sign out/ }));
    expect(onClick).not.toHaveBeenCalled();
  });
});

describe('WalletCard', () => {
  const wallet = { balancePesewas: 6000, reservedPesewas: 3500, availablePesewas: 2500, currency: 'GHS' as const };

  it('shows what can be spent on the card, and the balance and held money in the pocket', () => {
    render(<WalletCard wallet={wallet} holder="Ama Serwaa" reference="0009" />);
    expect(screen.getByText('GH₵25.00')).toBeTruthy();
    expect(screen.getByText('GH₵60.00')).toBeTruthy();
    expect(screen.getByText('GH₵35.00')).toBeTruthy();
    expect(screen.getByText('Ama Serwaa')).toBeTruthy();
    expect(screen.getByRole('img', { name: '58% of the balance is held for rides' })).toBeTruthy();
  });

  it('says so when the wallet is empty, and warns when the student owes money', () => {
    render(
      <WalletCard
        wallet={{ ...wallet, balancePesewas: 0, reservedPesewas: 0, availablePesewas: 0, owedPesewas: 1500 }}
        holder="Kofi"
      />,
    );
    expect(screen.getByRole('img', { name: 'The wallet is empty' })).toBeTruthy();
    expect(screen.getByRole('status').textContent).toContain('Owes GH₵15.00');
  });
});

describe('Select', () => {
  const options = [
    { value: '', label: 'Any' },
    { value: 'pending', label: 'Pending' },
    { value: 'approved', label: 'Approved' },
  ];
  const setup = (value = '') => {
    const onChange = vi.fn();
    render(<Select label="Status" value={value} options={options} onChange={onChange} />);
    return { onChange, box: screen.getByRole('combobox', { name: 'Status' }) };
  };

  it('shows the chosen label and opens a listbox of options', () => {
    const { box } = setup('pending');
    expect(box.textContent).toBe('Pending');
    fireEvent.click(box);
    expect(box.getAttribute('aria-expanded')).toBe('true');
    expect(screen.getAllByRole('option').map((o) => o.textContent)).toEqual(['Any', 'Pending', 'Approved']);
    expect(screen.getByRole('option', { name: 'Pending' }).getAttribute('aria-selected')).toBe('true');
  });

  it('chooses with the mouse, reporting e.target.value, and closes', () => {
    const { box, onChange } = setup();
    fireEvent.click(box);
    fireEvent.click(screen.getByRole('option', { name: 'Approved' }));
    expect(onChange).toHaveBeenCalledWith({ target: { value: 'approved' } });
    expect(screen.queryByRole('listbox')).toBeNull();
  });

  it('chooses with the arrow keys and Enter, and Escape closes without choosing', () => {
    const { box, onChange } = setup();
    fireEvent.keyDown(box, { key: 'ArrowDown' });
    const list = screen.getByRole('listbox');
    fireEvent.keyDown(list, { key: 'ArrowDown' });
    fireEvent.keyDown(list, { key: 'Enter' });
    expect(onChange).toHaveBeenCalledWith({ target: { value: 'pending' } });
    fireEvent.click(box);
    fireEvent.keyDown(screen.getByRole('listbox'), { key: 'Escape' });
    expect(screen.queryByRole('listbox')).toBeNull();
    expect(onChange).toHaveBeenCalledTimes(1);
  });

  it('jumps to an option by typing its first letters', () => {
    const { box, onChange } = setup();
    fireEvent.click(box);
    const list = screen.getByRole('listbox');
    fireEvent.keyDown(list, { key: 'a' });
    fireEvent.keyDown(list, { key: 'p' });
    fireEvent.keyDown(list, { key: 'Enter' });
    expect(onChange).toHaveBeenCalledWith({ target: { value: 'approved' } });
  });

  it('does not open when disabled', () => {
    render(<Select label="Locked" value="" options={options} disabled />);
    fireEvent.click(screen.getByRole('combobox', { name: 'Locked' }));
    expect(screen.queryByRole('listbox')).toBeNull();
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
    within(screen.getByRole('list', { name: 'People' }))
      .getAllByRole('listitem')
      .map((r) => r.querySelector('div > div')?.textContent);
  const sortBy = (key: string) => {
    fireEvent.click(screen.getByRole('combobox', { name: /Sort by/ }));
    fireEvent.click(screen.getByRole('option', { name: key }));
  };

  it('sorts by a column chosen in "Sort by" and reverses it', () => {
    render(<DataTable label="People" rows={rows} rowKey={(r) => r.id} columns={columns} empty={{ title: 'None' }} />);
    expect(names()).toEqual(['Kofi', 'Ama', 'Efua']);
    sortBy('Fare');
    expect(names()).toEqual(['Ama', 'Efua', 'Kofi']);
    fireEvent.click(screen.getByRole('button', { name: /Reverse the order/ }));
    expect(names()).toEqual(['Kofi', 'Efua', 'Ama']);
  });

  it('makes the first column the card title and labels the other values', () => {
    render(<DataTable label="People" rows={rows} rowKey={(r) => r.id} columns={columns} empty={{ title: 'None' }} />);
    const card = screen.getAllByRole('listitem')[0]!;
    expect(card.querySelector('div > div')?.textContent).toBe('Kofi');
    expect(within(card).getByText('Fare').tagName).toBe('DT');
  });

  it('draws a screen-specific card when given one, keeps the actions and sets the tone stripe', () => {
    const withActions = [
      ...columns,
      { header: '', cell: (r: (typeof rows)[0]) => <button type="button">Open {r.name}</button> },
    ];
    render(
      <DataTable
        label="People"
        rows={rows}
        rowKey={(r) => r.id}
        columns={withActions}
        empty={{ title: 'None' }}
        card={(r) => <p>Card for {r.name}</p>}
        cardTone={(r) => (r.fare > 250 ? 'danger' : undefined)}
      />,
    );
    const first = screen.getAllByRole('listitem')[0]!;
    expect(within(first).getByText('Card for Kofi')).toBeTruthy();
    expect(within(first).getByRole('button', { name: 'Open Kofi' })).toBeTruthy();
    expect(first.getAttribute('data-tone')).toBe('danger');
    expect(screen.getAllByRole('listitem')[1]!.getAttribute('data-tone')).toBeNull();
    expect(screen.queryByText('Fare')).toBeNull();
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
