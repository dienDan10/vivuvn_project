import { createSlice } from "@reduxjs/toolkit";

const provinceSlice = createSlice({
	name: "Province",
	initialState: {
		filters: {
			name: "",
			provinceCode: "",
			sortBy: "",
			isDescending: false,
			pageNumber: 1,
			pageSize: 10,
		},
		selectedProvince: null,
	},
	reducers: {
		setFilters: (state, action) => {
			state.filters = { ...state.filters, ...action.payload };
		},
		resetFilters: (state) => {
			state.filters = {
				...state.filters,
				name: "",
				provinceCode: "",
				sortBy: "",
				isDescending: false,
			};
		},
		setPage: (state, action) => {
			state.filters.pageNumber = action.payload;
		},
		setPageSize: (state, action) => {
			state.filters.pageSize = action.payload;
		},
		setSorting: (state, action) => {
			const { sortBy, isDescending } = action.payload;
			state.filters.sortBy = sortBy;
			state.filters.isDescending = isDescending;
		},
		setSelectedProvince: (state, action) => {
			state.selectedProvince = action.payload;
		},
		clearSelectedProvince: (state) => {
			state.selectedProvince = null;
		},
	},
});

export const {
	setFilters,
	resetFilters,
	setPage,
	setPageSize,
	setSorting,
	setSelectedProvince,
	clearSelectedProvince,
} = provinceSlice.actions;

export default provinceSlice.reducer;
