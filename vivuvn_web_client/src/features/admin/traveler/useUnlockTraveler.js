import { useMutation, useQueryClient } from "@tanstack/react-query";
// import { unlockTraveler } from "../../../services/apiTraveler";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { unlockTraveler as unlockTravelerApi } from "../../../services/apiTraveler";
import { ERROR_NOTIFICATION, SUCCESS_NOTIFICATION } from "../../../utils/constant";

export function useUnlockTraveler() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	return useMutation({
		mutationFn: unlockTravelerApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["travelers"] });
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Traveler unlocked",
					description: "Traveler account has been unlocked successfully",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Unlock failed",
					description: error.response?.data?.detail,
				})
			);
		},
	});
}
