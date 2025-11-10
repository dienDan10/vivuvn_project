import { useMutation, useQueryClient } from "@tanstack/react-query";
import { createOperator as createOperatorApi } from "../../../services/apiOperator";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import {
	ERROR_NOTIFICATION,
	SUCCESS_NOTIFICATION,
} from "../../../utils/constant";

export function useCreateOperator() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: createOperatorApi,
		onSuccess: () => {
			queryClient.invalidateQueries(["operators"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Operator created successfully!",
				})
			);
		},
		onError: (error) =>
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Create operator failed",
					description: error.response?.data?.detail,
				})
			),
	});
	return { isPending, mutate };
}
