import { Button, Col, Form, Input, Row, Space } from "antd";
import { SearchOutlined, ReloadOutlined } from "@ant-design/icons";
import { useDispatch, useSelector } from "react-redux";
import { setFilters, resetFilters } from "../../../redux/operatorSlice";

function OperatorQuery() {
	const [form] = Form.useForm();
	const dispatch = useDispatch();
	const filters = useSelector((state) => state.operator.filters);

	const handleSubmit = (values) => {
		dispatch(setFilters(values));
	};

	const handleReset = () => {
		form.resetFields();
		dispatch(resetFilters());
	};

	return (
		<Form
			form={form}
			layout="vertical"
			onFinish={handleSubmit}
			initialValues={filters}
			className="mb-4"
		>
			<Row gutter={[16, 16]}>
				<Col xs={24} sm={12} md={8}>
					<Form.Item name="username" label="Username">
						<Input placeholder="Search by username" />
					</Form.Item>
				</Col>
				<Col xs={24} sm={12} md={8}>
					<Form.Item name="email" label="Email">
						<Input placeholder="Search by email" />
					</Form.Item>
				</Col>
				<Col xs={24} sm={12} md={8}>
					<Form.Item name="phoneNumber" label="Phone Number">
						<Input placeholder="Search by phone" />
					</Form.Item>
				</Col>
			</Row>

			<Row>
				<Col span={24} style={{ textAlign: "right" }}>
					<Space>
						<Button type="primary" htmlType="submit" icon={<SearchOutlined />}>
							Apply
						</Button>
						<Button htmlType="button" onClick={handleReset} icon={<ReloadOutlined />}>
							Reset
						</Button>
					</Space>
				</Col>
			</Row>
		</Form>
	);
}

export default OperatorQuery;
