import { useState } from 'react';
import type { Schemas } from '@/types';
import {
  Button,
  Chip,
  DataTable,
  Dialog,
  DialogActions,
  PageHeader,
  Select,
  TextField,
  useToast,
  ui,
  type Tone,
} from '@/components';
import { humanize } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useSaveVehicle, useVehicles } from './queries';

const vehicleTone: Record<Schemas['Vehicle']['status'], Tone> = {
  active: 'success',
  maintenance: 'warning',
  retired: 'neutral',
};
const emptyVehicle: Schemas['VehicleWrite'] = {
  make: '',
  model: '',
  colour: '',
  plateNumber: '',
  seats: 4,
  status: 'active',
};

export function Vehicles() {
  const toast = useToast();
  const list = useVehicles();
  const [editing, setEditing] = useState<{ id: string | null; form: Schemas['VehicleWrite'] } | null>(null);
  const save = useSaveVehicle();
  const f = editing?.form;
  const set = (patch: Partial<Schemas['VehicleWrite']>) =>
    editing && setEditing({ ...editing, form: { ...editing.form, ...patch } });
  return (
    <>
      <PageHeader
        title="Vehicles"
        description="Each vehicle is driven by one driver at a time. Assign them on the driver’s page."
        actions={
          <Button variant="primary" onClick={() => setEditing({ id: null, form: emptyVehicle })}>
            Add vehicle
          </Button>
        }
      />
      <DataTable
        label="Vehicles"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) =>
          setEditing({
            id: r.id,
            form: {
              make: r.make,
              model: r.model,
              colour: r.colour,
              plateNumber: r.plateNumber,
              seats: r.seats ?? 4,
              status: r.status,
            },
          })
        }
        empty={{
          title: 'No vehicles yet',
          body: 'Add the cars drivers use, then assign each one to a driver.',
          action: (
            <Button variant="primary" onClick={() => setEditing({ id: null, form: emptyVehicle })}>
              Add vehicle
            </Button>
          ),
        }}
        columns={[
          { header: 'Plate', cell: (r) => <span className={ui.num}>{r.plateNumber}</span> },
          { header: 'Vehicle', cell: (r) => `${r.make} ${r.model}` },
          { header: 'Colour', cell: (r) => r.colour },
          { header: 'Seats', align: 'right', cell: (r) => r.seats ?? '—' },
          { header: 'Status', cell: (r) => <Chip tone={vehicleTone[r.status]}>{humanize(r.status)}</Chip> },
        ]}
      />
      <Dialog open={!!editing} onClose={() => setEditing(null)} title={editing?.id ? 'Edit vehicle' : 'Add vehicle'}>
        {f && (
          <>
            <TextField
              label="Plate number"
              value={f.plateNumber}
              onChange={(e) => set({ plateNumber: e.target.value.toUpperCase() })}
            />
            <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
              <TextField label="Make" value={f.make} onChange={(e) => set({ make: e.target.value })} />
              <TextField label="Model" value={f.model} onChange={(e) => set({ model: e.target.value })} />
              <TextField label="Colour" value={f.colour} onChange={(e) => set({ colour: e.target.value })} />
              <TextField
                label="Seats"
                type="number"
                min={1}
                max={8}
                value={f.seats ?? 4}
                onChange={(e) => set({ seats: Number(e.target.value) })}
              />
            </div>
            <Select
              label="Status"
              value={f.status ?? 'active'}
              onChange={(e) => set({ status: e.target.value as Schemas['Vehicle']['status'] })}
              options={['active', 'maintenance', 'retired'].map((s) => ({ value: s, label: humanize(s) }))}
            />
          </>
        )}
        {save.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(save.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setEditing(null)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={save.isPending}
            disabled={!f?.plateNumber || !f.make || !f.model || !f.colour}
            onClick={() =>
              save.mutate(editing!, {
                onSuccess: () => {
                  setEditing(null);
                  toast('Vehicle saved.');
                },
              })
            }
          >
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
