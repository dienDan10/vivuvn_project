import { Menu } from "antd";
import Sider from "antd/es/layout/Sider";
import { MdAccountCircle, MdSpaceDashboard } from "react-icons/md";
import { useSelector } from "react-redux";
import { Link, useLocation } from "react-router-dom";
import { ROLE_ADMIN, ROLE_OPERATOR } from "../../utils/constant";
import { FaLocationDot, FaMapLocationDot } from "react-icons/fa6";
import { BiTrip } from "react-icons/bi";

function ControlPanelSider({ collapsed }) {
	const location = useLocation();
	const { user } = useSelector((state) => state.user);
	const { pathname } = location;
	const isAdmin = user?.roles !== null && user.roles.includes(ROLE_ADMIN);
	const isOperator = user?.roles !== null && user.roles.includes(ROLE_OPERATOR);

	const calcSelectedKey = () => {
		if (pathname.includes("dashboard")) return "1";
		if (pathname.includes("operators")) return "3";
		if (pathname.includes("travelers")) return "4";
		if (pathname.includes("destinations")) return "5";
		if (pathname.includes("provinces")) return "6";
	};

	const selectedKey = calcSelectedKey();

	return (
		<Sider
			trigger={null}
			collapsible
			collapsed={collapsed}
			className="h-screen sticky! top-0 left-0 bottom-0 bg-gray-900"
		>
			<div className="h-16 text-gray-50 font-bold tracking-wider text-2xl flex items-center justify-center mb-2">
				{collapsed ? "V" : "VIVUVN"}
			</div>
			<Menu
				className="bg-gray-900! text-white tracking-wide space-y-2"
				mode="inline"
				selectedKeys={[selectedKey]}
				items={[
					(isAdmin || isOperator) && {
						key: "1",
						icon: <MdSpaceDashboard />,
						label: <Link to="/manage">Dashboard</Link>,
					},
					isAdmin && {
						key: "2",
						icon: <MdAccountCircle />,
						label: <p>Users</p>,
						children: [
							{
								key: "3",
								label: <Link to="/manage/operators">Operators</Link>,
							},
							{
								key: "4",
								label: <Link to="/manage/travelers">Travelers</Link>,
							},
						],
					},
					(isOperator || isAdmin) && {
						key: "5",
						icon: <FaMapLocationDot />,
						label: <Link to="/manage/destinations">Destinations</Link>,
					},
					isAdmin && {
						key: "6",
						icon: <FaLocationDot />,
						label: <Link to="/manage/provinces">Provinces</Link>,
					},
				]}
			/>
		</Sider>
	);
}

export default ControlPanelSider;
