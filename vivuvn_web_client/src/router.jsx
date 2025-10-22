import { lazy, Suspense } from "react";
import { createBrowserRouter, Navigate } from "react-router-dom";
import { SpinnerLarge } from "./components/Spinner";
import PageNotFound from "./pages/PageNotFound";
import ProtectedRoute from "./components/ProtectedRoute";
import RoleBaseRoute from "./features/auth/RoleBaseRoute";
import AccessDenied from "./pages/AccessDenied";

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
				path: "provinces",
				element: (
					<Suspense fallback={<SpinnerLarge />}>
						<ProvinceLayout />
					</Suspense>
				),
			},
			{
				path: "travelers",
				element: (
					<Suspense fallback={<SpinnerLarge />}>
						<TravelerLayout />
					</Suspense>
				),
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
