import { useMutation, useQueryClient } from "@tanstack/react-query";
import { restoreProvince as restoreProvinceApi } from "../../../services/apiProvince";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import {
	ERROR_NOTIFICATION,
	SUCCESS_NOTIFICATION,
} from "../../../utils/constant";

export function useRestoreProvince() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();
	const { mutate, isPending } = useMutation({
		mutationFn: restoreProvinceApi,
		onSuccess: () => {
			queryClient.invalidateQueries(["provinces"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Province restored successfully!",
				})
			);
		},
		onError: (error) =>
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: "Restore province failed",
					description: error.response?.data?.detail,
				})
			),
	});
	return { mutate, isPending };
}
