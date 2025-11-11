import { useMutation } from "@tanstack/react-query";
import { login as loginApi } from "../../services/apiAuth";
import { useDispatch } from "react-redux";
import { useNavigate, useLocation } from "react-router-dom";
import { notify } from "../../redux/notificationSlice";
import {
	ERROR_NOTIFICATION,
	ROLE_ADMIN,
	ROLE_OPERATOR,
	SUCCESS_NOTIFICATION,
} from "../../utils/constant";
import tokenManager from "../../utils/tokenManager";
import { doGetProfileAction } from "../../redux/userSlice";

export function useLogin() {
	const dispatch = useDispatch();
	const navigate = useNavigate();
	const location = useLocation();

	const { isPending, mutate: login } = useMutation({
		mutationFn: async ({ email, password }) => {
			const response = await loginApi({ email, password });
			return response.data;
		},
		onSuccess: (data) => {
			const roles = data.user.roles || [];

			// Check roles BEFORE setting any state
			if (!roles.includes(ROLE_ADMIN) && !roles.includes(ROLE_OPERATOR)) {
				dispatch(
					notify({
						type: ERROR_NOTIFICATION,
						message: "Access Denied",
						description:
							"You do not have sufficient permissions to access this application.",
					})
				);
				// Don't set any auth state or tokens - stay on login page
				return;
			}

			// Only set state if user has valid roles
			dispatch(doGetProfileAction(data.user));
			tokenManager.setTokens(data.accessToken, data.refreshToken);

			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Login Successful",
					description: "You have successfully logged in.",
				})
			);

			// Navigate to intended destination
			const from = location.state?.from?.pathname || "/manage";
			navigate(from, { replace: true });
		},
		onError: (error) => {
			console.error("Login failed:", error);

			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Login Failed",
					description:
						error.response?.data?.detail || "An error occurred during login.",
				})
			);
		},
	});

	return {
		isPending,
		login,
	};
}
