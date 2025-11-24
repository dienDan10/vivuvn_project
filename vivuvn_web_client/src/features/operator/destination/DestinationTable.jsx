import { Table, Image, Avatar, Tag, Button, Space, Tooltip, Popconfirm } from "antd";
import {
	PictureOutlined,
	EnvironmentOutlined,
	StarOutlined,
	GlobalOutlined,
	EyeOutlined,
	EditOutlined,
	DeleteOutlined,
	ReloadOutlined,
} from "@ant-design/icons";
import PropTypes from "prop-types";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useGetDestinations } from "./useGetDestinations";
import { useDeleteDestination } from "./useDeleteDestination";
import { useRestoreDestination } from "./useRestoreDestination";
import { useDispatch, useSelector } from "react-redux";
import { setPage, setPageSize, setSorting } from "../../../redux/destinationSlice";

function DestinationTable({ onEditDestination }) {
	const navigate = useNavigate();
	const dispatch = useDispatch();
	const { destinations, totalCount, isPending } = useGetDestinations();
	const filters = useSelector((state) => state.destination.filters);
	const [processingId, setProcessingId] = useState(null);

	const { mutate: deleteDestination } = useDeleteDestination();
	const { mutate: restoreDestination } = useRestoreDestination();

	const handleTableChange = (pagination, _, sorter) => {
		dispatch(setPage(pagination.current));
		dispatch(setPageSize(pagination.pageSize));

		if (sorter.field) {
			dispatch(
				setSorting({
					sortBy: sorter.field,
					isDescending: sorter.order === "descend",
				})
			);
		}
	};

	const handleDelete = (id) => {
		setProcessingId(id);
		deleteDestination(id, {
			onSettled: () => setProcessingId(null),
		});
	};

	const handleRestore = (id) => {
		setProcessingId(id);
		restoreDestination(id, {
			onSettled: () => setProcessingId(null),
		});
	};

	const columns = [
		{
			title: "Image",
			dataIndex: "photos",
			key: "photos",
			width: 60,
			render: (photos) => {
				if (photos && photos.length > 0) {
					return (
						<Image
							src={photos[0]}
							alt="Destination"
							width={50}
							height={50}
							style={{
								objectFit: "cover",
								borderRadius: "4px",
							}}
							preview={{
								mask: "View",
								src: photos[0],
							}}
						/>
					);
				}
				return (
					<Avatar
						shape="square"
						size={50}
						icon={<PictureOutlined />}
						style={{ backgroundColor: "#f0f0f0", color: "#bfbfbf" }}
					/>
				);
			},
		},
		{
			title: "ID",
			dataIndex: "id",
			key: "id",
			width: 40,
			sorter: true,
		},
		{
			title: "Name",
			dataIndex: "name",
			key: "name",
			width: 250,
			sorter: true,
			render: (text, record) => (
				<div>
					<div
						style={{
							fontWeight: 500,
							cursor: "pointer",
							color: "#1890ff",
						}}
						onClick={() => navigate(`/manage/destinations/${record.id}`)}
					>
						{text}
					</div>
					{record.address && (
						<div
							style={{
								fontSize: "12px",
								color: "#888",
								marginTop: "4px",
							}}
						>
							<EnvironmentOutlined /> {record.address}
						</div>
					)}
				</div>
			),
		},
		{
			title: "Province",
			dataIndex: "provinceName",
			key: "provinceName",
			width: 100,
			sorter: true,
			render: (text) => <Tag color="blue">{text}</Tag>,
		},
		{
			title: "Rating",
			dataIndex: "rating",
			key: "rating",
			width: 120,
			sorter: true,
			render: (rating, record) =>
				rating ? (
					<Space size={4}>
						<StarOutlined style={{ color: "#faad14" }} />
						<span style={{ fontWeight: 500 }}>{rating.toFixed(1)}</span>
						{record.ratingCount && (
							<span style={{ color: "#888", fontSize: "12px" }}>
								({record.ratingCount})
							</span>
						)}
					</Space>
				) : (
					<span style={{ color: "#ccc" }}>N/A</span>
				),
		},
		{
			title: "Actions",
			key: "actions",
			fixed: "right",
			width: 160,
			render: (_, record) => (
				<Space direction="vertical" size="small">
					<Space size="small" wrap>
						{!record.deleteFlag && (
							<>
								<Tooltip title="View Details">
									<Button
										type="link"
										icon={<EyeOutlined />}
										onClick={() => navigate(`/manage/destinations/${record.id}`)}
									>
										View
									</Button>
								</Tooltip>

								<Tooltip title="Edit">
									<Button
										type="link"
										icon={<EditOutlined />}
										onClick={() => onEditDestination(record)}
									>
										Edit
									</Button>
								</Tooltip>
							</>
						)}

						{!record.deleteFlag ? (
							<Popconfirm
								title="Delete Destination"
								description="Are you sure you want to delete this destination?"
								onConfirm={() => handleDelete(record.id)}
								okText="Yes"
								cancelText="No"
								okButtonProps={{
									danger: true,
									loading: processingId === record.id,
								}}
							>
								<Button
									type="link"
									danger
									icon={<DeleteOutlined />}
									loading={processingId === record.id}
								>
									Delete
								</Button>
							</Popconfirm>
						) : (
							<Tooltip title="Restore">
								<Button
									type="link"
									icon={<ReloadOutlined />}
									onClick={() => handleRestore(record.id)}
									loading={processingId === record.id}
								>
									Restore
								</Button>
							</Tooltip>
						)}
					</Space>

					<Space size="small" wrap>
						{record.websiteUri && (
							<Tooltip title="Visit Website">
								<Button
									type="link"
									icon={<GlobalOutlined />}
									onClick={() => window.open(record.websiteUri, "_blank")}
								/>
							</Tooltip>
						)}
						{record.directionsUri && (
							<Tooltip title="Get Directions">
								<Button
									type="link"
									icon={<EnvironmentOutlined />}
									onClick={() => window.open(record.directionsUri, "_blank")}
								/>
							</Tooltip>
						)}
						{record.reviewUri && (
							<Tooltip title="View Reviews">
								<Button
									type="link"
									icon={<EyeOutlined />}
									onClick={() => window.open(record.reviewUri, "_blank")}
								/>
							</Tooltip>
						)}
					</Space>
				</Space>
			),
		},
	];

	return (
		<Table
			columns={columns}
			dataSource={destinations}
			rowKey="id"
			loading={isPending}
			onChange={handleTableChange}
			scroll={{ x: 1400 }}
			pagination={{
				current: filters.pageNumber,
				pageSize: filters.pageSize,
				total: totalCount,
				showSizeChanger: true,
				showTotal: (total, range) =>
					`${range[0]}-${range[1]} of ${total} destinations`,
				pageSizeOptions: ["10", "20", "50", "100"],
			}}
		/>
	);
}

DestinationTable.propTypes = {
	onEditDestination: PropTypes.func.isRequired,
};

export default DestinationTable;
