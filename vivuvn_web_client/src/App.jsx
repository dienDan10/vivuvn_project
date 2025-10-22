import { useEffect } from "react";
import { RouterProvider } from "react-router-dom";
import { notification } from "antd";
import { useDispatch, useSelector } from "react-redux";
import { clearNotification } from "./redux/notificationSlice";
import useAuthPersistence from "./hooks/useAuthPersistence";
import FetchUserProfile from "./features/auth/FetchUserProfile";
import { router } from "./router";

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
