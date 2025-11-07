import customAxios from "../utils/axios-customize";

/**
 * Get all destinations with filters
 * @param {Object} filters - Filter parameters
 * @returns {Promise} - Axios response promise
 */
export async function getAllDestinations(filters = {}) {
	const params = {
		name: filters.name || undefined,
		provinceId: filters.provinceId || undefined,
		sortBy: filters.sortBy || undefined,
		isDescending: filters.isDescending || false,
		pageNumber: filters.pageNumber || 1,
		pageSize: filters.pageSize || 10,
	};

	// Remove undefined parameters
	Object.keys(params).forEach(
		(key) => params[key] === undefined && delete params[key]
	);

	return customAxios.get("/v1/locations", { params });
}

/**
 * Get destination by ID
 * @param {number} id - Destination ID
 * @returns {Promise} - Axios response promise
 */
export async function getDestinationById(id) {
	return customAxios.get(`/v1/locations/${id}`);
}

/**
 * Search destinations by name
 * @param {string} name - Search query
 * @param {number} limit - Number of results
 * @returns {Promise} - Axios response promise
 */
export async function searchDestinations(name, limit = 10) {
	return customAxios.get("/v1/locations/search", {
		params: { name, limit },
	});
}

/**
 * Create a new destination
 * @param {Object} data - Destination data with images
 * @returns {Promise} - Axios response promise
 */
export async function createDestination(data) {
	const formData = new FormData();

	// Append basic fields
	if (data.name) formData.append("name", data.name);
	if (data.provinceId) formData.append("provinceId", data.provinceId);
	if (data.description) formData.append("description", data.description);
	if (data.address) formData.append("address", data.address);
	if (data.websiteUri) formData.append("websiteUri", data.websiteUri);
	if (data.latitude) formData.append("latitude", data.latitude);
	if (data.longitude) formData.append("longitude", data.longitude);
	if (data.googlePlaceId) formData.append("googlePlaceId", data.googlePlaceId);
	if (data.placeUri) formData.append("placeUri", data.placeUri);
	if (data.directionsUri) formData.append("directionsUri", data.directionsUri);
	if (data.reviewUri) formData.append("reviewUri", data.reviewUri);

	// Append multiple images
	if (data.images && data.images.length > 0) {
		data.images.forEach((image) => {
			formData.append("images", image.originFileObj || image);
		});
	}

	return customAxios.post("/v1/locations", formData, {
		headers: {
			"Content-Type": "multipart/form-data",
		},
	});
}

/**
 * Update an existing destination
 * @param {Object} params - Object containing id and destination data
 * @returns {Promise} - Axios response promise
 */
export async function updateDestination({ id, ...data }) {
	const formData = new FormData();

	// Append basic fields
	if (data.name) formData.append("name", data.name);
	if (data.provinceId) formData.append("provinceId", data.provinceId);
	if (data.description) formData.append("description", data.description);
	if (data.address) formData.append("address", data.address);
	if (data.websiteUri) formData.append("websiteUri", data.websiteUri);
	if (data.latitude) formData.append("latitude", data.latitude);
	if (data.longitude) formData.append("longitude", data.longitude);
	if (data.googlePlaceId) formData.append("googlePlaceId", data.googlePlaceId);
	if (data.placeUri) formData.append("placeUri", data.placeUri);
	if (data.directionsUri) formData.append("directionsUri", data.directionsUri);
	if (data.reviewUri) formData.append("reviewUri", data.reviewUri);

	// Append multiple images if provided
	if (data.images && data.images.length > 0) {
		data.images.forEach((image) => {
			formData.append("images", image.originFileObj || image);
		});
	}

	return customAxios.put(`/v1/locations/${id}`, formData, {
		headers: {
			"Content-Type": "multipart/form-data",
		},
	});
}

/**
 * Delete a destination (soft delete)
 * @param {number} id - Destination ID
 * @returns {Promise} - Axios response promise
 */
export async function deleteDestination(id) {
	return customAxios.delete(`/v1/locations/${id}`);
}

/**
 * Restore a deleted destination
 * @param {number} id - Destination ID
 * @returns {Promise} - Axios response promise
 */
export async function restoreDestination(id) {
	return customAxios.put(`/v1/locations/${id}/restore`);
}
