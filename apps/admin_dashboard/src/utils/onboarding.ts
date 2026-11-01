import type { Schemas } from '@/types';
import type { StaffRole } from './roles';

/**
 * Onboarding for staff. What is set up is never stored: every checklist tick
 * is worked out from live data, so progress survives leaving halfway, another
 * computer, or another person doing the step.
 *
 * What is stored is only whether this person has seen and put away the
 * welcome card. The contract has nowhere to keep that (CONTRACT_REQUESTS A32:
 * `onboardingCompletedAt` on StaffUser), so for now it lives in this
 * browser, keyed by staff id. A new computer shows the welcome card once more.
 */
export interface OnboardingRecord {
  /** First time the welcome card was shown. */
  welcomedAt?: string;
  /** Setup roles: the checklist was folded into a one-line bar. */
  collapsedAt?: string;
  /** Every required step was done (seen once; then the success card can be put away). */
  completedAt?: string;
  /** The card was put away for good. */
  dismissedAt?: string;
}

const keyFor = (staffId: string) => `admin.onboarding.${staffId}`;

export function readOnboarding(staffId: string): OnboardingRecord {
  try {
    const raw = localStorage.getItem(keyFor(staffId));
    const parsed: unknown = raw ? JSON.parse(raw) : {};
    return parsed && typeof parsed === 'object' ? (parsed as OnboardingRecord) : {};
  } catch {
    return {};
  }
}

export function writeOnboarding(staffId: string, record: OnboardingRecord): void {
  try {
    localStorage.setItem(keyFor(staffId), JSON.stringify(record));
  } catch {
    /* storage blocked: the card simply shows again next time */
  }
}

/** Roles with something to set up before the dashboard is useful. */
export const setupRoles: StaffRole[] = ['super_admin', 'hr'];

/** Every role but super admin must be covered before the pilot runs. */
export const teamRoles: StaffRole[] = ['verifier', 'dispatcher', 'finance', 'support', 'hr'];

/** Documents a driver needs before going on duty (prompts/02, driver detail). */
export const requiredDocuments: Schemas['DriverDocument']['type'][] = ['drivers_licence', 'insurance', 'roadworthy'];

export type StepState = 'done' | 'todo' | 'later';

export interface SetupStep {
  id: string;
  title: string;
  /** What to do, or what is still missing. */
  body: string;
  state: StepState;
  /** Must be done for setup to count as complete. */
  required: boolean;
  to: string;
  action: string;
}

export interface SuperAdminData {
  serviceArea: Schemas['ServiceArea'];
  settings: Schemas['Settings'];
  staff: Schemas['StaffUser'][];
  drivers: Schemas['DriverDetail'][];
}

const roleNames: Record<StaffRole, string> = {
  super_admin: 'super admin',
  verifier: 'verifier',
  dispatcher: 'dispatcher',
  finance: 'finance',
  support: 'support',
  hr: 'HR',
};

const list = (items: string[]) =>
  items.length <= 1 ? items.join('') : `${items.slice(0, -1).join(', ')} and ${items[items.length - 1]}`;

/** A driver is ready when they have a vehicle and the three required documents. */
export function driverReady(d: Schemas['DriverDetail']): boolean {
  const types = new Set((d.documents ?? []).map((x) => x.type));
  return !!d.vehicle && requiredDocuments.every((t) => types.has(t));
}

/** Pilot setup for the super admin, ticked from live data. */
export function superAdminSteps({ serviceArea, settings, staff, drivers }: SuperAdminData): SetupStep[] {
  const activePoints = serviceArea.pickupPoints.filter((p) => p.isActive).length;
  const missingRoles = teamRoles.filter((r) => !staff.some((s) => s.isActive && s.staffRole === r));
  const ready = drivers.filter(driverReady).length;
  return [
    {
      id: 'boundary',
      title: 'Draw the service boundary',
      body: serviceArea.boundary
        ? 'Students can book inside it.'
        : 'Nobody can book until the area students ride in is drawn.',
      state: serviceArea.boundary ? 'done' : 'todo',
      required: true,
      to: '/configuration',
      action: 'Draw boundary',
    },
    {
      id: 'pickupPoints',
      title: 'Add pickup points',
      body: activePoints
        ? `${activePoints} active pickup ${activePoints === 1 ? 'point' : 'points'}.`
        : 'Add the gates and halls students wait at.',
      state: activePoints ? 'done' : 'todo',
      required: true,
      to: '/configuration?tab=pickups',
      action: 'Add pickup points',
    },
    {
      id: 'hours',
      title: 'Set operating hours',
      body: settings.operatingHours ? 'Bookings open only in these hours.' : 'Say when students can book rides.',
      state: settings.operatingHours ? 'done' : 'todo',
      required: true,
      to: '/configuration?tab=settings',
      action: 'Set hours',
    },
    {
      id: 'fares',
      title: 'Check the fares',
      body: serviceArea.fareBands.length
        ? `${serviceArea.fareBands.length} fare bands are set. Check them before launch.`
        : 'Add fare bands by distance.',
      state: serviceArea.fareBands.length ? 'done' : 'todo',
      required: true,
      to: '/configuration?tab=fares',
      action: 'Review fares',
    },
    {
      id: 'team',
      title: 'Invite the team',
      body: missingRoles.length
        ? `Still to invite: ${list(missingRoles.map((r) => roleNames[r]))}.`
        : 'Every job has someone.',
      state: missingRoles.length ? 'todo' : 'done',
      required: true,
      to: '/staff',
      action: 'Invite staff',
    },
    {
      id: 'drivers',
      title: 'Get a driver ready',
      body: ready
        ? `${ready} ${ready === 1 ? 'driver has' : 'drivers have'} a vehicle and documents.`
        : 'HR adds drivers, their vehicles and documents. At least one must be ready.',
      state: ready ? 'done' : 'todo',
      required: true,
      to: '/drivers',
      action: 'Open drivers',
    },
  ];
}

export interface HrData {
  drivers: Schemas['DriverDetail'][];
  shiftsThisWeek: Schemas['Shift'][];
}

/** Getting drivers on the road, for HR, ticked from live data. */
export function hrSteps({ drivers, shiftsThisWeek }: HrData): SetupStep[] {
  const noVehicle = drivers.filter((d) => !d.vehicle).length;
  const missingDocs = drivers.filter(
    (d) => !requiredDocuments.every((t) => (d.documents ?? []).some((x) => x.type === t)),
  ).length;
  const has = drivers.length > 0;
  return [
    {
      id: 'driver',
      title: 'Add your first driver',
      body: has
        ? `${drivers.length} ${drivers.length === 1 ? 'driver' : 'drivers'} added.`
        : 'They get a text message to set up the driver app.',
      state: has ? 'done' : 'todo',
      required: true,
      to: '/drivers',
      action: 'Add driver',
    },
    {
      id: 'vehicle',
      title: 'Give every driver a vehicle',
      body: !has
        ? 'Add a driver first.'
        : noVehicle
          ? `${noVehicle} ${noVehicle === 1 ? 'driver has' : 'drivers have'} no vehicle.`
          : 'Every driver has a vehicle.',
      state: has && !noVehicle ? 'done' : 'todo',
      required: true,
      to: '/vehicles',
      action: 'Open vehicles',
    },
    {
      id: 'documents',
      title: 'Upload driver documents',
      body: !has
        ? 'Licence, insurance and roadworthy certificate for each driver.'
        : missingDocs
          ? `${missingDocs} ${missingDocs === 1 ? 'driver is' : 'drivers are'} missing the licence, insurance or roadworthy certificate.`
          : 'Every driver has the licence, insurance and roadworthy certificate.',
      state: has && !missingDocs ? 'done' : 'todo',
      required: true,
      to: '/drivers',
      action: 'Open drivers',
    },
    {
      id: 'shifts',
      title: "Schedule this week's shifts",
      body: shiftsThisWeek.length
        ? `${shiftsThisWeek.length} ${shiftsThisWeek.length === 1 ? 'shift' : 'shifts'} in the next 7 days.`
        : 'Drivers can only go on duty during a shift.',
      state: shiftsThisWeek.length ? 'done' : 'todo',
      required: true,
      to: '/salary/shifts',
      action: 'Schedule shifts',
    },
    {
      id: 'salary',
      title: 'Set salary profiles',
      body: 'Can wait until the first pay run. Set it on each driver’s page.',
      state: 'later',
      required: false,
      to: '/drivers',
      action: 'Open drivers',
    },
  ];
}

export const isComplete = (steps: SetupStep[]) => steps.every((s) => !s.required || s.state === 'done');

/** The one job each role without setup comes here to do. */
export const roleJobs: Partial<Record<StaffRole, { job: string; to: string; action: string }>> = {
  verifier: {
    job: 'You check that students are who they say they are. Take the oldest submission, compare the documents, then approve, reject or ask for more.',
    to: '/verification',
    action: 'Open the review queue',
  },
  dispatcher: {
    job: 'You keep rides moving. Watch the live map, reassign stuck rides and send announcements when something changes on campus.',
    to: '/live',
    action: 'Open the live map',
  },
  finance: {
    job: 'You keep the money right. Clear flagged top-ups first, then approve or reject wallet adjustments, and run the daily reconciliation.',
    to: '/finance/topups',
    action: 'Open top-ups',
  },
  support: {
    job: 'You look after people. Acknowledge open incidents first, then answer the oldest support ticket.',
    to: '/incidents',
    action: 'Open incidents',
  },
};
