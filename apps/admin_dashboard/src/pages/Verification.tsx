import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useNavigate, useParams } from 'react-router';
import { api, call } from '@/services/http';
import type { Schemas } from '@/types';
import {
  Banner, Button, Card, Chip, DataTable, Details, Dialog, DialogActions, PageHeader, Select, Skeleton, TextArea,
  ErrorState, useToast, ui, When, type Tone,
} from '@/components';
import { formatRelative, formatTime, humanize, maskPhone } from '@/utils/format';
import { ApiError, problemMessage } from '@/utils/problems';
import { useAction, useCursorList } from '@/hooks';

type VStatus = Schemas['VerificationStatus'];
export const verificationTone: Record<VStatus, Tone> = {
  not_submitted: 'neutral', pending: 'warning', needs_attention: 'warning', approved: 'success', rejected: 'danger',
};

function ageTone(iso: string): Tone {
  const h = (Date.now() - new Date(iso).getTime()) / 3_600_000;
  return h > 24 ? 'danger' : h > 4 ? 'warning' : 'neutral';
}

export function VerificationQueuePage() {
  const navigate = useNavigate();
  const toast = useToast();
  const [status, setStatus] = useState<VStatus>('pending');
  const list = useCursorList(['verifications', status], (cursor) =>
    call(api.GET('/admin/verifications', { params: { query: { status, cursor, limit: 25 } } })));
  const rows = list.rows ? [...list.rows].sort((a, b) => a.submittedAt.localeCompare(b.submittedAt)) : undefined;

  const claim = useAction((id: string) => call(api.POST('/admin/verifications/{id}/claim', { params: { path: { id } } })), [['verifications']]);
  async function open(id: string) {
    try { await claim.mutateAsync(id); navigate(`/verification/${id}`); }
    catch (e) {
      if (e instanceof ApiError && e.code === 'verification_claimed') toast(problemMessage(e));
      else toast(problemMessage(e));
    }
  }

  return (
    <>
      <PageHeader
        title="Verification queue"
        description="Approve or reject students quickly and safely. Opening a submission claims it for 15 minutes so nobody else reviews it at the same time."
        actions={status === 'pending' && rows?.length ? <Button variant="primary" busy={claim.isPending} onClick={() => open(rows[0]!.id)}>Claim and review the oldest</Button> : undefined}
      />
      <div className={ui.filters}>
        <Select label="Status" value={status} onChange={(e) => setStatus(e.target.value as VStatus)}
          options={(['pending', 'needs_attention', 'approved', 'rejected'] as VStatus[]).map((v) => ({ value: v, label: humanize(v) }))} />
      </div>
      <DataTable
        label="Verification submissions"
        rows={rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) => (r.status === 'pending' ? void open(r.id) : navigate(`/verification/${r.id}`))}
        empty={{ title: 'No submissions waiting', body: 'New submissions appear here oldest first.' }}
        columns={[
          { header: 'Student', cell: (r) => <><div>{r.student.fullName ?? 'Name not given'}</div><div className={ui.muted}>{maskPhone(r.student.phone)}</div></> },
          { header: 'Status', cell: (r) => <Chip tone={verificationTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: 'Submitted', cell: (r) => <When iso={r.submittedAt} exact /> },
          { header: 'Waiting', cell: (r) => <Chip tone={ageTone(r.submittedAt)}>{formatRelative(r.submittedAt)}</Chip> },
          { header: 'Claimed', cell: (r) => (r.claimedBy && r.claimExpiresAt && new Date(r.claimExpiresAt) > new Date()
            ? <span className={ui.muted}>Claimed until {formatTime(r.claimExpiresAt)}</span> : <span className={ui.muted}>Free</span>) },
        ]}
      />
    </>
  );
}

const docLabels: Record<Schemas['VerificationDocument']['purpose'], string> = {
  ghana_card_front: 'Ghana Card, front', ghana_card_back: 'Ghana Card, back', student_id: 'Student ID', selfie_with_card: 'Selfie holding the card',
};

const checklist = ['Name matches on both documents', 'Photo matches the selfie', 'Ghana Card is not expired', 'Student ID is for this academic year'];
const reasonCodes = ['document_unclear', 'name_mismatch', 'expired_id', 'photo_mismatch', 'not_a_student', 'other'];

export function VerificationReviewPage() {
  const { id = '' } = useParams();
  const navigate = useNavigate();
  const toast = useToast();
  const q = useQuery({ queryKey: ['verification', id], queryFn: () => call(api.GET('/admin/verifications/{id}', { params: { path: { id } } })) });
  const [viewedAt] = useState(() => new Date().toISOString());
  const [checked, setChecked] = useState<boolean[]>(checklist.map(() => false));
  const [deciding, setDeciding] = useState<'rejected' | 'needs_attention' | null>(null);
  const [reasonCode, setReasonCode] = useState(reasonCodes[0]!);
  const [studentMessage, setStudentMessage] = useState('');
  const [internalNote, setInternalNote] = useState('');
  const [zoom, setZoom] = useState<string | null>(null);

  const decide = useAction((body: Schemas['VerificationDecision']) =>
    call(api.POST('/admin/verifications/{id}/decision', { params: { path: { id } }, body })), [['verifications'], ['verification', id], ['ov']]);

  async function submit(decision: Schemas['VerificationDecision']['decision']) {
    try {
      await decide.mutateAsync(decision === 'approved'
        ? { decision }
        : { decision, reasonCode, studentMessage, ...(internalNote ? { internalNote } : {}) });
      toast(decision === 'approved' ? 'Approved. The student has been told by push and SMS.' : 'Decision sent to the student.');
      navigate('/verification');
    } catch { /* shown below */ }
  }

  if (q.isPending) return <Card><Skeleton /><br /><Skeleton width="60%" /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const v = q.data;
  const dup = decide.error instanceof ApiError && decide.error.code === 'duplicate_identity';

  return (
    <>
      <PageHeader
        title={v.submittedFullName}
        description={`Submitted ${formatRelative(v.submittedAt)}. Compare the documents with the typed details, then decide.`}
        actions={<>
          <Chip tone={verificationTone[v.status]}>{humanize(v.status)}</Chip>
          <Button variant="ghost" onClick={() => navigate('/verification')}>Back to queue</Button>
        </>}
      />
      <div className={ui.grid2}>
        <Card title="Documents">
          <p className={ui.muted} style={{ marginTop: 0 }}>
            Viewed by you at {formatTime(viewedAt)}, logged. Links expire in minutes and are never saved.
          </p>
          <div className={ui.grid2} style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(12rem, 1fr))' }}>
            {v.documents.map((d) => (
              <figure key={d.purpose} style={{ margin: 0 }}>
                <button type="button" onClick={() => setZoom(d.url)} style={{ padding: 0, border: 'none', background: 'none', cursor: 'zoom-in', width: '100%' }}
                  aria-label={`Zoom ${docLabels[d.purpose]}`}>
                  <img src={d.url} alt={docLabels[d.purpose]} referrerPolicy="no-referrer" style={{ width: '100%', aspectRatio: '3 / 2', objectFit: 'cover' }} className={ui.card} />
                </button>
                <figcaption className={ui.muted}>{docLabels[d.purpose]}</figcaption>
              </figure>
            ))}
          </div>
        </Card>
        <div className={ui.stack}>
          <Card title="Typed details">
            <Details items={[
              ['Full name', v.submittedFullName],
              ['Student ID number', <span className={ui.num}>{v.studentIdNumber}</span>],
              ['Ghana Card number', <span className={ui.num}>{v.ghanaCardNumber}</span>],
              ['Phone', maskPhone(v.student.phone)],
              ['Earlier no-shows', String(v.student.noShowCount ?? 0)],
            ]} />
          </Card>
          <Card title="Checklist">
            <div className={ui.stack} style={{ gap: 8 }}>
              {checklist.map((c, i) => (
                <label key={c} className={ui.row} style={{ minHeight: 32 }}>
                  <input type="checkbox" checked={checked[i]} onChange={(e) => setChecked((x) => x.map((y, j) => (j === i ? e.target.checked : y)))} />
                  {c}
                </label>
              ))}
            </div>
          </Card>
          {v.history.length > 0 && (
            <Card title="Earlier decisions">
              {v.history.map((h) => (
                <p key={h.decidedAt} style={{ margin: '0 0 8px' }}>
                  <Chip tone={verificationTone[h.decision]}>{humanize(h.decision)}</Chip>{' '}
                  {h.reasonCode && humanize(h.reasonCode)} · <When iso={h.decidedAt} />
                </p>
              ))}
            </Card>
          )}
          {dup && <Banner tone="danger">This Ghana Card is already linked to another account. Reject this one, and check the other account under Students.</Banner>}
          {decide.error && !dup && !deciding ? <Banner tone="danger">{problemMessage(decide.error)}</Banner> : null}
          {v.status === 'pending' && (
            <div className={ui.actions}>
              <Button variant="primary" busy={decide.isPending} disabled={!checked.every(Boolean)} onClick={() => void submit('approved')}>Approve</Button>
              <Button onClick={() => setDeciding('needs_attention')}>Needs attention</Button>
              <Button variant="danger" onClick={() => setDeciding('rejected')}>Reject</Button>
              {!checked.every(Boolean) && <span className={ui.muted}>Tick every check to approve.</span>}
            </div>
          )}
        </div>
      </div>
      <Dialog open={!!deciding} onClose={() => setDeciding(null)} title={deciding === 'rejected' ? 'Reject this submission' : 'Ask the student to resubmit'}>
        <p className={ui.muted} style={{ margin: 0 }}>
          {deciding === 'rejected' ? 'Rejection is final for this account. Staff can reopen it only by hand.' : 'The student can fix the problem and send the documents again.'}
        </p>
        <Select label="Reason" value={reasonCode} onChange={(e) => setReasonCode(e.target.value)} options={reasonCodes.map((r) => ({ value: r, label: humanize(r) }))} />
        <TextArea label="Message to the student" hint="Plain words. They see this in the app and by SMS." maxLength={500} value={studentMessage} onChange={(e) => setStudentMessage(e.target.value)} />
        <TextArea label="Internal note (optional)" maxLength={1000} value={internalNote} onChange={(e) => setInternalNote(e.target.value)} />
        {decide.error ? <p role="alert" className={ui.muted}>{problemMessage(decide.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setDeciding(null)}>Cancel</Button>
          <Button variant={deciding === 'rejected' ? 'danger' : 'primary'} busy={decide.isPending} disabled={studentMessage.trim().length < 3}
            onClick={() => deciding && void submit(deciding)}>
            {deciding === 'rejected' ? 'Reject' : 'Send back'}
          </Button>
        </DialogActions>
      </Dialog>
      <Dialog open={!!zoom} onClose={() => setZoom(null)} title="Document">
        {zoom && <img src={zoom} alt="Document, enlarged" referrerPolicy="no-referrer" style={{ width: '100%' }} />}
        <DialogActions><Button onClick={() => setZoom(null)}>Close</Button></DialogActions>
      </Dialog>
    </>
  );
}
