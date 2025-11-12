import { Card, Typography, Empty, Skeleton } from "antd";
import { useNavigate } from "react-router-dom";
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

const COLORS = [
	"#1890ff",
	"#52c41a",
	"#faad14",
	"#f5222d",
	"#722ed1",
	"#13c2c2",
	"#eb2f96",
	"#fa8c16",
	"#a0d911",
	"#2f54eb",
];

function TopLocationsChart({ data, isPending }) {
	const navigate = useNavigate();

	const handleBarClick = (data) => {
		if (data && data.locationId) {
			navigate(`/manage/destinations/${data.locationId}`);
		}
	};

	if (isPending) {
		return (
			<Card>
				<Skeleton active paragraph={{ rows: 12 }} />
			</Card>
		);
	}

	if (!data || data.length === 0) {
		return (
			<Card>
				<Title level={4}>Top 10 Most Visited Locations</Title>
				<Empty
					description="No location data available"
					style={{ padding: "40px 0" }}
				/>
			</Card>
		);
	}

	return (
		<Card>
			<Title level={4} style={{ marginBottom: 20 }}>
				Top 10 Most Visited Locations
			</Title>
			<ResponsiveContainer width="100%" height={400}>
				<BarChart
					data={data}
					layout="vertical"
					margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
				>
					<CartesianGrid strokeDasharray="3 3" />
					<XAxis type="number" />
					<YAxis
						dataKey="locationName"
						type="category"
						width={150}
						tick={{ fontSize: 12 }}
					/>
					<Tooltip
						contentStyle={{
							backgroundColor: "#fff",
							border: "1px solid #d9d9d9",
							borderRadius: "4px",
						}}
						formatter={(value, name, props) => [
							value,
							`${props.payload.locationName} (${props.payload.provinceName})`,
						]}
					/>
					<Bar
						dataKey="visitCount"
						radius={[0, 8, 8, 0]}
						onClick={handleBarClick}
						cursor="pointer"
					>
						{data.map((entry, index) => (
							<Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
						))}
					</Bar>
				</BarChart>
			</ResponsiveContainer>
		</Card>
	);
}

export default TopLocationsChart;
