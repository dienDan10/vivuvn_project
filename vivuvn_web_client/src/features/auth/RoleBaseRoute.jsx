import { useSelector } from "react-redux";
import { Navigate } from "react-router-dom";
import { ROLE_ADMIN, ROLE_OPERATOR } from "../../utils/constant";

function RoleBaseRoute({ children }) {
	const { isAuthenticated, user } = useSelector((state) => state.user);

	// Check if user is authenticated
	if (!isAuthenticated) {
		return <Navigate to="/access-denied" replace />;
	}

	// Check if user has required roles (Admin or Operator)
	const userRoles = user?.roles || [];
	const hasRequiredRole = userRoles.includes(ROLE_ADMIN) || userRoles.includes(ROLE_OPERATOR);

	if (!hasRequiredRole) {
		return <Navigate to="/access-denied" replace />;
	}

	return children;
}

export default RoleBaseRoute;
