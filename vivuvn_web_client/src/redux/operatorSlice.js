import { createSlice } from "@reduxjs/toolkit";

const operatorSlice = createSlice({
	name: "Operator",
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
		selectedOperator: null,
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
		setSelectedOperator: (state, action) => {
			state.selectedOperator = action.payload;
		},
		clearSelectedOperator: (state) => {
			state.selectedOperator = null;
		},
	},
});

export const {
	setFilters,
	resetFilters,
	setPage,
	setPageSize,
	setSorting,
	setSelectedOperator,
	clearSelectedOperator,
} = operatorSlice.actions;

export default operatorSlice.reducer;
