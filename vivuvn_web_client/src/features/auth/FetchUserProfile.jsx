import { useDispatch, useSelector } from "react-redux";
import { useProfile } from "./useProfile";
import { doGetProfileAction } from "../../redux/userSlice";
import { useEffect } from "react";

function FetchUserProfile() {
  const { data } = useProfile();
  const dispatch = useDispatch();
  const { isAuthenticated } = useSelector((state) => state.user);
  // set user data in user slice
  useEffect(() => {
    if (data && data.data) {
      dispatch(doGetProfileAction(data.data));
    }
  }, [data, dispatch, isAuthenticated]);

  return null;
}

export default FetchUserProfile;
