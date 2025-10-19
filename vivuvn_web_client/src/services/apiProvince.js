import axios from "../utils/axios-customize";

export const getAllProvinces = async () => {
	const res = await axios.get("/v1/provinces");
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
	nameNormalized,
	imageFile,
}) => {
	const formData = new FormData();
	if (id) formData.append("id", id);
	if (name) formData.append("name", name);
	if (provinceCode) formData.append("provinceCode", provinceCode);
	if (nameNormalized) formData.append("nameNormalized", nameNormalized);
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
	nameNormalized,
	imageFile,
}) => {
	const formData = new FormData();
	if (name) formData.append("name", name);
	if (provinceCode) formData.append("provinceCode", provinceCode);
	if (nameNormalized) formData.append("nameNormalized", nameNormalized);
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
