import { lazy, Suspense, useEffect } from "react";
import {
	createBrowserRouter,
	RouterProvider,
	Navigate,
} from "react-router-dom";
import { SpinnerLarge } from "./components/Spinner";
import PageNotFound from "./pages/PageNotFound";
import { notification } from "antd";
import { useDispatch, useSelector } from "react-redux";
import { clearNotification } from "./redux/notificationSlice";
import ProtectedRoute from "./components/ProtectedRoute";
import useAuthPersistence from "./hooks/useAuthPersistence";
import FetchUserProfile from "./features/auth/FetchUserProfile";

const Login = lazy(() => import("./pages/Login"));
const ControlPanelLayout = lazy(() =>
	import("./layouts/control-panel/ControlPanelLayout")
);
const ProvinceLayout = lazy(() =>
	import("./features/admin/province/ProvinceLayout")
);

const router = createBrowserRouter([
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
				<Suspense fallback={<SpinnerLarge />}>
					<ControlPanelLayout />
				</Suspense>
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
		],
	},
	{
		path: "*",
		element: <PageNotFound />,
	},
]);

function App() {
	const [api, notificationContextHolder] = notification.useNotification();
	const notificationData = useSelector((state) => state.notification);
	const isAuthenticated = useSelector((state) => state.user.isAuthenticated);
	const dispatch = useDispatch();
	const { type, message, description, id } = notificationData;

	// Initialize authentication state from localStorage
	useAuthPersistence();

	// Handle notifications
	useEffect(() => {
		if (type && message) {
			api[type]({
				message: message,
				description: description,
			});

			// Clear notification after displaying
			dispatch(clearNotification());
		}
	}, [type, message, description, id, api, dispatch]);

	return (
		<>
			{notificationContextHolder}
			{/* Only fetch user profile when authenticated */}
			{isAuthenticated && <FetchUserProfile />}
			{/* Render the router */}
			<RouterProvider router={router} />
		</>
	);
}

export default App;
