import {
  Navigate,
  Outlet,
  createBrowserRouter,
  RouterProvider,
  useLocation,
  useSearchParams,
  type RouteObject,
} from 'react-router';
import { Skeleton } from '@/components';
import AcceptInvitePage from '@/pages/AcceptInvitePage';
import ForgotPasswordPage from '@/pages/ForgotPasswordPage';
import ResetPasswordPage from '@/pages/ResetPasswordPage';
import SignInPage from '@/pages/SignInPage';
import { useSession } from '@/state/session';
import { safeReturnPath, signInPath } from '@/utils/returnPath';
import { Layout, RequireArea } from './Layout';
import { signedInRoutes, type PageRoute } from './routes';

function Checking() {
  return (
    <div style={{ padding: 48, maxWidth: 480, margin: '0 auto', display: 'grid', gap: 12 }} aria-busy="true">
      <Skeleton />
      <Skeleton width="60%" />
    </div>
  );
}

function SignedIn() {
  const { status, signedOutReason } = useSession();
  const location = useLocation();
  if (status === 'checking') return <Checking />;
  if (status === 'signedOut') {
    // A deliberate sign-out (here or in another tab) starts fresh, so the next person at this
    // computer does not land on the last one's page. Otherwise keep the page they asked for.
    const fresh = signedOutReason === 'signedOut' || signedOutReason === 'elsewhere';
    return (
      <Navigate
        to={fresh ? '/sign-in' : signInPath(`${location.pathname}${location.search}${location.hash}`)}
        replace
      />
    );
  }
  return <Layout />;
}

function SignedOut() {
  const { status } = useSession();
  const [params] = useSearchParams();
  if (status === 'checking') return <Checking />;
  if (status === 'signedIn') return <Navigate to={safeReturnPath(params.get('next'))} replace />;
  return <Outlet />;
}

/** A signed-in route: its page chunk loads on first visit, behind the role guard. */
function lazyPage({ path, area, load }: PageRoute): RouteObject {
  return {
    path,
    lazy: async () => {
      const { default: Page } = await load();
      return {
        element: area ? (
          <RequireArea area={area}>
            <Page />
          </RequireArea>
        ) : (
          <Page />
        ),
      };
    },
  };
}

// Sign-in screens ship with the shell; everything behind sign-in is split per page.
const router = createBrowserRouter([
  {
    HydrateFallback: Checking,
    children: [
      {
        element: <SignedOut />,
        children: [
          { path: '/sign-in', element: <SignInPage /> },
          { path: '/forgot-password', element: <ForgotPasswordPage /> },
        ],
      },
      { path: '/reset-password', element: <ResetPasswordPage /> },
      { path: '/invite', element: <AcceptInvitePage /> },
      // The API's invite email links here (api/src/routes/staff.js sendInvite).
      { path: '/accept-invite', element: <AcceptInvitePage /> },
      { element: <SignedIn />, children: signedInRoutes.map(lazyPage) },
    ],
  },
]);

export function App() {
  return <RouterProvider router={router} />;
}
