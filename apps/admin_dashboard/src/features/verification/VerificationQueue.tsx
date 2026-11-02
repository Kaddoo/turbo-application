import { useState } from 'react';
import { useNavigate } from 'react-router';
import type { Schemas } from '@/types';
import {
  Button,
  Chip,
  DataTable,
  PageHeader,
  Select,
  useToast,
  ui,
  When,
  type Tone,
  CardTop,
  Callout,
  Fact,
  Facts,
  Figure,
  Person,
} from '@/components';
import { verificationTone } from '@/components/statusTones';
import { formatRelative, formatTime, humanize, maskPhone } from '@/utils/format';
import { ApiError, problemMessage } from '@/utils/problems';
import { useClaimVerification, useVerificationQueue } from './queries';

type VStatus = Schemas['VerificationStatus'];

function ageTone(iso: string): Tone {
  const h = (Date.now() - new Date(iso).getTime()) / 3_600_000;
  return h > 24 ? 'danger' : h > 4 ? 'warning' : 'neutral';
}

export function VerificationQueue() {
  const navigate = useNavigate();
  const toast = useToast();
  const [status, setStatus] = useState<VStatus>('pending');
  const list = useVerificationQueue(status);
  const rows = list.rows ? [...list.rows].sort((a, b) => a.submittedAt.localeCompare(b.submittedAt)) : undefined;

  const claim = useClaimVerification();
  async function open(id: string) {
    try {
      await claim.mutateAsync(id);
      navigate(`/verification/${id}`);
    } catch (e) {
      if (e instanceof ApiError && e.code === 'verification_claimed') toast(problemMessage(e));
      else toast(problemMessage(e));
    }
  }

  return (
    <>
      <PageHeader
        title="Verification queue"
        description="Approve or reject students quickly and safely. Opening a submission claims it for 15 minutes so nobody else reviews it at the same time."
        actions={
          status === 'pending' && rows?.length ? (
            <Button variant="primary" busy={claim.isPending} onClick={() => open(rows[0]!.id)}>
              Claim and review the oldest
            </Button>
          ) : undefined
        }
      />
      <div className={ui.filters}>
        <Select
          label="Status"
          value={status}
          onChange={(e) => setStatus(e.target.value as VStatus)}
          options={(['pending', 'needs_attention', 'approved', 'rejected'] as VStatus[]).map((v) => ({
            value: v,
            label: humanize(v),
          }))}
        />
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
        card={(r) => <SubmissionCard r={r} />}
        cardTone={(r) => ageTone(r.submittedAt)}
        columns={[
          {
            header: 'Student',
            cell: (r) => (
              <>
                <div>{r.student.fullName ?? 'Name not given'}</div>
                <div className={ui.muted}>{maskPhone(r.student.phone)}</div>
              </>
            ),
          },
          {
            header: 'Status',
            slot: 'badge',
            cell: (r) => <Chip tone={verificationTone[r.status]}>{humanize(r.status)}</Chip>,
          },
          { header: 'Submitted', cell: (r) => <When iso={r.submittedAt} exact /> },
          {
            header: 'Waiting',
            cell: (r) => <Chip tone={ageTone(r.submittedAt)}>{formatRelative(r.submittedAt)}</Chip>,
          },
          {
            header: 'Claimed',
            cell: (r) =>
              r.claimedBy && r.claimExpiresAt && new Date(r.claimExpiresAt) > new Date() ? (
                <span className={ui.muted}>Claimed until {formatTime(r.claimExpiresAt)}</span>
              ) : (
                <span className={ui.muted}>Free</span>
              ),
          },
        ]}
      />
    </>
  );
}

function SubmissionCard({ r }: { r: Schemas['VerificationSummary'] }) {
  const claimed = !!(r.claimedBy && r.claimExpiresAt && new Date(r.claimExpiresAt) > new Date());
  return (
    <>
      <CardTop end={<Chip tone={verificationTone[r.status]}>{humanize(r.status)}</Chip>}>
        <Person name={r.student.fullName ?? 'Name not given'} sub={maskPhone(r.student.phone)} size="lg" />
      </CardTop>
      <Facts>
        <Figure label="Waiting" tone={ageTone(r.submittedAt)}>
          {formatRelative(r.submittedAt)}
        </Figure>
        <Fact label="Submitted">
          <When iso={r.submittedAt} exact />
        </Fact>
      </Facts>
      {claimed ? (
        <Callout tone="accent" icon="lock">
          Being reviewed until {formatTime(r.claimExpiresAt)}
        </Callout>
      ) : (
        <Callout tone="neutral" icon="check">
          Free to claim
        </Callout>
      )}
    </>
  );
}
