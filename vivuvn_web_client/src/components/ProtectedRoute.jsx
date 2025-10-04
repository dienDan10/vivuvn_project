import { useSelector } from "react-redux";
import { Navigate, useLocation } from "react-router-dom";

function ProtectedRoute({ children }) {
	const isAuthenticated = useSelector((state) => state.user.isAuthenticated);
	const location = useLocation();

	if (!isAuthenticated) {
		// Redirect to login page with return url
		return <Navigate to="/login" state={{ from: location }} replace />;
	}

	return children;
}

export default ProtectedRoute;
