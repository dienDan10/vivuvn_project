import { useMutation, useQueryClient } from "@tanstack/react-query";
// import { unlockTraveler } from "../../../services/apiTraveler";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { unlockTraveler as unlockTravelerApi } from "../../../services/apiTraveler";

export function useUnlockTraveler() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	return useMutation({
		mutationFn: unlockTravelerApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["travelers"] });
			dispatch(
				notify({
					type: "success",
					message: "Traveler unlocked",
					description: "Traveler account has been unlocked successfully",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: "error",
					message: "Unlock failed",
					description: error.response?.data?.message || error.message,
				})
			);
		},
	});
}
