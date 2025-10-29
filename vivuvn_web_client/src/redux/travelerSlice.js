import { createSlice } from "@reduxjs/toolkit";

const travelerSlice = createSlice({
	name: "Traveler",
	initialState: {
		filters: {
			username: "",
			email: "",
			phoneNumber: "",
			sortBy: "",
			isDescending: false,
			pageNumber: 1,
			pageSize: 10,
		},
		selectedTraveler: null,
	},
	reducers: {
		setFilters: (state, action) => {
			state.filters = { ...state.filters, ...action.payload };
		},
		resetFilters: (state) => {
			state.filters = {
				...state.filters,
				username: "",
				email: "",
				phoneNumber: "",
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
		setSelectedTraveler: (state, action) => {
			state.selectedTraveler = action.payload;
		},
		clearSelectedTraveler: (state) => {
			state.selectedTraveler = null;
		},
	},
});

export const {
	setFilters,
	resetFilters,
	setPage,
	setPageSize,
	setSorting,
	setSelectedTraveler,
	clearSelectedTraveler,
} = travelerSlice.actions;

export default travelerSlice.reducer;
