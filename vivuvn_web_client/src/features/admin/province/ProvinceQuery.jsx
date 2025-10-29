import { Button, Card, Col, Form, Input, Row, Space } from "antd";
import { SearchOutlined, ReloadOutlined } from "@ant-design/icons";
import { useDispatch, useSelector } from "react-redux";
import {
	setFilters,
	resetFilters,
	setPage,
} from "../../../redux/provinceSlice";

function ProvinceQuery() {
	const dispatch = useDispatch();
	const filters = useSelector((state) => state.province.filters);
	const [form] = Form.useForm();

	const handleSearch = (values) => {
		dispatch(setPage(1)); // Reset to page 1 when searching
		dispatch(setFilters(values));
	};

	const handleReset = () => {
		form.resetFields();
		dispatch(resetFilters());
		dispatch(setPage(1));
	};

	return (
		<Card style={{ marginBottom: 16 }}>
			<Form
				form={form}
				layout="vertical"
				onFinish={handleSearch}
				initialValues={filters}
			>
				<Row gutter={16}>
					<Col xs={24} sm={12} md={8}>
						<Form.Item label="Province Name" name="name">
							<Input placeholder="Search by name" allowClear />
						</Form.Item>
					</Col>
					<Col xs={24} sm={12} md={8}>
						<Form.Item label="Province Code" name="provinceCode">
							<Input placeholder="Search by code" allowClear />
						</Form.Item>
					</Col>
					<Col xs={24} md={8}>
						<Form.Item label=" " colon={false}>
							<Space>
								<Button
									type="primary"
									htmlType="submit"
									icon={<SearchOutlined />}
								>
									Search
								</Button>
								<Button icon={<ReloadOutlined />} onClick={handleReset}>
									Reset
								</Button>
							</Space>
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</Card>
	);
}

export default ProvinceQuery;
