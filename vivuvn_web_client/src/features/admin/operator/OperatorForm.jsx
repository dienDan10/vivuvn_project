import { Modal, Form, Input, Button } from "antd";
import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { useCreateOperator } from "./useCreateOperator";

function OperatorForm({ open, onClose }) {
	const [form] = Form.useForm();
	const createMutation = useCreateOperator();
	const [submitting, setSubmitting] = useState(false);

	// Reset form when modal is opened/closed
	useEffect(() => {
		if (open) {
			form.resetFields();
		}
	}, [open, form]);

	const handleSubmit = async () => {
		try {
			const values = await form.validateFields();
			setSubmitting(true);

			const submitValues = {
				username: values.username,
				email: values.email,
				phoneNumber: values.phoneNumber,
				password: values.password,
			};

			createMutation.mutate(submitValues, {
				onSuccess: () => {
					onClose();
				},
				onSettled: () => {
					setSubmitting(false);
				},
			});
		} catch (error) {
			console.error("Validation failed:", error);
		}
	};

	const handleCancel = () => {
		form.resetFields();
		onClose();
	};

	return (
		<Modal
			title="Add New Operator"
			open={open}
			onCancel={handleCancel}
			footer={[
				<Button key="cancel" onClick={handleCancel}>
					Cancel
				</Button>,
				<Button
					key="submit"
					type="primary"
					loading={submitting}
					onClick={handleSubmit}
				>
					Create
				</Button>,
			]}
			destroyOnClose
		>
			<Form form={form} layout="vertical" className="mt-4">
				<Form.Item
					name="username"
					label="Username"
					rules={[
						{ required: true, message: "Please input username!" },
						{ min: 3, message: "Username must be at least 3 characters" },
						{
							pattern: /^[a-zA-Z0-9_]+$/,
							message: "Username can only contain letters, numbers, and underscores",
						},
					]}
				>
					<Input placeholder="Enter username" />
				</Form.Item>

				<Form.Item
					name="email"
					label="Email"
					rules={[
						{ required: true, message: "Please input email!" },
						{ type: "email", message: "Please enter a valid email!" },
					]}
				>
					<Input placeholder="Enter email" />
				</Form.Item>

				<Form.Item
					name="phoneNumber"
					label="Phone Number"
					rules={[
						{ required: true, message: "Please input phone number!" },
						{
							pattern: /^[0-9]{10,15}$/,
							message: "Please enter a valid phone number (10-15 digits)",
						},
					]}
				>
					<Input placeholder="Enter phone number" />
				</Form.Item>

				<Form.Item
					name="password"
					label="Password"
					rules={[
						{ required: true, message: "Please input password!" },
						{ min: 6, message: "Password must be at least 6 characters" },
					]}
				>
					<Input.Password placeholder="Enter password" />
				</Form.Item>

				<Form.Item
					name="confirmPassword"
					label="Confirm Password"
					dependencies={["password"]}
					rules={[
						{ required: true, message: "Please confirm password!" },
						({ getFieldValue }) => ({
							validator(_, value) {
								if (!value || getFieldValue("password") === value) {
									return Promise.resolve();
								}
								return Promise.reject(
									new Error("The two passwords do not match!")
								);
							},
						}),
					]}
				>
					<Input.Password placeholder="Confirm password" />
				</Form.Item>
			</Form>
		</Modal>
	);
}

OperatorForm.propTypes = {
	open: PropTypes.bool.isRequired,
	onClose: PropTypes.func.isRequired,
};

export default OperatorForm;
