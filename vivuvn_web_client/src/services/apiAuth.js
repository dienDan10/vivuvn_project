import axios from "../utils/axios-customize";

export const register = async ({ username, email, password }) => {
	const res = await axios.post("/auth/register", {
		username,
		email,
		password,
	});

	return res;
};

export const login = async ({ email, password }) => {
	const res = await axios.post("/auth/login", {
		email,
		password,
	});

	return res;
};

export const confirmEmail = async ({ userId, token }) => {
	const res = await axios.post("/auth/confirm-email", {
		userId,
		token,
	});

	return res;
};

export const forgotPassword = async ({ email }) => {
	const res = await axios.post("/auth/forgot-password", {
		email,
	});

	return res;
};

export const resetPassword = async ({ userId, resetToken, password }) => {
	const res = await axios.post("/auth/reset-password", {
		userId,
		resetToken,
		password,
	});

	return res;
};

export const changePassword = async ({ oldPassword, newPassword }) => {
	const res = await axios.post("/auth/change-password", {
		oldPassword,
		newPassword,
	});

	return res;
};

export const refreshToken = async (refreshToken) => {
	const res = await axios.post("/auth/refresh", {
		refreshToken,
	});
	return res;
};

export const getUserProfile = async () => {
	const res = await axios.get("/user/profile");
	return res;
};
