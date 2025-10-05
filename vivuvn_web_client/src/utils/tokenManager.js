// Token management utilities

export const tokenManager = {
	// Get access token from localStorage
	getAccessToken: () => {
		return localStorage.getItem("accessToken");
	},

	// Get refresh token from localStorage
	getRefreshToken: () => {
		return localStorage.getItem("refreshToken");
	},

	// Set tokens in localStorage
	setTokens: (accessToken, refreshToken) => {
		if (accessToken) {
			localStorage.setItem("accessToken", accessToken);
		}
		if (refreshToken) {
			localStorage.setItem("refreshToken", refreshToken);
		}
	},

	// Clear all tokens from localStorage
	clearTokens: () => {
		localStorage.removeItem("accessToken");
		localStorage.removeItem("refreshToken");
	},

	// Check if user has valid tokens
	hasValidTokens: () => {
		const accessToken = tokenManager.getAccessToken();
		const refreshToken = tokenManager.getRefreshToken();
		return !!(accessToken && refreshToken);
	},

	// Check if access token is expired (basic check - you might want to decode JWT for better validation)
	isAccessTokenExpired: () => {
		const token = tokenManager.getAccessToken();
		if (!token) return true;

		try {
			// Basic JWT decode (you might want to use a proper JWT library)
			const payload = JSON.parse(atob(token.split(".")[1]));
			const currentTime = Math.floor(Date.now() / 1000);
			return payload.exp < currentTime;
			// eslint-disable-next-line no-unused-vars
		} catch (error) {
			// If we can't decode the token, consider it expired
			return true;
		}
	},
};

export default tokenManager;
