import { createSlice } from "@reduxjs/toolkit";

let idCounter = 0;

const notificationSlice = createSlice({
  name: "notification",
  initialState: {
    type: null,
    message: null,
    description: null,
    id: idCounter,
  },
  reducers: {
    notify: (state, action) => {
      const { type, message, description } = action.payload;
      state.type = type;
      state.message = message;
      state.description = description;
      state.id = idCounter++;
    },
    clearNotification: (state) => {
      state.type = null;
      state.message = null;
      state.description = null;
    },
  },
});

export const { notify, clearNotification } = notificationSlice.actions;
export default notificationSlice.reducer;
