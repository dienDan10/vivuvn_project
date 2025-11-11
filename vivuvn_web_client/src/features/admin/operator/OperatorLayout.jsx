import { Card, Row, Col, Button, Space, Typography } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { useState } from "react";
import OperatorTable from "./OperatorTable";
import OperatorQuery from "./OperatorQuery";
import OperatorForm from "./OperatorForm";

const { Title } = Typography;

function OperatorLayout() {
	const [isFormOpen, setIsFormOpen] = useState(false);

	const handleOpenForm = () => {
		setIsFormOpen(true);
	};

	const handleCloseForm = () => {
		setIsFormOpen(false);
	};

	return (
		<div className="container mx-auto px-4 py-4">
			<Row>
				<Col span={24}>
					<Card bordered={false}>
						<Space direction="vertical" size="large" style={{ width: "100%" }}>
							<div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
								<Title level={2} style={{ margin: 0 }}>
									Operator Management
								</Title>
								<Button
									type="primary"
									icon={<PlusOutlined />}
									onClick={handleOpenForm}
								>
									Add Operator
								</Button>
							</div>

							<OperatorQuery />
							<OperatorTable />
						</Space>
					</Card>
				</Col>
			</Row>

			<OperatorForm open={isFormOpen} onClose={handleCloseForm} />
		</div>
	);
}

export default OperatorLayout;
