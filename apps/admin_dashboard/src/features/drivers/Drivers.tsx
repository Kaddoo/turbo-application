import { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import type { Schemas } from '@/types';
import {
  Button,
  Card,
  Chip,
  ConfirmDialog,
  DataTable,
  Details,
  Dialog,
  DialogActions,
  ErrorState,
  Money,
  PageHeader,
  Select,
  Skeleton,
  TextField,
  useToast,
  ui,
  When,
} from '@/components';
import { accountTone } from '@/components/statusTones';
import { formatDate, formatPhone, humanize, maskPhone } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useAllVehicles } from '@/hooks';
import {
  useAddDriverDocument,
  useCreateDriver,
  useDriver,
  useDrivers,
  useExpiringDocuments,
  useSalaryProfile,
  useSaveSalaryProfile,
  useUpdateDriver,
} from './queries';

const docTypes: Schemas['DriverDocumentCreate']['type'][] = [
  'drivers_licence',
  'insurance',
  'roadworthy',
  'vehicle_registration',
  'ghana_card',
  'other',
];

export function Drivers() {
  const navigate = useNavigate();
  const toast = useToast();
  const [status, setStatus] = useState('');
  const [duty, setDuty] = useState('');
  const list = useDrivers(status, duty);
  const expiring = useExpiringDocuments();
  const vehicles = useAllVehicles();
  const [createOpen, setCreateOpen] = useState(false);
  const [form, setForm] = useState({ fullName: '', phone: '+233', email: '', vehicleId: '' });
  const create = useCreateDriver();

  return (
    <>
      <PageHeader
        title="Drivers"
        description="Salaried drivers. Creating one sends them an SMS invitation to the driver app."
        actions={
          <Button variant="primary" onClick={() => setCreateOpen(true)}>
            Add driver
          </Button>
        }
      />
      <Card title="Documents expiring in the next 30 days">
        {expiring.isPending ? (
          <Skeleton />
        ) : expiring.error ? (
          <ErrorState error={expiring.error} onRetry={() => void expiring.refetch()} />
        ) : expiring.data.items.length === 0 ? (
          <p className={ui.muted} style={{ margin: 0 }}>
            No documents expire in the next 30 days.
          </p>
        ) : (
          <div className={ui.stack} style={{ gap: 8 }}>
            {expiring.data.items.map((d) => (
              <div key={`${d.driverId}-${d.documentType}`} className={ui.row}>
                <Chip tone={d.daysLeft < 0 ? 'danger' : d.daysLeft <= 7 ? 'warning' : 'neutral'}>
                  {d.daysLeft < 0 ? `Expired ${-d.daysLeft} days ago` : `${d.daysLeft} days left`}
                </Chip>
                <button
                  type="button"
                  className={ui.muted}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', font: 'inherit', padding: 0 }}
                  onClick={() => navigate(`/drivers/${d.driverId}`)}
                >
                  <strong style={{ color: 'var(--color-text-primary)' }}>{d.driverName}</strong> ·{' '}
                  {humanize(d.documentType)} · {formatDate(d.expiresOn)}
                </button>
              </div>
            ))}
            {expiring.data.items.some((d) => d.daysLeft < 0) && (
              <p className={ui.muted} style={{ margin: 0 }}>
                A driver with an expired licence, insurance or roadworthy certificate cannot go on duty.
              </p>
            )}
          </div>
        )}
      </Card>
      <div className={ui.filters}>
        <Select
          label="Account"
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          options={[
            { value: '', label: 'Any' },
            { value: 'active', label: 'Active' },
            { value: 'suspended', label: 'Suspended' },
          ]}
        />
        <Select
          label="Duty"
          value={duty}
          onChange={(e) => setDuty(e.target.value)}
          options={[
            { value: '', label: 'Any' },
            { value: 'on_duty', label: 'On duty' },
            { value: 'off_duty', label: 'Off duty' },
          ]}
        />
      </div>
      <DataTable
        label="Drivers"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) => navigate(`/drivers/${r.id}`)}
        empty={{
          title: 'No drivers yet',
          body: 'Add the first driver. They get a text message to set up the driver app.',
          action: (
            <Button variant="primary" onClick={() => setCreateOpen(true)}>
              Add driver
            </Button>
          ),
        }}
        columns={[
          { header: 'Name', cell: (r) => r.fullName },
          { header: 'Phone', cell: (r) => maskPhone(r.phone) },
          {
            header: 'Duty',
            cell: (r) => (
              <Chip tone={r.dutyStatus === 'on_duty' ? 'success' : 'neutral'}>{humanize(r.dutyStatus)}</Chip>
            ),
          },
          { header: 'Account', cell: (r) => <Chip tone={accountTone[r.status]}>{humanize(r.status)}</Chip> },
          {
            header: 'Vehicle',
            cell: (r) =>
              r.vehicle ? (
                `${r.vehicle.plateNumber} · ${r.vehicle.make} ${r.vehicle.model}`
              ) : (
                <span className={ui.muted}>None</span>
              ),
          },
          {
            header: 'On a ride',
            cell: (r) => (r.currentRideId ? <Chip tone="accent">Yes</Chip> : <span className={ui.muted}>No</span>),
          },
        ]}
      />
      <Dialog open={createOpen} onClose={() => setCreateOpen(false)} title="Add a driver">
        <TextField
          label="Full name"
          value={form.fullName}
          onChange={(e) => setForm({ ...form, fullName: e.target.value })}
        />
        <TextField
          label="Phone number"
          value={form.phone}
          onChange={(e) => setForm({ ...form, phone: e.target.value.replace(/\s/g, '') })}
          hint="Format +233241234567. The invitation goes here by SMS."
        />
        <TextField
          label="Email (optional)"
          type="email"
          value={form.email}
          onChange={(e) => setForm({ ...form, email: e.target.value })}
        />
        <Select
          label="Vehicle"
          value={form.vehicleId}
          onChange={(e) => setForm({ ...form, vehicleId: e.target.value })}
          options={[
            { value: '', label: 'Assign later' },
            ...(vehicles.data?.data ?? [])
              .filter((v) => v.status === 'active')
              .map((v) => ({ value: v.id, label: `${v.plateNumber} · ${v.make} ${v.model}` })),
          ]}
        />
        {create.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(create.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setCreateOpen(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={create.isPending}
            disabled={form.fullName.trim().length < 2 || !/^\+233\d{9}$/.test(form.phone)}
            onClick={() =>
              create.mutate(
                {
                  fullName: form.fullName,
                  phone: form.phone,
                  ...(form.email ? { email: form.email } : {}),
                  vehicleId: form.vehicleId || null,
                },
                {
                  onSuccess: () => {
                    setCreateOpen(false);
                    setForm({ fullName: '', phone: '+233', email: '', vehicleId: '' });
                    toast('Driver added. Their invitation is on its way by SMS.');
                  },
                },
              )
            }
          >
            Add and invite
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

export function DriverDetail() {
  const { id = '' } = useParams();
  const toast = useToast();
  const q = useDriver(id);
  const vehicles = useAllVehicles();
  const salary = useSalaryProfile(id);
  const update = useUpdateDriver(id);
  const [docOpen, setDocOpen] = useState(false);
  const [doc, setDoc] = useState<{
    type: Schemas['DriverDocumentCreate']['type'];
    expiresOn: string;
    file: File | null;
  }>({ type: 'drivers_licence', expiresOn: '', file: null });
  const [salaryOpen, setSalaryOpen] = useState(false);
  const [salaryForm, setSalaryForm] = useState({
    cedis: '',
    payPeriod: 'monthly' as Schemas['SalaryProfileWrite']['payPeriod'],
  });
  const [suspendOpen, setSuspendOpen] = useState(false);

  const addDoc = useAddDriverDocument(id);
  const saveSalary = useSaveSalaryProfile(id);

  if (q.isPending)
    return (
      <Card>
        <Skeleton />
      </Card>
    );
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const d = q.data;
  const suspended = d.status === 'suspended';
  return (
    <>
      <PageHeader
        title={d.fullName}
        description={`Added ${formatDate(d.createdAt)}.`}
        actions={
          <>
            <Chip tone={d.dutyStatus === 'on_duty' ? 'success' : 'neutral'}>{humanize(d.dutyStatus)}</Chip>
            <Chip tone={accountTone[d.status]}>{humanize(d.status)}</Chip>
          </>
        }
      />
      <div className={ui.grid2}>
        <Card title="Details">
          <Details
            items={[
              ['Phone', formatPhone(d.phone)],
              ['Email', d.email ?? '—'],
              ['Last seen', <When iso={d.lastLocation?.recordedAt} />],
              ['Current ride', d.currentRideId ? <a href={`/rides/${d.currentRideId}`}>Open ride</a> : 'None'],
            ]}
          />
          <div className={ui.actions} style={{ marginTop: 16 }}>
            <Button variant={suspended ? 'primary' : 'danger'} onClick={() => setSuspendOpen(true)}>
              {suspended ? 'Reactivate' : 'Deactivate'}
            </Button>
          </div>
        </Card>
        <Card title="Vehicle">
          <Select
            label="Assigned vehicle"
            value={d.vehicle?.id ?? ''}
            disabled={update.isPending}
            onChange={(e) =>
              update.mutate({ vehicleId: e.target.value || null }, { onSuccess: () => toast('Vehicle updated.') })
            }
            options={[
              { value: '', label: 'None' },
              ...(vehicles.data?.data ?? [])
                .filter((v) => v.status === 'active' || v.id === d.vehicle?.id)
                .map((v) => ({ value: v.id, label: `${v.plateNumber} · ${v.make} ${v.model} (${v.colour})` })),
            ]}
          />
          {update.error ? (
            <p role="alert" className={ui.muted}>
              {problemMessage(update.error)}
            </p>
          ) : null}
        </Card>
        <Card
          title="Documents"
          actions={
            <Button small onClick={() => setDocOpen(true)}>
              Add document
            </Button>
          }
        >
          {d.documents?.length ? (
            <div className={ui.stack} style={{ gap: 8 }}>
              {d.documents.map((x) => {
                const expired = x.expiresOn ? new Date(x.expiresOn) < new Date() : false;
                return (
                  <div key={x.id} className={ui.row}>
                    <strong>{humanize(x.type)}</strong>
                    <span className={ui.muted}>{x.expiresOn ? `expires ${formatDate(x.expiresOn)}` : 'no expiry'}</span>
                    {expired && <Chip tone="danger">Expired</Chip>}
                  </div>
                );
              })}
            </div>
          ) : (
            <p className={ui.muted} style={{ margin: 0 }}>
              No documents yet. Add the licence, insurance and roadworthy certificate.
            </p>
          )}
        </Card>
        <Card
          title="Salary"
          actions={
            <Button
              small
              onClick={() => {
                setSalaryForm({
                  cedis: salary.data ? String(salary.data.monthlySalaryPesewas / 100) : '',
                  payPeriod: salary.data?.payPeriod ?? 'monthly',
                });
                setSalaryOpen(true);
              }}
            >
              Edit
            </Button>
          }
        >
          {salary.isPending ? (
            <Skeleton />
          ) : salary.data ? (
            <Details
              items={[
                ['Monthly salary', <Money pesewas={salary.data.monthlySalaryPesewas} />],
                ['Pay period', humanize(salary.data.payPeriod)],
                ['Updated', <When iso={salary.data.updatedAt} />],
              ]}
            />
          ) : (
            <p className={ui.muted} style={{ margin: 0 }}>
              No salary set yet.
            </p>
          )}
        </Card>
      </div>

      <ConfirmDialog
        open={suspendOpen}
        onClose={() => setSuspendOpen(false)}
        title={suspended ? 'Reactivate driver' : 'Deactivate driver'}
        body={
          suspended ? 'They can go on duty again.' : 'They cannot go on duty or receive rides. Their history stays.'
        }
        confirmLabel={suspended ? 'Reactivate' : 'Deactivate'}
        danger={!suspended}
        busy={update.isPending}
        error={update.error}
        onConfirm={() =>
          update.mutate(
            { status: suspended ? 'active' : 'suspended' },
            {
              onSuccess: () => {
                setSuspendOpen(false);
                toast(suspended ? 'Driver reactivated.' : 'Driver deactivated.');
              },
            },
          )
        }
      />

      <Dialog open={docOpen} onClose={() => setDocOpen(false)} title="Add a document">
        <Select
          label="Type"
          value={doc.type}
          onChange={(e) => setDoc({ ...doc, type: e.target.value as typeof doc.type })}
          options={docTypes.map((t) => ({ value: t, label: humanize(t) }))}
        />
        <TextField
          label="Expires on"
          type="date"
          value={doc.expiresOn}
          onChange={(e) => setDoc({ ...doc, expiresOn: e.target.value })}
          hint="Required for licence, insurance and roadworthy."
        />
        <TextField
          label="File"
          type="file"
          accept="image/jpeg,image/png,application/pdf"
          onChange={(e) => setDoc({ ...doc, file: e.target.files?.[0] ?? null })}
          hint="JPEG, PNG or PDF, up to 10 MB."
        />
        {addDoc.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(addDoc.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setDocOpen(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={addDoc.isPending}
            disabled={
              !doc.file || (['drivers_licence', 'insurance', 'roadworthy'].includes(doc.type) && !doc.expiresOn)
            }
            onClick={() =>
              addDoc.mutate(
                { type: doc.type, expiresOn: doc.expiresOn, file: doc.file! },
                {
                  onSuccess: () => {
                    setDocOpen(false);
                    toast('Document added.');
                  },
                },
              )
            }
          >
            Add document
          </Button>
        </DialogActions>
      </Dialog>

      <Dialog open={salaryOpen} onClose={() => setSalaryOpen(false)} title="Salary">
        <TextField
          label="Monthly salary (GH₵, whole cedis)"
          inputMode="numeric"
          value={salaryForm.cedis}
          onChange={(e) => setSalaryForm({ ...salaryForm, cedis: e.target.value.replace(/\D/g, '') })}
        />
        <Select
          label="Pay period"
          value={salaryForm.payPeriod}
          onChange={(e) => setSalaryForm({ ...salaryForm, payPeriod: e.target.value as typeof salaryForm.payPeriod })}
          options={['weekly', 'biweekly', 'monthly'].map((p) => ({ value: p, label: humanize(p) }))}
        />
        {saveSalary.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(saveSalary.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSalaryOpen(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={saveSalary.isPending}
            disabled={!salaryForm.cedis}
            onClick={() =>
              saveSalary.mutate(
                { monthlySalaryPesewas: Math.round(Number(salaryForm.cedis)) * 100, payPeriod: salaryForm.payPeriod },
                {
                  onSuccess: () => {
                    setSalaryOpen(false);
                    toast('Salary saved.');
                  },
                },
              )
            }
          >
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
