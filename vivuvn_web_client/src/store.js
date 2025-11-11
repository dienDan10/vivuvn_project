import { configureStore } from "@reduxjs/toolkit";
import userReducer from "./redux/userSlice";
import notificationReducer from "./redux/notificationSlice";
import travelerReducer from "./redux/travelerSlice";
import provinceReducer from "./redux/provinceSlice";
import operatorReducer from "./redux/operatorSlice";
import destinationReducer from "./redux/destinationSlice";

const store = configureStore({
	reducer: {
		user: userReducer,
		notification: notificationReducer,
		traveler: travelerReducer,
		province: provinceReducer,
		operator: operatorReducer,
		destination: destinationReducer,
	},
	middleware: (getDefaultMiddleware) =>
		getDefaultMiddleware({
			serializableCheck: false,
		}),
});

export default store;
