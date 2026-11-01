import { useState } from 'react';
import type { Schemas } from '@/types';
import { Button, Card, Chip, Dialog, DialogActions, PageHeader, Select, TextArea, TextField, useToast, ui, When } from '@/components';
import { humanize } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useSendAnnouncement } from './queries';

export function Announcements() {
  const toast = useToast();
  const [form, setForm] = useState<Schemas['AnnouncementCreate']>({ audience: 'students', title: '', body: '' });
  const [preview, setPreview] = useState(false);
  const [sent, setSent] = useState<Schemas['Announcement'][]>([]);
  const send = useSendAnnouncement();
  return (
    <>
      <PageHeader title="Announcements" description="Push a short message to students, drivers or everyone. Preview before sending; it cannot be recalled." />
      <div className={ui.grid2}>
        <Card title="New announcement">
          <div className={ui.stack}>
            <Select label="Send to" value={form.audience} onChange={(e) => setForm({ ...form, audience: e.target.value as typeof form.audience })}
              options={[{ value: 'students', label: 'Students' }, { value: 'drivers', label: 'Drivers' }, { value: 'all', label: 'Everyone' }]} />
            <TextField label="Title" maxLength={80} value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
            <TextArea label="Message" maxLength={300} value={form.body} onChange={(e) => setForm({ ...form, body: e.target.value })} hint={`${form.body.length}/300`} />
            <div className={ui.actions}><Button variant="primary" disabled={form.title.trim().length < 3 || form.body.trim().length < 3} onClick={() => setPreview(true)}>Preview</Button></div>
          </div>
        </Card>
        <Card title="Sent this session">
          {sent.length === 0 ? <p className={ui.muted} style={{ margin: 0 }}>Nothing sent yet. The contract has no announcement history yet.</p> : sent.map((a) => (
            <div key={a.id} style={{ marginBottom: 12 }}>
              <strong>{a.title}</strong> <Chip>{humanize(a.audience)}</Chip>
              <div className={ui.muted}>{a.body}</div>
              <div className={ui.muted}>{a.recipientCount != null ? `${a.recipientCount} recipients · ` : ''}<When iso={a.createdAt} /></div>
            </div>
          ))}
        </Card>
      </div>
      <Dialog open={preview} onClose={() => setPreview(false)} title="Send this announcement?">
        <div className={ui.card}>
          <strong>{form.title}</strong>
          <p style={{ margin: '6px 0 0' }}>{form.body}</p>
        </div>
        <p className={ui.muted} style={{ margin: 0 }}>Goes to {form.audience === 'all' ? 'every student and driver' : `every ${form.audience.slice(0, -1)}`} as a push notification.</p>
        {send.error ? <p role="alert" className={ui.muted}>{problemMessage(send.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setPreview(false)}>Edit</Button>
          <Button variant="primary" busy={send.isPending} onClick={() => send.mutate(form, { onSuccess: (a) => { setSent((x) => [a, ...x]); setPreview(false); setForm({ ...form, title: '', body: '' }); toast('Announcement sent.'); } })}>Send now</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
