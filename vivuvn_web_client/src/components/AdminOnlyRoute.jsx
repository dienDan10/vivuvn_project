import { useSelector } from "react-redux";
import { Navigate } from "react-router-dom";
import { ROLE_ADMIN } from "../utils/constant";
import AccessDenied from "../pages/AccessDenied";

function AdminOnlyRoute({ children }) {
	const { isAuthenticated, user } = useSelector((state) => state.user);

	// Redirect to login if not authenticated
	if (!isAuthenticated) {
		return <Navigate to="/login" replace />;
	}

	// Check if user has Admin role
	const userRoles = user?.roles || [];
	const isAdmin = userRoles.includes(ROLE_ADMIN);

	// Show access denied if authenticated but not admin
	if (!isAdmin) {
		return <AccessDenied />;
	}

	return children;
}

export default AdminOnlyRoute;
