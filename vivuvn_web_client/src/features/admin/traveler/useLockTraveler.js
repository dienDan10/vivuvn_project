import { useMutation, useQueryClient } from "@tanstack/react-query";
// import { lockTraveler } from "../../../services/apiTraveler";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { lockTraveler as lockTravelerApi } from "../../../services/apiTraveler";

export function useLockTraveler() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: lockTravelerApi,
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

	return { isPending, mutate };
}
