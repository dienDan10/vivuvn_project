import { useSelector } from "react-redux";
import { Navigate } from "react-router-dom";
import LoginForm from "../features/auth/LoginForm";

function Login() {
	const isAuthenticated = useSelector((state) => state.user.isAuthenticated);

	// If user is already authenticated, redirect to manage page
	if (isAuthenticated) {
		return <Navigate to="/manage" replace />;
	}

	return (
		<>
			<LoginForm />
		</>
	);
}

export default Login;
