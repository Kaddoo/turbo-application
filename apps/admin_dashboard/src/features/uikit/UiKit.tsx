import { useState } from 'react';
import {
  Avatar,
  Badge,
  Banner,
  BarChart,
  BigNumber,
  Button,
  Card,
  Checkbox,
  Chip,
  ConfirmDialog,
  DataTable,
  Dialog,
  DialogActions,
  Donut,
  Drawer,
  EmptyState,
  ErrorState,
  FilterChip,
  HeroCard,
  IconButton,
  Menu,
  MetricCard,
  PageHeader,
  Pagination,
  Panel,
  RangeBars,
  SearchInput,
  SegmentedControl,
  Select,
  Skeleton,
  SkeletonCard,
  Slider,
  SortHeaderRow,
  Sparkline,
  StatTile,
  Switch,
  Tabs,
  TextArea,
  TextField,
  Tooltip,
  ui,
  useToast,
} from '@/components';
import { nextSort, type SortState } from '@/hooks';
import { ApiError } from '@/utils/problems';
import k from './uikit.module.css';

/**
 * Every shared component in each variant and state, with sample values.
 * Dev and demo builds only (not in production, not in the menu): a review
 * aid for design and QA. Sample data lives here, never inside components.
 */
const sampleSeries = [0, 1, 0, 2, 1, 3, 2, 2, 4, 3, 5, 4, 6, 5, 4, 6, 7, 5, 6, 8, 7, 6, 9, 8];
const sampleRows = [
  { id: '1', name: 'Ama Serwaa', status: 'On trip', fare: 3500 },
  { id: '2', name: 'Kofi Mensah', status: 'Finding a driver', fare: 1800 },
  { id: '3', name: 'Efua Badu', status: 'Driver on the way', fare: 2500 },
];
const networkError = new ApiError(0, null, undefined, 'network');

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className={k.section} aria-labelledby={`kit-${title}`}>
      <h2 id={`kit-${title}`} className={k.title}>
        {title}
      </h2>
      {children}
    </section>
  );
}

export function UiKit() {
  const toast = useToast();
  const [seg, setSeg] = useState<'a' | 'b'>('a');
  const [filter, setFilter] = useState<'24h' | '7d'>('24h');
  const [q, setQ] = useState('');
  const [on, setOn] = useState(true);
  const [slider, setSlider] = useState(15);
  const [page, setPage] = useState(3);
  const [tab, setTab] = useState<'one' | 'two'>('one');
  const [dialog, setDialog] = useState<'none' | 'dialog' | 'confirm' | 'danger' | 'drawer'>('none');
  const [sort, setSort] = useState<SortState | null>(null);
  const close = () => setDialog('none');

  return (
    <div className={ui.stack}>
      <PageHeader
        caption="Dev and demo only"
        title="Component library"
        description="Each shared component in every variant and state."
      />

      <Section title="Buttons">
        <div className={ui.row}>
          <Button variant="primary">Primary</Button>
          <Button>Secondary</Button>
          <Button variant="ghost">Ghost</Button>
          <Button variant="danger">Danger</Button>
          <Button variant="primary" icon="plus">
            With icon
          </Button>
          <Button small>Small</Button>
          <Button busy>Busy</Button>
          <Button disabled>Disabled</Button>
        </div>
        <div className={ui.row}>
          <IconButton icon="refresh" label="Outline" />
          <IconButton icon="filter" label="Ghost" variant="ghost" />
          <IconButton icon="chart" label="Filled" variant="filled" />
          <IconButton icon="plus" label="Accent" variant="accent" />
          <IconButton icon="arrowUpRight" label="Round" round />
          <IconButton icon="bell" label="With count" count={3} />
          <IconButton icon="close" label="Small" small />
          <IconButton icon="more" label="Disabled" disabled />
        </div>
      </Section>

      <Section title="Badges, chips, avatars">
        <div className={ui.row}>
          <Badge count={6} />
          <Badge count={3} tone="danger" />
          <Badge count={120} tone="neutral" />
          <Badge tone="success">Live</Badge>
          <Chip>Neutral</Chip>
          <Chip tone="success">Approved</Chip>
          <Chip tone="warning">Pending</Chip>
          <Chip tone="danger">Rejected</Chip>
          <Chip tone="accent">Assigned</Chip>
          <Chip variant="plain">3 queues</Chip>
          <Chip variant="solid">New</Chip>
          <Avatar name="Ama Serwaa" size="sm" />
          <Avatar name="Kofi Mensah" />
          <Avatar name="Efua Badu" size="lg" tone="accent" />
          <Avatar name="SOS alert" tone="danger" label="SOS alert" />
        </div>
      </Section>

      <Section title="Controls">
        <div className={k.grid}>
          <SegmentedControl
            label="Example"
            value={seg}
            onChange={setSeg}
            options={[
              { value: 'a', label: 'Operations' },
              { value: 'b', label: 'Back office' },
            ]}
          />
          <div className={ui.row}>
            <FilterChip
              label="Period"
              value={filter}
              onChange={setFilter}
              options={[
                { value: '24h', label: '24H' },
                { value: '7d', label: '7D' },
              ]}
            />
            <Menu
              label="Actions"
              items={[
                { key: 'a', label: 'Open', icon: 'external', onSelect: () => toast('Opened', { tone: 'info' }) },
                { key: 'b', label: 'Disabled item', disabled: true, onSelect: () => {} },
                { key: 'c', label: 'Delete', icon: 'close', danger: true, onSelect: () => {} },
              ]}
              renderTrigger={(t) => (
                <Button iconEnd="chevronDown" {...t}>
                  Menu
                </Button>
              )}
            />
            <Tooltip text="Tooltip on hover and focus">
              <Button variant="ghost">Tooltip</Button>
            </Tooltip>
          </div>
          <SearchInput label="Search students" value={q} onSearch={setQ} />
          <SearchInput label="Searching" value="Ama" onSearch={() => {}} loading />
          <Tabs
            value={tab}
            onChange={setTab}
            tabs={[
              { value: 'one', label: 'Queue' },
              { value: 'two', label: 'History' },
            ]}
          />
          <Pagination page={page} pageCount={9} onPage={setPage} />
        </div>
      </Section>

      <Section title="Form fields">
        <div className={k.grid}>
          <TextField label="Default" placeholder="Type here" />
          <TextField label="With hint" hint="As on the Ghana Card" />
          <TextField label="With error" error="Enter a phone number" defaultValue="024" />
          <TextField label="Disabled" disabled defaultValue="Locked" />
          <TextField label="Read only" readOnly defaultValue="GH₵35.00" />
          <Select
            label="Select"
            options={[
              { value: 'a', label: 'Any' },
              { value: 'b', label: 'Pending' },
            ]}
          />
          <TextArea label="Text area" hint="Shown to the student" />
          <div className={ui.stackTight}>
            <Checkbox label="Checkbox" defaultChecked />
            <Checkbox label="Disabled checkbox" disabled />
            <Switch label="Switch" checked={on} onChange={setOn} />
            <Switch label="Disabled switch" checked={false} onChange={() => {}} disabled />
          </div>
          <Slider
            label="Slider"
            value={slider}
            min={5}
            max={60}
            step={5}
            onChange={setSlider}
            format={(v) => `${v} s`}
          />
        </div>
      </Section>

      <Section title="Charts">
        <div className={k.grid}>
          <Card title="Sparkline">
            <Sparkline values={sampleSeries} summary="Sample trend rising to 9" />
          </Card>
          <Card title="Sparkline, danger, no baseline">
            <Sparkline
              values={sampleSeries.slice().reverse()}
              tone="danger"
              showBaseline={false}
              summary="Sample falling"
            />
          </Card>
          <Card title="Sparkline, no data">
            <Sparkline values={[]} summary="No data" />
          </Card>
          <Card title="Bar chart">
            <BarChart
              summary="Sample bars"
              emphasis={0}
              data={[
                { label: 'Mon', value: 4 },
                { label: 'Tue', value: 7 },
                { label: 'Wed', value: 2 },
                { label: 'Thu', value: 6 },
              ]}
            />
          </Card>
          <Card title="Range bars and donut">
            <div className={ui.stack}>
              <RangeBars value={6} max={10} summary="6 of 10" />
              <Donut value={61} max={100} summary="61 percent" />
            </div>
          </Card>
        </div>
      </Section>

      <Section title="Dashboard blocks">
        <div className={k.grid}>
          <MetricCard
            icon="verification"
            caption="People"
            title="Full state"
            valueLabel="Waiting"
            value="12"
            change={{ label: '4 new in 24H', direction: 'up', tone: 'warning' }}
            chart={<Sparkline values={sampleSeries} summary="Sample" />}
            footnote="Oldest sent 3 h ago"
            onOpen={() => {}}
          />
          <MetricCard
            icon="incidents"
            caption="Care"
            title="Urgent state"
            valueLabel="Open now"
            value="2"
            urgent
            change={{ label: '2 new in 24H', direction: 'up', tone: 'danger' }}
            chart={<Sparkline values={sampleSeries} tone="danger" summary="Sample" />}
          />
          <MetricCard icon="topups" caption="Finance" title="Loading state" valueLabel="Flagged" value="" loading />
          <MetricCard
            icon="topups"
            caption="Finance"
            title="Error state"
            valueLabel="Flagged"
            value=""
            error={networkError}
            onRetry={() => {}}
          />
          <HeroCard
            chip="New"
            title="Hero card"
            body="Accent gradient with two actions."
            primary={{ label: 'Primary', onClick: () => {} }}
            secondary={{ label: 'Secondary', onClick: () => {} }}
          />
          <HeroCard title="Hero loading" loading primary={{ label: 'Primary', onClick: () => {} }} />
        </div>
        <Panel
          caption="Last update · just now"
          icon="liveMap"
          title="Panel"
          tools={<IconButton icon="refresh" label="Refresh" />}
        >
          <BigNumber label="Big number" value="31" actions={<Button variant="primary">Action</Button>} />
          <SortHeaderRow
            label="Sort sample"
            sort={sort}
            onSort={(key) => setSort((s) => nextSort(s, key))}
            columns={[
              { key: 'a', label: 'Momentum', caption: 'Caption' },
              { key: 'b', label: 'General', caption: 'Caption' },
              { key: 'c', label: 'Risk', caption: 'Caption' },
              { key: 'd', label: 'Reward', caption: 'Caption' },
            ]}
          />
          <div className={k.tiles}>
            <StatTile label="Plain" value="4" chip="Now" />
            <StatTile label="With change" value="41" change={{ label: '1.2%', direction: 'down', tone: 'danger' }} />
            <StatTile
              label="With visual"
              value="60"
              unit="%"
              visual={<RangeBars value={6} max={10} summary="6 of 10" />}
            />
            <StatTile label="Loading" value="" loading />
          </div>
        </Panel>
      </Section>

      <Section title="Data table">
        <DataTable
          label="Sample rides"
          rows={sampleRows}
          rowKey={(r) => r.id}
          onRowClick={() => toast('Row opened', { tone: 'info' })}
          empty={{ title: 'Nothing here.' }}
          columns={[
            { header: 'Student', cell: (r) => r.name, sortValue: (r) => r.name },
            { header: 'Status', cell: (r) => r.status, sortValue: (r) => r.status },
            { header: 'Fare (pesewas)', cell: (r) => r.fare, align: 'right', sortValue: (r) => r.fare },
          ]}
        />
        <div className={k.grid}>
          <DataTable
            label="Loading"
            rows={undefined}
            loading
            rowKey={() => ''}
            skeletonRows={2}
            empty={{ title: '' }}
            columns={[{ header: 'A', cell: () => '' }]}
          />
          <DataTable
            label="Empty"
            rows={[]}
            rowKey={() => ''}
            empty={{ title: 'No rides yet.', body: 'Rides show here once booked.' }}
            columns={[{ header: 'A', cell: () => '' }]}
          />
          <DataTable
            label="Error"
            rows={undefined}
            error={networkError}
            onRetry={() => {}}
            rowKey={() => ''}
            empty={{ title: '' }}
            columns={[{ header: 'A', cell: () => '' }]}
          />
        </div>
      </Section>

      <Section title="Feedback">
        <Banner
          tone="danger"
          action={
            <Button small variant="danger">
              Act
            </Button>
          }
        >
          Danger banner with an action.
        </Banner>
        <Banner tone="warning" title="Warning" onDismiss={() => {}}>
          Warning banner with a title and close.
        </Banner>
        <Banner tone="success">Success banner.</Banner>
        <Banner tone="accent">Info banner.</Banner>
        <div className={ui.row}>
          <Button onClick={() => toast('Saved')}>Success toast</Button>
          <Button onClick={() => toast('Heads up', { tone: 'info' })}>Info toast</Button>
          <Button onClick={() => toast('Check this', { tone: 'warning' })}>Warning toast</Button>
          <Button onClick={() => toast('Could not save', { tone: 'danger' })}>Error toast (stays)</Button>
        </div>
      </Section>

      <Section title="Loading, empty, error">
        <div className={k.grid}>
          <Card>
            <div className={ui.stackTight}>
              <Skeleton />
              <Skeleton width="60%" />
              <Skeleton variant="block" />
              <Skeleton variant="circle" width="var(--space-10)" />
            </div>
          </Card>
          <SkeletonCard />
          <Card>
            <EmptyState title="Nothing waiting." body="New submissions show here." />
          </Card>
          <Card>
            <ErrorState error={networkError} onRetry={() => {}} />
          </Card>
        </div>
      </Section>

      <Section title="Dialogs">
        <div className={ui.row}>
          <Button onClick={() => setDialog('dialog')}>Dialog</Button>
          <Button onClick={() => setDialog('confirm')}>Confirm</Button>
          <Button variant="danger" onClick={() => setDialog('danger')}>
            Type to confirm
          </Button>
          <Button onClick={() => setDialog('drawer')}>Drawer</Button>
        </div>
        <Dialog open={dialog === 'dialog'} onClose={close} title="Dialog" description="With a description line.">
          <TextField label="Field inside" />
          <DialogActions>
            <Button variant="ghost" onClick={close}>
              Cancel
            </Button>
            <Button variant="primary" onClick={close}>
              Save
            </Button>
          </DialogActions>
        </Dialog>
        <ConfirmDialog
          open={dialog === 'confirm'}
          onClose={close}
          title="Approve?"
          body="This applies at once."
          confirmLabel="Approve"
          onConfirm={close}
        />
        <ConfirmDialog
          open={dialog === 'danger'}
          onClose={close}
          title="Delete for good?"
          body="This cannot be undone."
          confirmLabel="Delete"
          danger
          typeToConfirm="DELETE"
          onConfirm={close}
        />
        <Drawer open={dialog === 'drawer'} onClose={close} label="Sample drawer" side="right">
          <div className={k.drawerBody}>
            <PageHeader title="Drawer" description="Side sheet for details." />
            <Button onClick={close}>Close</Button>
          </div>
        </Drawer>
      </Section>
    </div>
  );
}
