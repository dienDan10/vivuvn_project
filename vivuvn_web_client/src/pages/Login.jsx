import { useSelector } from "react-redux";
import { Navigate, useLocation } from "react-router-dom";
import LoginForm from "../features/auth/LoginForm";

function Login() {
	const isAuthenticated = useSelector((state) => state.user.isAuthenticated);
	const location = useLocation();

	// If user is already authenticated, redirect to intended destination or manage page
	if (isAuthenticated) {
		const from = location.state?.from?.pathname || "/manage";
		return <Navigate to={from} replace />;
	}

	return (
		<>
			<LoginForm />
		</>
	);
}

export default Login;
