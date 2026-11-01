import { useState } from 'react';
import { Button, DataTable, PageHeader, TextField, ui, When } from '@/components';
import { humanize, shortId } from '@/utils/format';
import { useAuditLog } from './queries';

export function AuditLog() {
  const [entityType, setEntityType] = useState('');
  const [entityId, setEntityId] = useState('');
  const [actor, setActor] = useState('');
  const [applied, setApplied] = useState({ entityType: '', entityId: '', actor: '' });
  const list = useAuditLog(applied);
  function exportCsv() {
    const rows = list.rows ?? [];
    const esc = (v: string) => `"${v.replace(/"/g, '""')}"`;
    const csv = ['at,actor,action,entity_type,entity_id,detail', ...rows.map((r) =>
      [r.at, r.actorStaffId ?? 'system', r.action, r.entityType, r.entityId, JSON.stringify(r.detail ?? {})].map((x) => esc(String(x))).join(','))].join('\n');
    const url = URL.createObjectURL(new Blob([csv], { type: 'text/csv' }));
    const a = document.createElement('a');
    a.href = url; a.download = `audit-log-${new Date().toISOString().slice(0, 10)}.csv`; a.click();
    URL.revokeObjectURL(url);
  }
  return (
    <>
      <PageHeader title="Audit log" description="Who did what, and when. Read only." actions={<Button onClick={exportCsv} disabled={!list.rows?.length}>Export shown rows (CSV)</Button>} />
      <form className={ui.filters} onSubmit={(e) => { e.preventDefault(); setApplied({ entityType: entityType.trim(), entityId: entityId.trim(), actor: actor.trim() }); }}>
        <TextField label="Entity type" value={entityType} onChange={(e) => setEntityType(e.target.value)} placeholder="ride, wallet, verification" />
        <TextField label="Entity id" value={entityId} onChange={(e) => setEntityId(e.target.value)} />
        <TextField label="Staff id" value={actor} onChange={(e) => setActor(e.target.value)} />
        <Button type="submit">Filter</Button>
      </form>
      <DataTable label="Audit log" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} empty={{ title: 'No entries match' }}
        columns={[
          { header: 'When', cell: (r) => <When iso={r.at} exact /> },
          { header: 'Who', cell: (r) => (r.actorStaffId ? <span className={ui.num}>{shortId(r.actorStaffId)}</span> : 'System') },
          { header: 'Action', cell: (r) => <span className={ui.num}>{r.action}</span> },
          { header: 'Entity', cell: (r) => <>{humanize(r.entityType)} <span className={`${ui.num} ${ui.muted}`}>{shortId(r.entityId)}</span></> },
          { header: 'Detail', cell: (r) => <span className={ui.muted}>{r.detail ? Object.entries(r.detail).map(([k, v]) => `${k}: ${String(v)}`).join(' · ') : '—'}</span> },
        ]} />
    </>
  );
}
