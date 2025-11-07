import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import { unlockOperator as unlockOperatorApi } from "../../../services/apiOperator";

export function useUnlockOperator() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();

	const { isPending, mutate } = useMutation({
		mutationFn: unlockOperatorApi,
		onSuccess: () => {
			queryClient.invalidateQueries({ queryKey: ["operators"] });
			dispatch(
				notify({
					type: "success",
					message: "Operator unlocked",
					description: "Operator account has been unlocked successfully",
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

	return { isPending, mutate };
}
