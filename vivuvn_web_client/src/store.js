import { configureStore } from "@reduxjs/toolkit";
import userReducer from "./redux/userSlice";
import notificationReducer from "./redux/notificationSlice";

const store = configureStore({
	reducer: {
		user: userReducer,
		notification: notificationReducer,
	},
	middleware: (getDefaultMiddleware) =>
		getDefaultMiddleware({
			serializableCheck: false,
		}),
});

export default store;
