import { useState } from "react";
import { Button, Space, Card, Typography, Alert } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import ProvinceTable from "./ProvinceTable";
import ProvinceForm from "./ProvinceForm";
import ProvinceQuery from "./ProvinceQuery";
import { useGetProvinces } from "./useGetProvinces";

const { Title } = Typography;

function ProvinceLayout() {
	const { error, refetch } = useGetProvinces();

	const [modalOpen, setModalOpen] = useState(false);
	const [mode, setMode] = useState("create"); // "create" or "edit"
	const [selectedProvinceId, setSelectedProvinceId] = useState(null);

	const handleAdd = () => {
		setMode("create");
		setSelectedProvinceId(null);
		setModalOpen(true);
	};

	const handleEdit = (record) => {
		setMode("edit");
		setSelectedProvinceId(record.id);
		setModalOpen(true);
	};

	const handleFormClose = () => {
		setModalOpen(false);
		// Reset state
		setSelectedProvinceId(null);
		setMode("create");
	};

	return (
		<Card>
			<Space direction="vertical" size="large" style={{ width: "100%" }}>
				<Space
					direction="horizontal"
					style={{ width: "100%", justifyContent: "space-between" }}
				>
					<Title level={2} style={{ margin: 0 }}>Provinces</Title>
					<Button type="primary" icon={<PlusOutlined />} onClick={handleAdd}>
						Add Province
					</Button>
				</Space>

				{error && (
					<Alert
						message="Error"
						description={`Failed to load provinces: ${
							error.message || "Unknown error"
						}`}
						type="error"
						showIcon
						action={
							<Button size="small" type="primary" onClick={() => refetch()}>
								Retry
							</Button>
						}
					/>
				)}

				<ProvinceQuery />

				<ProvinceTable onEditProvince={handleEdit} />

				<ProvinceForm
					open={modalOpen}
					onClose={handleFormClose}
					provinceId={selectedProvinceId}
					mode={mode}
				/>
			</Space>
		</Card>
	);
}

export default ProvinceLayout;
