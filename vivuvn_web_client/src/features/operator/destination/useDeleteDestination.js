import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { deleteDestination } from "../../../services/apiDestination";
import { notify } from "../../../redux/notificationSlice";
import {
	SUCCESS_NOTIFICATION,
	ERROR_NOTIFICATION,
} from "../../../utils/constant";

export function useDeleteDestination() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: deleteDestination,
		onSuccess: () => {
			queryClient.invalidateQueries(["destinations"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Destination deleted successfully!",
				})
			);
		},
		onError: (error) => {
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Delete destination failed",
					description: error.response?.data?.detail,
				})
			);
		},
	});

	return { isPending, mutate };
}
