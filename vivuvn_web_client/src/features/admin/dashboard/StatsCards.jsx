import { Row, Col, Card, Statistic, Skeleton } from "antd";
import {
	UserOutlined,
	EnvironmentOutlined,
	GlobalOutlined,
	FileTextOutlined,
} from "@ant-design/icons";

function StatsCards({ data, isPending }) {
	if (isPending) {
		return (
			<Row gutter={[16, 16]}>
				{[1, 2, 3, 4].map((key) => (
					<Col xs={24} sm={12} lg={6} key={key}>
						<Card>
							<Skeleton active paragraph={{ rows: 1 }} />
						</Card>
					</Col>
				))}
			</Row>
		);
	}

	const stats = [
		{
			title: "Total Travelers",
			value: data?.totalTravelers || 0,
			icon: <UserOutlined style={{ fontSize: 24, color: "#1890ff" }} />,
			color: "#1890ff",
		},
		{
			title: "Total Locations",
			value: data?.totalLocations || 0,
			icon: <EnvironmentOutlined style={{ fontSize: 24, color: "#52c41a" }} />,
			color: "#52c41a",
		},
		{
			title: "Total Provinces",
			value: data?.totalProvinces || 0,
			icon: <GlobalOutlined style={{ fontSize: 24, color: "#faad14" }} />,
			color: "#faad14",
		},
		{
			title: "Total Itineraries",
			value: data?.totalItineraries || 0,
			icon: <FileTextOutlined style={{ fontSize: 24, color: "#722ed1" }} />,
			color: "#722ed1",
		},
	];

	return (
		<Row gutter={[16, 16]}>
			{stats.map((stat, index) => (
				<Col xs={24} sm={12} lg={6} key={index}>
					<Card bordered={false} style={{ boxShadow: "0 1px 2px rgba(0,0,0,0.05)" }}>
						<Statistic
							title={stat.title}
							value={stat.value}
							prefix={stat.icon}
							valueStyle={{ color: stat.color }}
						/>
					</Card>
				</Col>
			))}
		</Row>
	);
}

export default StatsCards;
