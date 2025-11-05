import axios from "../utils/axios-customize";

export const getAllProvinces = async (filters = {}) => {
	const params = new URLSearchParams();

	if (filters.name) params.append("name", filters.name);
	if (filters.provinceCode) params.append("provinceCode", filters.provinceCode);
	if (filters.sortBy) params.append("sortBy", filters.sortBy);
	if (filters.isDescending !== undefined)
		params.append("isDescending", filters.isDescending);
	if (filters.pageNumber) params.append("pageNumber", filters.pageNumber);
	if (filters.pageSize) params.append("pageSize", filters.pageSize);

	const res = await axios.get(`/v1/provinces?${params.toString()}`);
	return res;
};

export const getProvinceById = async (id) => {
	const res = await axios.get(`/v1/provinces/${id}`);
	return res;
};

export const createProvince = async ({
	id,
	name,
	provinceCode,
	imageFile,
}) => {
	const formData = new FormData();
	if (id) formData.append("id", id);
	if (name) formData.append("name", name);
	if (provinceCode) formData.append("provinceCode", provinceCode);
	if (imageFile) formData.append("image", imageFile);

	const res = await axios.post("/v1/provinces", formData, {
		headers: {
			"Content-Type": "multipart/form-data",
		},
	});
	return res;
};

export const updateProvince = async ({
	id,
	name,
	provinceCode,
	imageFile,
}) => {
	const formData = new FormData();
	if (name) formData.append("name", name);
	if (provinceCode) formData.append("provinceCode", provinceCode);
	if (imageFile) formData.append("image", imageFile);

	const res = await axios.put(`/v1/provinces/${id}`, formData, {
		headers: {
			"Content-Type": "multipart/form-data",
		},
	});
	return res;
};

export const deleteProvince = async (id) => {
	const res = await axios.delete(`/v1/provinces/${id}`);
	return res;
};

export const restoreProvince = async (id) => {
	const res = await axios.put(`/v1/provinces/${id}/restore`);
	return res;
};
