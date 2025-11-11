import axios from "../utils/axios-customize";

/**
 * Get dashboard overview statistics
 * @param {Object} filters - Filter parameters
 * @param {string} filters.startDate - Start date for filtering (ISO format)
 * @param {string} filters.endDate - End date for filtering (ISO format)
 * @returns {Promise} Response with overview statistics
 */
export const getDashboardOverview = async (filters = {}) => {
	const params = new URLSearchParams();

	if (filters.startDate) params.append("startDate", filters.startDate);
	if (filters.endDate) params.append("endDate", filters.endDate);

	const res = await axios.get(`/v1/analytics/overview?${params.toString()}`);
	return res;
};

/**
 * Get top provinces by visit count in itineraries
 * @param {Object} filters - Filter parameters
 * @param {string} filters.startDate - Start date for filtering (ISO format)
 * @param {string} filters.endDate - End date for filtering (ISO format)
 * @param {number} filters.limit - Number of top provinces to return (default: 5)
 * @returns {Promise} Response with top provinces data
 */
export const getTopProvinces = async (filters = {}) => {
	const params = new URLSearchParams();

	if (filters.startDate) params.append("startDate", filters.startDate);
	if (filters.endDate) params.append("endDate", filters.endDate);
	if (filters.limit) params.append("limit", filters.limit);

	const res = await axios.get(`/v1/analytics/provinces/top?${params.toString()}`);
	return res;
};

/**
 * Get top locations by visit count in itineraries
 * @param {Object} filters - Filter parameters
 * @param {string} filters.startDate - Start date for filtering (ISO format)
 * @param {string} filters.endDate - End date for filtering (ISO format)
 * @param {number} filters.limit - Number of top locations to return (default: 10)
 * @returns {Promise} Response with top locations data
 */
export const getTopLocations = async (filters = {}) => {
	const params = new URLSearchParams();

	if (filters.startDate) params.append("startDate", filters.startDate);
	if (filters.endDate) params.append("endDate", filters.endDate);
	if (filters.limit) params.append("limit", filters.limit);

	const res = await axios.get(`/v1/analytics/locations/top?${params.toString()}`);
	return res;
};

/**
 * Get itinerary creation trends over time
 * @param {Object} filters - Filter parameters
 * @param {string} filters.startDate - Start date for filtering (ISO format)
 * @param {string} filters.endDate - End date for filtering (ISO format)
 * @param {string} filters.groupBy - Group by period: 'day', 'week', 'month' (default: 'day')
 * @returns {Promise} Response with itinerary trends data
 */
export const getItineraryTrends = async (filters = {}) => {
	const params = new URLSearchParams();

	if (filters.startDate) params.append("startDate", filters.startDate);
	if (filters.endDate) params.append("endDate", filters.endDate);
	if (filters.groupBy) params.append("groupBy", filters.groupBy);

	const res = await axios.get(`/v1/analytics/itineraries/trends?${params.toString()}`);
	return res;
};
