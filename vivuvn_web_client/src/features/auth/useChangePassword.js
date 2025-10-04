import { useMutation } from "@tanstack/react-query";
import { changePassword } from "../../services/apiAuth";
import { notify } from "../../redux/notificationSlice";
import { useDispatch } from "react-redux";
import { ERROR_NOTIFICATION, SUCCESS_NOTIFICATION } from "../../utils/constant";

export function useChangePassword() {
  const dispatch = useDispatch();
  const { mutate, isPending, isSuccess, isError, error } = useMutation({
    mutationFn: ({ oldPassword, newPassword }) =>
      changePassword({ oldPassword, newPassword }),
    onSuccess: () => {
      dispatch(
        notify({
          type: SUCCESS_NOTIFICATION,
          message: "Password changed successfully",
        })
      );
    },
    onError: (err) => {
      const errorMsg =
        err.response?.data?.message || "Failed to change password";
      dispatch(
        notify({
          type: ERROR_NOTIFICATION,
          message: errorMsg,
        })
      );
    },
  });

  return { mutate, isPending, isSuccess, isError, error };
}
