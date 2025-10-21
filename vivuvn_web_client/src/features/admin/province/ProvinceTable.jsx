import { Button, Popconfirm, Space, Table, Image, Avatar } from "antd";
import {
	EditOutlined,
	DeleteOutlined,
	ReloadOutlined,
	PictureOutlined,
} from "@ant-design/icons";
import PropTypes from "prop-types";
import { useState } from "react";
import { useGetProvinces } from "./useGetProvinces";
import { useDeleteProvince } from "./useDeleteProvince";
import { useRestoreProvince } from "./useRestoreProvince";
import { useDispatch, useSelector } from "react-redux";
import { setPage, setPageSize, setSorting } from "../../../redux/provinceSlice";

function ProvinceTable({ onEditProvince }) {
	const dispatch = useDispatch();
	const { provinces, totalCount, isPending } = useGetProvinces();
	const filters = useSelector((state) => state.province.filters);
	const deleteMutation = useDeleteProvince();
	const restoreMutation = useRestoreProvince();

	const handleEdit = (record) => {
		if (onEditProvince) {
			onEditProvince(record);
		}
	};

	const [processingId, setProcessingId] = useState(null);

	const handleDelete = (id) => {
		setProcessingId(id);
		return new Promise((resolve, reject) => {
			deleteMutation.mutate(id, {
				onSuccess: () => {
					resolve();
					setProcessingId(null);
				},
				onError: (error) => {
					reject(error);
					setProcessingId(null);
				},
			});
		});
	};

	const handleRestore = (id) => {
		setProcessingId(id);
		return new Promise((resolve, reject) => {
			restoreMutation.mutate(id, {
				onSuccess: () => {
					resolve();
					setProcessingId(null);
				},
				onError: (error) => {
					reject(error);
					setProcessingId(null);
				},
			});
		});
	};

	const columns = [
		{
			title: "Image",
			dataIndex: "imageUrl",
			key: "imageUrl",
			width: 80,
			render: (imageUrl) => {
				if (imageUrl) {
					return (
						<Image
							src={imageUrl}
							alt="Province"
							width={50}
							height={50}
							style={{
								objectFit: "cover",
								borderRadius: "4px",
							}}
							preview={{
								mask: "View",
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
			sorter: true,
			sortOrder:
				filters.sortBy === "id"
					? filters.isDescending
						? "descend"
						: "ascend"
					: null,
		},
		{
			title: "Name",
			dataIndex: "name",
			key: "name",
			sorter: true,
			sortOrder:
				filters.sortBy === "name"
					? filters.isDescending
						? "descend"
						: "ascend"
					: null,
		},
		{
			title: "Code",
			dataIndex: "provinceCode",
			key: "provinceCode",
			sorter: true,
			sortOrder:
				filters.sortBy === "provinceCode"
					? filters.isDescending
						? "descend"
						: "ascend"
					: null,
		},
		{
			title: "Actions",
			key: "actions",
			render: (_, record) => (
				<Space>
					<Button
						icon={<EditOutlined />}
						type="link"
						onClick={() => handleEdit(record)}
					>
						Edit
					</Button>
					{!record.deleteFlag ? (
						<Popconfirm
							title="Delete Province"
							description="Are you sure you want to delete this province?"
							onConfirm={() => handleDelete(record.id)}
							okText="Yes"
							cancelText="No"
							okButtonProps={{
								danger: true,
								loading: processingId === record.id,
							}}
						>
							<Button
								icon={<DeleteOutlined />}
								type="link"
								danger
								loading={processingId === record.id}
								disabled={processingId !== null}
							>
								Delete
							</Button>
						</Popconfirm>
					) : (
						<Button
							icon={<ReloadOutlined />}
							type="link"
							onClick={() => handleRestore(record.id)}
							loading={processingId === record.id}
							disabled={processingId !== null}
						>
							Restore
						</Button>
					)}
				</Space>
			),
		},
	];

	const dataSource = provinces?.map((province) => ({
		key: province.id,
		...province,
	}));

	const handleTableChange = (pagination, _filters, sorter) => {
		// Handle pagination
		if (pagination.current !== filters.pageNumber) {
			dispatch(setPage(pagination.current));
		}
		if (pagination.pageSize !== filters.pageSize) {
			dispatch(setPageSize(pagination.pageSize));
		}

		// Handle sorting
		if (sorter.field) {
			dispatch(
				setSorting({
					sortBy: sorter.field,
					isDescending: sorter.order === "descend",
				})
			);
		} else {
			dispatch(setSorting({ sortBy: "", isDescending: false }));
		}
	};

	return (
		<Table
			columns={columns}
			dataSource={dataSource || []}
			rowKey="id"
			loading={isPending}
			onChange={handleTableChange}
			pagination={{
				current: filters.pageNumber,
				pageSize: filters.pageSize,
				total: totalCount,
				showSizeChanger: true,
				showTotal: (total) => `Total ${total} provinces`,
				pageSizeOptions: ["5", "10", "20", "50"],
			}}
		/>
	);
}

ProvinceTable.propTypes = {
	onEditProvince: PropTypes.func,
};

export default ProvinceTable;
