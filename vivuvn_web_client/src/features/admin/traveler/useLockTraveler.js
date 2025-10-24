import { useMutation, useQueryClient } from "@tanstack/react-query";
// import { lockTraveler } from "../../../services/apiTraveler";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { delay } from "../../../mocks/travelerMockData";

export function useLockTraveler() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	return useMutation({
		// Real API call:
		// mutationFn: lockTraveler,
		// Mock behavior:
		mutationFn: async (travelerId) => {
			await delay(300);
			console.log("Mock: Locking traveler", travelerId);
			return { success: true };
		},
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["travelers"] });
			dispatch(
				notify({
					type: "success",
					message: "Traveler locked",
					description: "Traveler account has been locked successfully",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: "error",
					message: "Lock failed",
					description: error.response?.data?.message || error.message,
				})
			);
		},
	});
}
