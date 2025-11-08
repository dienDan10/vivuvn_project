import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { createDestination } from "../../../services/apiDestination";
import { notify } from "../../../redux/notificationSlice";
import {
	SUCCESS_NOTIFICATION,
	ERROR_NOTIFICATION,
} from "../../../utils/constant";

export function useCreateDestination() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: createDestination,
		onSuccess: () => {
			queryClient.invalidateQueries(["destinations"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Destination created successfully!",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: `Creation failed: ${error.response?.data?.message || error.message}`,
				})
			);
		},
	});

	return { isPending, mutate };
}
