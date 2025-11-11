import { createSlice } from "@reduxjs/toolkit";

const initialState = {
	filters: {
		name: "",
		provinceId: undefined,
		sortBy: "",
		isDescending: false,
		pageNumber: 1,
		pageSize: 10,
	},
};

const destinationSlice = createSlice({
	name: "destination",
	initialState,
	reducers: {
		setFilters: (state, action) => {
			state.filters = {
				...state.filters,
				...action.payload,
			};
		},
		resetFilters: (state) => {
			state.filters = initialState.filters;
		},
		setPage: (state, action) => {
			state.filters.pageNumber = action.payload;
		},
		setPageSize: (state, action) => {
			state.filters.pageSize = action.payload;
		},
		setSorting: (state, action) => {
			state.filters.sortBy = action.payload.sortBy;
			state.filters.isDescending = action.payload.isDescending;
		},
	},
});

export const { setFilters, resetFilters, setPage, setPageSize, setSorting } =
	destinationSlice.actions;

export default destinationSlice.reducer;
