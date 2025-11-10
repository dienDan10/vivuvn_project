import { useMutation, useQueryClient } from "@tanstack/react-query";
// import { lockTraveler } from "../../../services/apiTraveler";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { lockTraveler as lockTravelerApi } from "../../../services/apiTraveler";
import { ERROR_NOTIFICATION, SUCCESS_NOTIFICATION } from "../../../utils/constant";

export function useLockTraveler() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: lockTravelerApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["travelers"] });
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Traveler locked",
					description: "Traveler account has been locked successfully",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Lock failed",
					description: error.response?.data?.detail,
				})
			);
		},
	});

	return { isPending, mutate };
}
