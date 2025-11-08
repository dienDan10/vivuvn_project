import axios from "../utils/axios-customize";
import { ROLE_OPERATOR } from "../utils/constant";

/**
 * Get all operators (users with "Operator" role)
 * Backend should filter by role in the controller
 */
export const getAllOperators = async ({
	username,
	email,
	phoneNumber,
	sortBy,
	isDescending,
	pageNumber,
	pageSize,
}) => {
	const params = new URLSearchParams();

	// Filter by Operator role
	params.append("role", ROLE_OPERATOR);

	if (username) params.append("username", username);
	if (email) params.append("email", email);
	if (phoneNumber) params.append("phoneNumber", phoneNumber);
	if (sortBy) params.append("sortBy", sortBy);
	if (isDescending !== undefined) params.append("isDescending", isDescending);
	if (pageNumber !== undefined) params.append("pageNumber", pageNumber);
	if (pageSize !== undefined) params.append("pageSize", pageSize);

	const response = await axios.get(`/v1/users?${params.toString()}`);
	return response;
};

/**
 * Create a new operator
 */
export const createOperator = async (operatorData) => {
	const response = await axios.post("/v1/users/operator", operatorData);
	return response;
};

/**
 * Lock an operator (set LockoutEnd to future date)
 */
export const lockOperator = async (id) => {
	const response = await axios.put(`/v1/users/${id}/lock`);
	return response;
};

/**
 * Unlock an operator (set LockoutEnd to null)
 */
export const unlockOperator = async (id) => {
	const response = await axios.put(`/v1/users/${id}/unlock`);
	return response;
};
