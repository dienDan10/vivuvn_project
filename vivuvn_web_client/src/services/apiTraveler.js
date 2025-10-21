import axios from "../utils/axios-customize";

/**
 * Get all travelers (users with "Traveler" role)
 * Backend should filter by role in the controller
 */
export const getAllTravelers = async ({
	username,
	email,
	phoneNumber,
	sortBy,
	isDescending,
	pageNumber,
	pageSize,
}) => {
	const params = new URLSearchParams();

	// Filter by Traveler role
	params.append("role", "Traveler");

	if (username) params.append("username", username);
	if (email) params.append("email", email);
	if (phoneNumber) params.append("phoneNumber", phoneNumber);
	if (sortBy) params.append("sortBy", sortBy);
	if (isDescending !== undefined) params.append("isDescending", isDescending);
	if (pageNumber !== undefined) params.append("pageNumber", pageNumber);
	if (pageSize !== undefined) params.append("pageSize", pageSize);

	const response = await axios.get(`/v1/users?${params.toString()}`);
	return response.data;
};

/**
 * Lock a traveler (set LockoutEnd to future date)
 */
export const lockTraveler = async (id) => {
	const response = await axios.put(`/v1/users/${id}/lock`);
	return response.data;
};

/**
 * Unlock a traveler (set LockoutEnd to null)
 */
export const unlockTraveler = async (id) => {
	const response = await axios.put(`/v1/users/${id}/unlock`);
	return response.data;
};
