import { createSlice } from "@reduxjs/toolkit";
import { ROLE_ADMIN } from "../utils/constant";

const initialState = {
	isAuthenticated: false,
	// Keep user structure for easier state management
	user: {
		id: null,
		username: null,
		email: null,
		userPhoto: null,
		phoneNumber: null,
		googleIdToken: null,
		isLocked: false,
		roles: [],
	},
};

export const userSlice = createSlice({
	name: "user",
	initialState,
	reducers: {
		doLoginAction: (state) => {
			state.isAuthenticated = true;
		},
		doGetProfileAction: (state, action) => {
			const {
				id,
				displayName,
				email,
				roles,
				userPhoto,
				phoneNumber,
				googleIdToken,
				isLocked,
			} = action.payload;
			state.user = {
				id,
				name: displayName,
				email,
				roles,
				userPhoto,
				phoneNumber,
				googleIdToken,
				isLocked,
			};
			state.isAuthenticated = true;
		},
		doLogoutAction: (state) => {
			state.isAuthenticated = false;
			state.user = initialState.user; // Reset user data
		},
	},
});

export const { doLoginAction, doGetProfileAction, doLogoutAction } =
	userSlice.actions;
export default userSlice.reducer;
