import { useSelector } from "react-redux";
import { Navigate } from "react-router-dom";
import { ROLE_ADMIN, ROLE_OPERATOR } from "../utils/constant";
import AccessDenied from "../pages/AccessDenied";

function OperatorOnlyRoute({ children }) {
	const { isAuthenticated, user } = useSelector((state) => state.user);

	// Redirect to login if not authenticated
	if (!isAuthenticated) {
		return <Navigate to="/login" replace />;
	}

	// Check if user has Operator role
	const userRoles = user?.roles || [];
	const isOperator = userRoles.includes(ROLE_OPERATOR) || userRoles.includes(ROLE_ADMIN);

	// Show access denied if authenticated but not operator
	if (!isOperator) {
		return <AccessDenied />;
	}

	return children;
}

export default OperatorOnlyRoute;
