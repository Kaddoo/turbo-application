import { Navigate, Outlet, createBrowserRouter, RouterProvider, useLocation } from 'react-router';
import { useSession } from '../auth/session';
import { EmptyState, Skeleton } from '../components/ui';
import { AccountPage, AnnouncementsPage, AuditLogPage, ConfigurationPage, StaffPage } from '../pages/Admin';
import { IncidentsPage, SupportPage, TicketPage } from '../pages/Care';
import { AdjustmentsPage, ReconciliationPage, TopupsPage } from '../pages/Finance';
import { OverviewPage } from '../pages/Overview';
import { DriverDetailPage, DriversPage, StudentDetailPage, StudentsPage, VehiclesPage } from '../pages/People';
import { LiveMapPage, RideDetailPage, RidesPage } from '../pages/Rides';
import { AcceptInvitePage, ForgotPasswordPage, ResetPasswordPage, SignInPage } from '../pages/SignIn';
import { VerificationQueuePage, VerificationReviewPage } from '../pages/Verification';
import { AttendancePage, SalaryPaymentsPage, ShiftsPage } from '../pages/Workforce';
import { Layout, RequireArea } from './Layout';
import type { Area } from '../auth/roles';

function Checking() {
  return <div style={{ padding: 48, maxWidth: 480, margin: '0 auto', display: 'grid', gap: 12 }} aria-busy="true"><Skeleton /><Skeleton width="60%" /></div>;
}

function SignedIn() {
  const { status } = useSession();
  const location = useLocation();
  if (status === 'checking') return <Checking />;
  if (status === 'signedOut') return <Navigate to="/sign-in" replace state={{ from: location.pathname }} />;
  return <Layout />;
}

function SignedOut() {
  const { status } = useSession();
  if (status === 'checking') return <Checking />;
  if (status === 'signedIn') return <Navigate to="/" replace />;
  return <Outlet />;
}

const guard = (area: Area, el: React.ReactNode) => <RequireArea area={area}>{el}</RequireArea>;

const router = createBrowserRouter([
  { element: <SignedOut />, children: [
    { path: '/sign-in', element: <SignInPage /> },
    { path: '/forgot-password', element: <ForgotPasswordPage /> },
  ] },
  { path: '/reset-password', element: <ResetPasswordPage /> },
  { path: '/invite', element: <AcceptInvitePage /> },
  // The API's invite email links here (src/routes/staff.js sendInvite).
  { path: '/accept-invite', element: <AcceptInvitePage /> },
  { element: <SignedIn />, children: [
    { path: '/', element: <OverviewPage /> },
    { path: '/verification', element: guard('verification', <VerificationQueuePage />) },
    { path: '/verification/:id', element: guard('verification', <VerificationReviewPage />) },
    { path: '/students', element: guard('students', <StudentsPage />) },
    { path: '/students/:id', element: guard('students', <StudentDetailPage />) },
    { path: '/drivers', element: guard('drivers', <DriversPage />) },
    { path: '/drivers/:id', element: guard('drivers', <DriverDetailPage />) },
    { path: '/vehicles', element: guard('vehicles', <VehiclesPage />) },
    { path: '/live', element: guard('liveMap', <LiveMapPage />) },
    { path: '/rides', element: guard('rides', <RidesPage />) },
    { path: '/rides/:id', element: guard('rides', <RideDetailPage />) },
    { path: '/announcements', element: guard('announcements', <AnnouncementsPage />) },
    { path: '/finance/topups', element: guard('finance', <TopupsPage />) },
    { path: '/finance/adjustments', element: guard('finance', <AdjustmentsPage />) },
    { path: '/finance/reconciliation', element: guard('finance', <ReconciliationPage />) },
    { path: '/support', element: guard('support', <SupportPage />) },
    { path: '/support/:id', element: guard('support', <TicketPage />) },
    { path: '/incidents', element: guard('incidents', <IncidentsPage />) },
    { path: '/salary/shifts', element: guard('salary', <ShiftsPage />) },
    { path: '/salary/attendance', element: guard('salary', <AttendancePage />) },
    { path: '/salary/payments', element: guard('salary', <SalaryPaymentsPage />) },
    { path: '/configuration', element: guard('configuration', <ConfigurationPage />) },
    { path: '/staff', element: guard('staff', <StaffPage />) },
    { path: '/audit-log', element: guard('auditLog', <AuditLogPage />) },
    { path: '/account', element: <AccountPage /> },
    { path: '*', element: <EmptyState title="Page not found" body="Use the menu to find what you need." /> },
  ] },
]);

export function App() {
  return <RouterProvider router={router} />;
}
