import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { restoreDestination } from "../../../services/apiDestination";
import { notify } from "../../../redux/notificationSlice";
import {
	SUCCESS_NOTIFICATION,
	ERROR_NOTIFICATION,
} from "../../../utils/constant";

export function useRestoreDestination() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: restoreDestination,
		onSuccess: () => {
			queryClient.invalidateQueries(["destinations"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Destination restored successfully!",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: `Restore failed: ${error.response?.data?.message || error.message}`,
				})
			);
		},
	});

	return { isPending, mutate };
}
