import { Table, Button, Space, Tag, Popconfirm, Tooltip, Avatar } from "antd";
import {
	LockOutlined,
	UnlockOutlined,
	UserOutlined,
	GoogleOutlined,
} from "@ant-design/icons";
import { useDispatch, useSelector } from "react-redux";
import { useGetTravelers } from "./useGetTravelers";
import { useLockTraveler } from "./useLockTraveler";
import { useUnlockTraveler } from "./useUnlockTraveler";
import { setPage, setPageSize, setSorting } from "../../../redux/travelerSlice";

function TravelerTable() {
	const dispatch = useDispatch();
	const filters = useSelector((state) => state.traveler.filters);
	const { travelers, totalCount, isPending } = useGetTravelers();
	const lockMutation = useLockTraveler();
	const unlockMutation = useUnlockTraveler();

	const handleLock = (id) => {
		lockMutation.mutate(id);
	};

	const handleUnlock = (id) => {
		unlockMutation.mutate(id);
	};

	const handleTableChange = (pagination, _, sorter) => {
		if (pagination.current !== filters.pageNumber) {
			dispatch(setPage(pagination.current));
		}

		if (pagination.pageSize !== filters.pageSize) {
			dispatch(setPageSize(pagination.pageSize));
		}

		if (sorter.field && sorter.order) {
			const isDescending = sorter.order === "descend";
			dispatch(
				setSorting({
					sortBy: sorter.field,
					isDescending,
				})
			);
		}
	};

	const columns = [
		{
			title: "Avatar",
			dataIndex: "userPhoto",
			key: "userPhoto",
			width: 80,
			render: (userPhoto, record) => (
				<Avatar
					src={userPhoto}
					icon={<UserOutlined />}
					size={48}
					alt={record.username}
				/>
			),
		},
		{
			title: "Username",
			dataIndex: "username",
			key: "username",
			sorter: true,
			sortOrder:
				filters.sortBy === "username"
					? filters.isDescending
						? "descend"
						: "ascend"
					: null,
		},
		{
			title: "Email",
			dataIndex: "email",
			key: "email",
			sorter: true,
			sortOrder:
				filters.sortBy === "email"
					? filters.isDescending
						? "descend"
						: "ascend"
					: null,
			render: (email, record) => (
				<Space>
					{email}
					{record.googleIdToken && (
						<Tooltip title="Google Account">
							<GoogleOutlined style={{ color: "#DB4437" }} />
						</Tooltip>
					)}
				</Space>
			),
		},
		{
			title: "Phone",
			dataIndex: "phoneNumber",
			key: "phoneNumber",
			render: (phoneNumber) => phoneNumber || "N/A",
		},
		{
			title: "Email Verified",
			dataIndex: "isEmailVerified",
			key: "isEmailVerified",
			render: (isEmailVerified) => (
				<Tag color={isEmailVerified ? "green" : "orange"}>
					{isEmailVerified ? "Verified" : "Pending"}
				</Tag>
			),
		},
		{
			title: "Status",
			key: "status",
			render: (_, record) => (
				<Tag color={record.isLocked ? "red" : "green"}>
					{record.isLocked ? "Locked" : "Active"}
				</Tag>
			),
		},
		{
			title: "Actions",
			key: "actions",
			width: 100,
			fixed: "right",
			render: (_, record) => (
				<Space size="small">
					{record.isLocked ? (
						<Tooltip title="Unlock">
							<Popconfirm
								title="Unlock Traveler"
								description="Are you sure you want to unlock this traveler?"
								onConfirm={() => handleUnlock(record.id)}
								okText="Yes"
								cancelText="No"
							>
								<Button
									type="default"
									size="small"
									icon={<UnlockOutlined />}
									loading={
										unlockMutation.isPending &&
										unlockMutation.variables === record.id
									}
								/>
							</Popconfirm>
						</Tooltip>
					) : (
						<Tooltip title="Lock">
							<Popconfirm
								title="Lock Traveler"
								description="Are you sure you want to lock this traveler?"
								onConfirm={() => handleLock(record.id)}
								okText="Yes"
								cancelText="No"
							>
								<Button
									danger
									size="small"
									icon={<LockOutlined />}
									loading={
										lockMutation.isPending &&
										lockMutation.variables === record.id
									}
								/>
							</Popconfirm>
						</Tooltip>
					)}
				</Space>
			),
		},
	];

	return (
		<Table
			rowKey="id"
			columns={columns}
			dataSource={travelers || []}
			loading={isPending}
			scroll={{ x: 1000 }}
			pagination={{
				current: filters.pageNumber,
				pageSize: filters.pageSize,
				total: totalCount,
				showSizeChanger: true,
				showTotal: (total, range) =>
					`${range[0]}-${range[1]} of ${total} travelers`,
			}}
			onChange={handleTableChange}
		/>
	);
}

export default TravelerTable;
