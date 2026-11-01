import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router';
import { Button, Chip, Icon, Skeleton, cx } from '@/components';
import { useSession } from '@/state/session';
import { problemMessage } from '@/utils/problems';
import { roleLabels } from '@/utils/roles';
import {
  isComplete,
  readOnboarding,
  roleJobs,
  setupRoles,
  writeOnboarding,
  type OnboardingRecord,
  type SetupStep,
} from '@/utils/onboarding';
import { useSetup } from './queries';
import s from './onboarding.module.css';

/**
 * First-run card on the Overview. Super admin and HR get a checklist ticked
 * from live data (resumable anywhere, skippable with "Hide for now"); every
 * other role gets one card naming their job. Once put away, or once setup is
 * complete and acknowledged, it never shows again in this browser.
 */
export function Onboarding() {
  const { me } = useSession();
  const navigate = useNavigate();
  const role = me?.staffRole;
  const setupRole = !!role && setupRoles.includes(role);
  const setup = useSetup(setupRole ? role : undefined);
  const [record, setRecord] = useState<OnboardingRecord>(() => (me ? readOnboarding(me.id) : {}));
  const [firstVisit] = useState(() => !record.welcomedAt);

  const save = (patch: Partial<OnboardingRecord>) => {
    if (!me) return;
    const next = { ...record, ...patch };
    setRecord(next);
    writeOnboarding(me.id, next);
  };
  const now = () => new Date().toISOString();

  const complete = !!setup.steps && isComplete(setup.steps);
  useEffect(() => {
    if (!me) return;
    const patch: Partial<OnboardingRecord> = {};
    if (!record.welcomedAt) patch.welcomedAt = now();
    if (complete && !record.completedAt) patch.completedAt = now();
    if (Object.keys(patch).length) save(patch);
    // Saving only reacts to these two facts changing.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [me?.id, complete]);

  if (!me || !role || record.dismissedAt) return null;
  const first = me.fullName.split(' ')[0];
  const greeting = firstVisit ? `Welcome, ${first}` : null;

  // Roles with nothing to set up: one card, their job, one button.
  if (!setupRole) {
    const job = roleJobs[role];
    if (!job) return null;
    return (
      <section className={s.card} aria-labelledby="onboarding-title">
        <div className={s.head}>
          <span className={s.caption}>{roleLabels[role]}</span>
          <h2 id="onboarding-title" className={s.title}>
            {greeting ?? 'Your job here'}
          </h2>
          <p className={s.body}>{job.job}</p>
        </div>
        <div className={s.actions}>
          <Button
            variant="primary"
            iconEnd="arrowUpRight"
            onClick={() => {
              save({ dismissedAt: now() });
              navigate(job.to);
            }}
          >
            {job.action}
          </Button>
          <Button variant="ghost" onClick={() => save({ dismissedAt: now() })}>
            Got it
          </Button>
        </div>
      </section>
    );
  }

  const name = role === 'super_admin' ? 'Pilot setup' : 'Driver setup';
  const steps = setup.steps;
  const required = steps?.filter((x) => x.required) ?? [];
  const done = required.filter((x) => x.state === 'done').length;

  if (steps && complete) {
    return (
      <section className={cx(s.card, s.cardDone)} aria-labelledby="onboarding-title">
        <div className={s.doneRow}>
          <span className={s.doneMark} aria-hidden="true">
            <Icon name="check" />
          </span>
          <div className={s.head}>
            <span className={s.caption}>{name}</span>
            <h2 id="onboarding-title" className={s.title}>
              {role === 'super_admin' ? 'The pilot is ready to run' : 'Drivers are ready for the road'}
            </h2>
            <p className={s.body}>Every step is done. The menu has everything else; this card will not show again.</p>
          </div>
          <Button variant="primary" onClick={() => save({ dismissedAt: now() })}>
            Done
          </Button>
        </div>
      </section>
    );
  }

  if (record.collapsedAt) {
    return (
      <section className={s.bar} aria-label={name}>
        <Icon name="check" size="sm" />
        <span className={s.barText}>
          <strong>{name}</strong>
          {steps ? ` · ${done} of ${required.length} done` : ''}
        </span>
        <Button small onClick={() => save({ collapsedAt: undefined })}>
          Continue setup
        </Button>
      </section>
    );
  }

  return (
    <section className={s.card} aria-labelledby="onboarding-title">
      <div className={s.topRow}>
        <div className={s.head}>
          <span className={s.caption}>{name}</span>
          <h2 id="onboarding-title" className={s.title}>
            {greeting ?? 'Finish setting up'}
          </h2>
          <p className={s.body}>
            {role === 'super_admin'
              ? 'A few things must be in place before students can book. Each step ticks itself when it is done, wherever you do it.'
              : 'Drivers need a vehicle, documents and a shift before they can take rides. Each step ticks itself when it is done.'}
          </p>
        </div>
        <Button variant="ghost" small onClick={() => save({ collapsedAt: now() })}>
          Hide for now
        </Button>
      </div>

      {steps && (
        <div className={s.progress}>
          <div
            className={s.track}
            role="progressbar"
            aria-label={`${name} progress`}
            aria-valuemin={0}
            aria-valuemax={required.length}
            aria-valuenow={done}
            aria-valuetext={`${done} of ${required.length} done`}
          >
            <span className={s.fill} style={{ width: `${(done / Math.max(required.length, 1)) * 100}%` }} />
          </div>
          <span className={s.count}>
            {done} of {required.length} done
          </span>
        </div>
      )}

      {setup.loading ? (
        <div className={s.loading} aria-busy="true" aria-label="Checking setup">
          <Skeleton />
          <Skeleton width="80%" />
          <Skeleton width="60%" />
        </div>
      ) : setup.error ? (
        <div className={s.error} role="alert">
          <p className={s.body}>We could not check your setup. {problemMessage(setup.error)}</p>
          <Button small icon="refresh" onClick={setup.retry}>
            Try again
          </Button>
        </div>
      ) : steps ? (
        <ol className={s.steps}>
          {steps.map((step, i) => (
            <Step key={step.id} step={step} n={i + 1} onOpen={() => navigate(step.to)} />
          ))}
        </ol>
      ) : null}
    </section>
  );
}

function Step({ step, n, onOpen }: { step: SetupStep; n: number; onOpen: () => void }) {
  const done = step.state === 'done';
  return (
    <li className={cx(s.step, done && s.stepDone)}>
      <span className={cx(s.marker, done && s.markerDone)} aria-hidden="true">
        {done ? <Icon name="check" size="sm" /> : n}
      </span>
      <div className={s.stepText}>
        <span className={s.stepTitle}>
          {step.title}
          <span className={s.visuallyHidden}>{done ? ' (done)' : step.state === 'later' ? ' (can wait)' : ''}</span>
          {step.state === 'later' && <Chip tone="neutral">Can wait</Chip>}
        </span>
        <span className={s.stepBody}>{step.body}</span>
      </div>
      {!done && (
        <Button small variant={step.state === 'later' ? 'ghost' : 'secondary'} onClick={onOpen}>
          {step.action}
        </Button>
      )}
    </li>
  );
}
