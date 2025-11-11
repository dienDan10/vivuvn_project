import { Card, Typography, Empty, Skeleton } from "antd";
import {
	BarChart,
	Bar,
	XAxis,
	YAxis,
	CartesianGrid,
	Tooltip,
	ResponsiveContainer,
	Cell,
} from "recharts";

const { Title } = Typography;

const COLORS = ["#1890ff", "#52c41a", "#faad14", "#f5222d", "#722ed1"];

function TopProvincesChart({ data, isPending }) {
	if (isPending) {
		return (
			<Card>
				<Skeleton active paragraph={{ rows: 8 }} />
			</Card>
		);
	}

	if (!data || data.length === 0) {
		return (
			<Card>
				<Title level={4}>Top 5 Most Visited Provinces</Title>
				<Empty
					description="No province data available"
					style={{ padding: "40px 0" }}
				/>
			</Card>
		);
	}

	return (
		<Card>
			<Title level={4} style={{ marginBottom: 20 }}>
				Top 5 Most Visited Provinces
			</Title>
			<ResponsiveContainer width="100%" height={300}>
				<BarChart
					data={data}
					margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
				>
					<CartesianGrid strokeDasharray="3 3" />
					<XAxis
						dataKey="provinceName"
						angle={-15}
						textAnchor="end"
						height={80}
					/>
					<YAxis
						label={{ value: "Visit Count", angle: -90, position: "insideLeft" }}
					/>
					<Tooltip
						contentStyle={{
							backgroundColor: "#fff",
							border: "1px solid #d9d9d9",
							borderRadius: "4px",
						}}
					/>
					<Bar dataKey="visitCount" radius={[8, 8, 0, 0]}>
						{data.map((entry, index) => (
							<Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
						))}
					</Bar>
				</BarChart>
			</ResponsiveContainer>
		</Card>
	);
}

export default TopProvincesChart;
