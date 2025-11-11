import { useState } from "react";
import { Space, Card, Typography, Alert, Button, Row, Col } from "antd";
import StatsCards from "./StatsCards";
import TopProvincesChart from "./TopProvincesChart";
import TopLocationsChart from "./TopLocationsChart";
import ItineraryTrendsChart from "./ItineraryTrendsChart";
import DashboardFilters from "./DashboardFilters";
import { useGetDashboardOverview } from "./useGetDashboardOverview";
import { useGetTopProvinces } from "./useGetTopProvinces";
import { useGetTopLocations } from "./useGetTopLocations";
import { useGetItineraryTrends } from "./useGetItineraryTrends";
import { ERROR_NOTIFICATION } from "../../../utils/constant";

const { Title } = Typography;

function DashboardLayout() {
	const [filters, setFilters] = useState({
		startDate: null,
		endDate: null,
	});
	const [lastUpdated, setLastUpdated] = useState(new Date());

	// Fetch all dashboard data
	const {
		overview,
		isPending: isOverviewPending,
		error: overviewError,
		refetch: refetchOverview,
	} = useGetDashboardOverview(filters);

	const {
		provinces,
		isPending: isProvincesPending,
		error: provincesError,
		refetch: refetchProvinces,
	} = useGetTopProvinces({ ...filters, limit: 5 });

	const {
		locations,
		isPending: isLocationsPending,
		error: locationsError,
		refetch: refetchLocations,
	} = useGetTopLocations({ ...filters, limit: 10 });

	const {
		trends,
		isPending: isTrendsPending,
		error: trendsError,
		refetch: refetchTrends,
	} = useGetItineraryTrends({ ...filters, groupBy: "day" });

	// Combine all errors
	const hasError =
		overviewError || provincesError || locationsError || trendsError;
	const isPending =
		isOverviewPending ||
		isProvincesPending ||
		isLocationsPending ||
		isTrendsPending;

	const handleFilterChange = (newFilters) => {
		setFilters(newFilters);
	};

	const handleRefresh = () => {
		refetchOverview();
		refetchProvinces();
		refetchLocations();
		refetchTrends();
		setLastUpdated(new Date());
	};

	return (
		<Card>
			<Space direction="vertical" size="large" style={{ width: "100%" }}>
				<Space
					direction="horizontal"
					style={{ width: "100%", justifyContent: "space-between" }}
				>
					<Title level={2} style={{ margin: 0 }}>
						Dashboard
					</Title>
				</Space>

				{hasError && (
					<Alert
						message="Error Loading Dashboard Data"
						description={
							overviewError?.message ||
							provincesError?.message ||
							locationsError?.message ||
							trendsError?.message ||
							"Failed to load some dashboard data. Please try refreshing."
						}
						type={ERROR_NOTIFICATION}
						showIcon
						action={
							<Button size="small" type="primary" onClick={handleRefresh}>
								Retry
							</Button>
						}
					/>
				)}

				<DashboardFilters
					onFilterChange={handleFilterChange}
					onRefresh={handleRefresh}
					lastUpdated={lastUpdated}
					isPending={isPending}
				/>

				<StatsCards data={overview} isPending={isOverviewPending} />

				<Row gutter={[16, 16]}>
					<Col xs={24} lg={12}>
						<TopProvincesChart
							data={provinces}
							isPending={isProvincesPending}
						/>
					</Col>
					<Col xs={24} lg={12}>
						<ItineraryTrendsChart data={trends} isPending={isTrendsPending} />
					</Col>
				</Row>

				<Row gutter={[16, 16]}>
					<Col xs={24}>
						<TopLocationsChart
							data={locations}
							isPending={isLocationsPending}
						/>
					</Col>
				</Row>
			</Space>
		</Card>
	);
}

export default DashboardLayout;
