import { lazy, Suspense } from "react";
import { createBrowserRouter, Navigate } from "react-router-dom";
import { SpinnerLarge } from "./components/Spinner";
import PageNotFound from "./pages/PageNotFound";
import ProtectedRoute from "./components/ProtectedRoute";
import AccessDenied from "./pages/AccessDenied";
import RoleBaseRoute from "./components/RoleBaseRoute";
import AdminOnlyRoute from "./components/AdminOnlyRoute";
import OperatorLayout from "./features/admin/operator/OperatorLayout";

const Login = lazy(() => import("./pages/Login"));
const ControlPanelLayout = lazy(() =>
  import("./layouts/control-panel/ControlPanelLayout")
);
const ProvinceLayout = lazy(() =>
  import("./features/admin/province/ProvinceLayout")
);
const TravelerLayout = lazy(() =>
  import("./features/admin/traveler/TravelerLayout")
);
const DestinationLayout = lazy(() =>
  import("./features/operator/destination/DestinationLayout")
);
const DestinationDetail = lazy(() =>
  import("./features/operator/destination/DestinationDetail")
);
const DashboardLayout = lazy(() =>
  import("./features/admin/dashboard/DashboardLayout")
);

export const router = createBrowserRouter([
  {
    path: "/",
    element: <Navigate to="/manage" replace />,
  },
  {
    path: "/login",
    element: (
      <Suspense fallback={<SpinnerLarge />}>
        <Login />
      </Suspense>
    ),
  },
  {
    path: "/manage",
    element: (
      <ProtectedRoute>
        <RoleBaseRoute>
          <Suspense fallback={<SpinnerLarge />}>
            <ControlPanelLayout />
          </Suspense>
        </RoleBaseRoute>
      </ProtectedRoute>
    ),
    errorElement: <PageNotFound />,
    children: [
      {
        index: true,
        element: <Navigate to="/manage/dashboard" replace />,
      },
      {
        path: "dashboard",
        element: (
          <Suspense fallback={<SpinnerLarge />}>
            <DashboardLayout />
          </Suspense>
        ),
      },
      {
        path: "provinces",
        element: (
          <AdminOnlyRoute>
            <Suspense fallback={<SpinnerLarge />}>
              <ProvinceLayout />
            </Suspense>
          </AdminOnlyRoute>
        ),
      },
      {
        path: "travelers",
        element: (
          <AdminOnlyRoute>
            <Suspense fallback={<SpinnerLarge />}>
              <TravelerLayout />
            </Suspense>
          </AdminOnlyRoute>
        ),
      },
      {
        path: "operators",
        element: (
          <AdminOnlyRoute>
            <Suspense fallback={<SpinnerLarge />}>
              <OperatorLayout />
            </Suspense>
          </AdminOnlyRoute>
        ),
      },
      {
        path: "destinations",
        children: [
          {
            index: true,
            element: (
              <Suspense fallback={<SpinnerLarge />}>
                <DestinationLayout />
              </Suspense>
            ),
          },
          {
            path: ":id",
            element: (
              <Suspense fallback={<SpinnerLarge />}>
                <DestinationDetail />
              </Suspense>
            ),
          },
        ],
      },
    ],
  },
  {
    path: "/access-denied",
    element: <AccessDenied />,
  },
  {
    path: "*",
    element: <PageNotFound />,
  },
]);
