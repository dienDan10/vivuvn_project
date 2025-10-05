import axios from "../utils/axios-customize";

export const register = async ({ username, email, password }) => {
	const res = await axios.post("/v1/auth/register", {
		username,
		email,
		password,
	});

	return res;
};

export const login = async ({ email, password }) => {
	const res = await axios.post("/v1/auth/login", {
		email,
		password,
	});

	return res;
};

export const confirmEmail = async ({ userId, token }) => {
	const res = await axios.post("/v1/auth/confirm-email", {
		userId,
		token,
	});

	return res;
};

export const forgotPassword = async ({ email }) => {
	const res = await axios.post("/v1/auth/forgot-password", {
		email,
	});

	return res;
};

export const resetPassword = async ({ userId, resetToken, password }) => {
	const res = await axios.post("/v1/auth/reset-password", {
		userId,
		resetToken,
		password,
	});

	return res;
};

export const changePassword = async ({ oldPassword, newPassword }) => {
	const res = await axios.post("/v1/auth/change-password", {
		oldPassword,
		newPassword,
	});

	return res;
};

export const refreshToken = async (refreshToken) => {
	const res = await axios.post("/v1/auth/refresh-token", {
		refreshToken,
	});
	return res;
};
