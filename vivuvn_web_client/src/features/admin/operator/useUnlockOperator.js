import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { unlockOperator as unlockOperatorApi } from "../../../services/apiOperator";
import { ERROR_NOTIFICATION, SUCCESS_NOTIFICATION } from "../../../utils/constant";

export function useUnlockOperator() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: unlockOperatorApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["operators"] });
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Operator unlocked",
					description: "Operator account has been unlocked successfully",
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

	return { isPending, mutate };
}
