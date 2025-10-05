import { useEffect } from "react";
import { useDispatch } from "react-redux";
import { doLoginAction } from "../redux/userSlice";
import tokenManager from "../utils/tokenManager";

export function useAuthPersistence() {
	const dispatch = useDispatch();

	useEffect(() => {
		const initializeAuth = () => {
			const accessToken = tokenManager.getAccessToken();
			const refreshTokenValue = tokenManager.getRefreshToken();

			// If no tokens at all, user is not authenticated
			if (!accessToken && !refreshTokenValue) {
				tokenManager.clearTokens();
				return;
			}

			// If access token exists and is not expired, user is authenticated
			if (accessToken && !tokenManager.isAccessTokenExpired()) {
				dispatch(doLoginAction());
				return;
			}

			// If access token is expired but refresh token exists,
			// let the axios interceptor handle the refresh when API calls are made
			// Don't set as authenticated until we have a valid access token
		};

		initializeAuth();
	}, [dispatch]);
}

export default useAuthPersistence;
