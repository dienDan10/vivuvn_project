import { useDispatch, useSelector } from "react-redux";
import { Link, useLocation } from "react-router-dom";
import {
  ROLE_ADMIN,
  ROLE_OPERATOR
} from "../utils/constant";
import { AiOutlineLogout } from "react-icons/ai";
import { Avatar, Dropdown } from "antd";
import { FaUser } from "react-icons/fa6";
import { doLogoutAction } from "../redux/userSlice";
import { useEffect, useState } from "react";
import ChangePasswordModel from "../features/auth/ChangePasswordModel";

function UserMenu() {
  const { user } = useSelector((state) => state.user);
  const location = useLocation();
  const { pathname } = location;
  const dispatch = useDispatch();
  const [isChangePasswordModalOpen, setIsChangePasswordModalOpen] =
    useState(false);

  const onSignOutClick = () => {
    // First remove the token
    localStorage.removeItem("accessToken");
    dispatch(doLogoutAction());
    window.location.href = "/login";
  };

  const isAdmin = user?.role !== null && user.role === ROLE_ADMIN;
  const isOperator = user?.role !== null && user.role === ROLE_OPERATOR;

  const items = [
    {
      label: (
        <div>
          <span className="block text-sm text-gray-900 ">{user?.name}</span>
          <span className="w-36 block text-sm text-gray-500 truncate">
            {user?.email}
          </span>
        </div>
      ),
      key: "0",
    },
    {
      type: "divider",
    },
    // pathname.includes("manage") && {
    //   key: "1",
    //   label: <Link to={"/"}>Home page</Link>,
    // },
    (isAdmin || isOperator) &&
      !pathname.includes("manage") && {
        label: <Link to={"/manage"}>Control Panel</Link>,
        key: "3",
      },
    {
      label: (
        <span onClick={() => setIsChangePasswordModalOpen(true)}>
          Change password
        </span>
      ),
      key: "2",
    },
    {
      label: (
        <span
          onClick={onSignOutClick}
          className="flex gap-2 justify-start items-center w-full "
        >
          <span>
            <AiOutlineLogout className="text-red-500" />
          </span>
          <span>Sign out</span>
        </span>
      ),
      key: "4",
    },
  ];

  // Responsive avatar size based on screen width
  const getAvatarSize = () => {
    if (window.innerWidth < 640) return 26; // small screens
    if (window.innerWidth < 1024) return 28; // medium screens
    return 32; // large screens
  };

  const [avatarSize, setAvatarSize] = useState(getAvatarSize());

  useEffect(() => {
    const handleResize = () => setAvatarSize(getAvatarSize());
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  return (
    <>
      <Dropdown
        menu={{
          items,
        }}
        trigger={["click"]}
      >
        <Avatar
          icon={<FaUser />}
          size={avatarSize}
          style={{
            backgroundColor: "#ffffff",
            color: "#1c375b",
            cursor: "pointer",
          }}
        />
      </Dropdown>
      <ChangePasswordModel
        isModalOpen={isChangePasswordModalOpen}
        setIsModalOpen={setIsChangePasswordModalOpen}
      />
    </>
  );
}

export default UserMenu;
