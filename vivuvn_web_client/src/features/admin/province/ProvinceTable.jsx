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

function ProvinceTable({ onEditProvince }) {
	const { provinces, isPending } = useGetProvinces();
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
			sorter: (a, b) => a.id - b.id,
		},
		{
			title: "Name",
			dataIndex: "name",
			key: "name",
			sorter: (a, b) => a.name.localeCompare(b.name),
		},
		{
			title: "Code",
			dataIndex: "provinceCode",
			key: "provinceCode",
			sorter: (a, b) => a.provinceCode.localeCompare(b.provinceCode),
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

	return (
		<Table
			columns={columns}
			dataSource={dataSource || []}
			rowKey="id"
			loading={isPending}
			pagination={{
				showSizeChanger: true,
				showTotal: (total) => `Total ${total} provinces`,
			}}
		/>
	);
}

ProvinceTable.propTypes = {
	onEditProvince: PropTypes.func,
};

export default ProvinceTable;
