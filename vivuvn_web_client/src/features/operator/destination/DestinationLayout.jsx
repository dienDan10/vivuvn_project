import { Card, Space, Typography, Alert, Button } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { useState } from "react";
import DestinationTable from "./DestinationTable";
import DestinationQuery from "./DestinationQuery";
import DestinationForm from "./DestinationForm";
import { useGetDestinations } from "./useGetDestinations";

const { Title } = Typography;

function DestinationLayout() {
	const { error, refetch } = useGetDestinations();
	const [modalOpen, setModalOpen] = useState(false);
	const [mode, setMode] = useState("create");
	const [selectedDestinationId, setSelectedDestinationId] = useState(null);

	const handleAdd = () => {
		setMode("create");
		setSelectedDestinationId(null);
		setModalOpen(true);
	};

	const handleEdit = (record) => {
		setMode("edit");
		setSelectedDestinationId(record.id);
		setModalOpen(true);
	};

	const handleFormClose = (success) => {
		setModalOpen(false);
		if (success) {
			// Form was submitted successfully, data will refresh via react-query
			setSelectedDestinationId(null);
		}
	};

	return (
		<Card>
			<Space direction="vertical" size="large" style={{ width: "100%" }}>
				<Space
					direction="horizontal"
					style={{ width: "100%", justifyContent: "space-between" }}
				>
					<Title level={2} style={{ margin: 0 }}>
						Destinations
					</Title>
					<Button type="primary" icon={<PlusOutlined />} onClick={handleAdd}>
						Add Destination
					</Button>
				</Space>

				{error && (
					<Alert
						message="Error Loading Destinations"
						description={error?.message || "An error occurred"}
						type="error"
						showIcon
						closable
						onClose={() => refetch()}
					/>
				)}

				<DestinationQuery />

				<DestinationTable onEditDestination={handleEdit} />
			</Space>

			<DestinationForm
				open={modalOpen}
				onClose={handleFormClose}
				destinationId={selectedDestinationId}
				mode={mode}
			/>
		</Card>
	);
}

export default DestinationLayout;
