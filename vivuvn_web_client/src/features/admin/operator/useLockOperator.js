import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { lockOperator as lockOperatorApi } from "../../../services/apiOperator";
import { ERROR_NOTIFICATION, SUCCESS_NOTIFICATION } from "../../../utils/constant";

export function useLockOperator() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: lockOperatorApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["operators"] });
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Operator locked",
					description: "Operator account has been locked successfully",
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
