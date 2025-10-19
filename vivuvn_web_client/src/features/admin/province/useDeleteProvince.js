import { useMutation, useQueryClient } from "@tanstack/react-query";
import { deleteProvince as deleteProvinceApi } from "../../../services/apiProvince";
import { useDispatch } from "react-redux";
import { notify } from "../../../redux/notificationSlice";
import {
  ERROR_NOTIFICATION,
  SUCCESS_NOTIFICATION,
} from "../../../utils/constant";

export function useDeleteProvince() {
  const queryClient = useQueryClient();
  const dispatch = useDispatch();
  const { mutate, isPending } = useMutation({
    mutationFn: deleteProvinceApi,
    onSuccess: () => {
      queryClient.invalidateQueries(["provinces"]);
      dispatch(
        notify({
          type: SUCCESS_NOTIFICATION,
          message: "Province deleted successfully!",
        })
      );
    },
    onError: (error) =>
      dispatch(
        notify({
          type: ERROR_NOTIFICATION,
          message: `Deletion failed: ${
            error.response?.data?.message || "Unknown error"
          }`,
        })
      ),
  });
  return { mutate, isPending };
}
