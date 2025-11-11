import { Card, Typography, Empty, Skeleton } from "antd";
import {
	LineChart,
	Line,
	XAxis,
	YAxis,
	CartesianGrid,
	Tooltip,
	ResponsiveContainer,
	Area,
	AreaChart,
} from "recharts";

const { Title } = Typography;

function ItineraryTrendsChart({ data, isPending }) {
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
				<Title level={4}>Itinerary Creation Trends</Title>
				<Empty
					description="No itinerary trend data available"
					style={{ padding: "40px 0" }}
				/>
			</Card>
		);
	}

	return (
		<Card>
			<Title level={4} style={{ marginBottom: 20 }}>
				Itinerary Creation Trends
			</Title>
			<ResponsiveContainer width="100%" height={300}>
				<AreaChart
					data={data}
					margin={{ top: 10, right: 30, left: 0, bottom: 0 }}
				>
					<defs>
						<linearGradient id="colorCount" x1="0" y1="0" x2="0" y2="1">
							<stop offset="5%" stopColor="#1890ff" stopOpacity={0.8} />
							<stop offset="95%" stopColor="#1890ff" stopOpacity={0} />
						</linearGradient>
					</defs>
					<CartesianGrid strokeDasharray="3 3" />
					<XAxis
						dataKey="date"
						angle={-15}
						textAnchor="end"
						height={60}
					/>
					<YAxis
						label={{
							value: "Itineraries Created",
							angle: -90,
							position: "insideLeft",
						}}
					/>
					<Tooltip
						contentStyle={{
							backgroundColor: "#fff",
							border: "1px solid #d9d9d9",
							borderRadius: "4px",
						}}
					/>
					<Area
						type="monotone"
						dataKey="count"
						stroke="#1890ff"
						strokeWidth={2}
						fillOpacity={1}
						fill="url(#colorCount)"
					/>
				</AreaChart>
			</ResponsiveContainer>
		</Card>
	);
}

export default ItineraryTrendsChart;
