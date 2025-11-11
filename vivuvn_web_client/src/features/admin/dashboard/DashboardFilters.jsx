import { Space, DatePicker, Button, Typography } from "antd";
import { ReloadOutlined } from "@ant-design/icons";
import dayjs from "dayjs";

const { RangePicker } = DatePicker;
const { Text } = Typography;

function DashboardFilters({ onFilterChange, onRefresh, lastUpdated, isPending }) {
	const rangePresets = [
		{
			label: "Last 7 Days",
			value: [dayjs().subtract(7, "days"), dayjs()],
		},
		{
			label: "Last 30 Days",
			value: [dayjs().subtract(30, "days"), dayjs()],
		},
		{
			label: "Last 60 Days",
			value: [dayjs().subtract(60, "days"), dayjs()],
		},
		{
			label: "Last 90 Days",
			value: [dayjs().subtract(90, "days"), dayjs()],
		},
	];

	const handleDateChange = (dates) => {
		if (dates && dates[0] && dates[1]) {
			onFilterChange({
				startDate: dates[0].format("YYYY-MM-DD"),
				endDate: dates[1].format("YYYY-MM-DD"),
			});
		} else {
			// Clear filters
			onFilterChange({
				startDate: null,
				endDate: null,
			});
		}
	};

	return (
		<Space
			direction="horizontal"
			style={{
				width: "100%",
				justifyContent: "space-between",
				flexWrap: "wrap",
			}}
		>
			<Space direction="horizontal" wrap>
				<RangePicker
					presets={rangePresets}
					onChange={handleDateChange}
					format="YYYY-MM-DD"
					style={{ minWidth: 300 }}
					disabled={isPending}
				/>
				<Button
					icon={<ReloadOutlined />}
					onClick={onRefresh}
					loading={isPending}
					type="default"
				>
					Refresh
				</Button>
			</Space>

			{lastUpdated && (
				<Text type="secondary" style={{ fontSize: 12 }}>
					Last updated: {dayjs(lastUpdated).format("MMM DD, YYYY HH:mm:ss")}
				</Text>
			)}
		</Space>
	);
}

export default DashboardFilters;
