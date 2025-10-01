import { useEffect } from "react";
import { useDispatch } from "react-redux";
import { doLoginAction } from "../redux/userSlice";
import tokenManager from "../utils/tokenManager";

export function useAuthPersistence() {
	const dispatch = useDispatch();

	useEffect(() => {
		// Check if user has valid tokens on app start
		if (tokenManager.hasValidTokens() && !tokenManager.isAccessTokenExpired()) {
			// If tokens exist and are valid, mark user as authenticated
			dispatch(doLoginAction());
		} else {
			// If tokens are invalid or expired, clear them
			tokenManager.clearTokens();
		}
	}, [dispatch]);
}

export default useAuthPersistence;
