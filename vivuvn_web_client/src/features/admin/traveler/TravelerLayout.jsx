import { Card, Row, Col } from "antd";
import TravelerTable from "./TravelerTable";
import TravelerQuery from "./TravelerQuery";

function TravelerLayout() {
	return (
		<div className="container mx-auto px-4 py-4">
			<Row>
				<Col span={24}>
					<Card title="Traveler Management" bordered={false}>
						<TravelerQuery />
						<TravelerTable />
					</Card>
				</Col>
			</Row>
		</div>
	);
}

export default TravelerLayout;
