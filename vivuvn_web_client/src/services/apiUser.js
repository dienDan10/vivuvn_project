import axios from "../utils/axios-customize";

export const getUserProfile = async () => {
	const res = axios.get("/v1/users/me");
	return res;
};
