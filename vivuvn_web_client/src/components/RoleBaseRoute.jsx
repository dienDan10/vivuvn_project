import { useSelector } from "react-redux";
import { Navigate } from "react-router-dom";
import AccessDenied from "../pages/AccessDenied";
import { ROLE_ADMIN, ROLE_OPERATOR } from "../utils/constant";

function RoleBaseRoute({ children }) {
	const { isAuthenticated, user } = useSelector((state) => state.user);

	// Redirect to login if not authenticated
	if (!isAuthenticated) {
		return <Navigate to="/login" replace />;
	}

	// Check if user has required roles (Admin or Operator)
	const userRoles = user?.roles || [];
	const hasRequiredRole = userRoles.includes(ROLE_ADMIN) || userRoles.includes(ROLE_OPERATOR);

	// Show access denied if authenticated but lacks required role
	if (!hasRequiredRole) {
		return <AccessDenied />;
	}

	return children;
}

export default RoleBaseRoute;
