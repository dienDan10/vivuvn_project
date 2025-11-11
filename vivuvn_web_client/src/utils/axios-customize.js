import axios from "axios";
import tokenManager from "./tokenManager";
import store from "../store"; // Import Redux store
import { doLoginAction } from "../redux/userSlice";

const baseURL = import.meta.env.VITE_BACKEND_URL;

const customAxios = axios.create({
	baseURL: baseURL,
	withCredentials: true,
});

// Track if we're currently refreshing token to avoid multiple refresh requests
let isRefreshing = false;
let failedQueue = [];

// Process queued requests after token refresh
const processQueue = (error, token = null) => {
	failedQueue.forEach(({ resolve, reject }) => {
		if (error) {
			reject(error);
		} else {
			resolve(token);
		}
	});

	failedQueue = [];
};

// Refresh token function
const refreshToken = async () => {
	try {
		const refreshTokenValue = tokenManager.getRefreshToken();
		if (!refreshTokenValue) {
			throw new Error("No refresh token available");
		}

		const response = await axios.post(
			`${baseURL}/v1/auth/refresh-token`,
			{
				refreshToken: refreshTokenValue,
			},
			{
				withCredentials: true,
			}
		);

		const { accessToken, refreshToken: newRefreshToken } = response.data;

		// Update tokens using token manager
		tokenManager.setTokens(accessToken, newRefreshToken);

		return accessToken;
	} catch (error) {
		// Clear tokens if refresh fails
		tokenManager.clearTokens();
		throw error;
	}
};

// Add a request interceptor
customAxios.interceptors.request.use(
	(config) => {
		// Only set the token if Authorization header is not already present
		// This prevents overwriting the token during retry attempts
		if (!config.headers["Authorization"]) {
			const accessToken = tokenManager.getAccessToken();
			if (accessToken) {
				config.headers["Authorization"] = `Bearer ${accessToken}`;
			}
		}
		return config;
	},
	(error) => {
		return Promise.reject(error);
	}
);

// Add a response interceptor
customAxios.interceptors.response.use(
	(response) => {
		// If the response is successful, return it
		return response;
	},
	async (error) => {
		const originalRequest = error.config;
		// If the response is a 401 Unauthorized or 403 Forbidden error and we haven't already tried to refresh
		if (
			error.response &&
			(error.response.status === 401 || error.response.status === 403) &&
			!originalRequest._retry
		) {
			// Check if the request was for the user profile API or refresh endpoint
			if (isRefreshing) {
				// If we're already refreshing, queue this request
				return new Promise((resolve, reject) => {
					failedQueue.push({ resolve, reject });
				})
					.then((token) => {
						// Update the original request with the new token from the refresh
						originalRequest.headers["Authorization"] = `Bearer ${token}`;
						// Delete the _retry flag to allow fresh retry
						delete originalRequest._retry;
						return customAxios(originalRequest);
					})
					.catch((err) => {
						return Promise.reject(err);
					});
			}

			originalRequest._retry = true;
			isRefreshing = true;

			try {
				const newToken = await refreshToken();
				processQueue(null, newToken);

				// Update Redux state to reflect successful authentication
				store.dispatch(doLoginAction());
				console.log("New token obtained:", newToken);
				
				// Retry the original request with new token
				// Create a new config to avoid axios caching issues
				const retryConfig = {
					...originalRequest,
					headers: {
						...originalRequest.headers,
						Authorization: `Bearer ${newToken}`,
					},
				};
				// Delete the _retry flag to allow fresh retry
				delete retryConfig._retry;
				
				return customAxios(retryConfig);
			} catch (refreshError) {
				processQueue(refreshError, null);

				// Only redirect to login if it's not a profile request
				console.error("Token refresh failed, redirecting to login");
				window.location.href = "/login";

				return Promise.reject(refreshError);
			} finally {
				isRefreshing = false;
			}
		}

		return Promise.reject(error);
	}
);

export default customAxios;
