import { createSlice } from "@reduxjs/toolkit";

const initialState = {
	isAuthenticated: false,
	// Keep user structure for easier state management
	// user: {
	//   id: null,
	//   name: null,
	//   email: null,
	//   role: null
	// },
};

export const userSlice = createSlice({
	name: "user",
	initialState,
	reducers: {
		doLoginAction: (state) => {
			state.isAuthenticated = true;
		},
		// Uncomment and use if profile data is needed in the state
		// doGetProfileAction: (state, action) => {
		//   const { id, displayName, email, role } = action.payload;
		//   state.user = { id, name: displayName, email, role };
		//   state.isAuthenticated = true;
		// },
		doLogoutAction: (state) => {
			state.isAuthenticated = false;
			state.user = initialState.user; // Reset user data
		},
	},
});

export const { doLoginAction, doGetProfileAction, doLogoutAction } =
	userSlice.actions;
export default userSlice.reducer;
