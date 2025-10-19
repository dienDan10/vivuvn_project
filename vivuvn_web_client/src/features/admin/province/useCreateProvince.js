import { useMutation, useQueryClient } from "@tanstack/react-query";
import { createProvince as createProvinceApi } from "../../../services/apiProvince";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import {
  ERROR_NOTIFICATION,
  SUCCESS_NOTIFICATION,
} from "../../../utils/constant";

export function useCreateProvince() {
  const queryClient = useQueryClient();
  const dispatch = useDispatch();

  const { isPending, mutate } = useMutation({
    mutationFn: createProvinceApi,
    onSuccess: () => {
      queryClient.invalidateQueries(["provinces"]);
      dispatch(
        notify({
          type: SUCCESS_NOTIFICATION,
          message: "Province created successfully!",
        })
      );
    },
    onError: (error) =>
      dispatch(
        notify({
          type: ERROR_NOTIFICATION,
          message: `Creation failed: ${error.message || "Unknown error"}`,
        })
      ),
  });
  return { isPending, mutate };
}
