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
	deleteFlag,
}) => {
	const res = await axios.post("/v1/provinces", {
		id,
		name,
		provinceCode,
		deleteFlag,
	});
	return res;
};

export const updateProvince = async ({
	id,
	name,
	provinceCode,
	deleteFlag,
}) => {
	const res = await axios.put(`/v1/provinces/${id}`, {
		name,
		provinceCode,
		deleteFlag,
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
