import { useMutation, useQueryClient } from "@tanstack/react-query";
import { updateProvince as updateProvinceApi } from "../../../services/apiProvince";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import {
	ERROR_NOTIFICATION,
	SUCCESS_NOTIFICATION,
} from "../../../utils/constant";

export function useUpdateProvince() {
	const queryClient = useQueryClient();
	const dispatch = useDispatch();
	const { isPending, mutate } = useMutation({
		mutationFn: updateProvinceApi,
		onSuccess: () => {
			queryClient.invalidateQueries(["provinces"]);
			dispatch(
				notify({
					type: SUCCESS_NOTIFICATION,
					message: "Province updated successfully!",
				})
			);
		},
		onError: (error) =>
			dispatch(
				notify({
					type: ERROR_NOTIFICATION,
					message: `Update failed: ${error.message || "Unknown error"}`,
				})
			),
	});

	return { isPending, mutate };
}
