import { Modal, Form, Input, Button, Spin, Upload } from "antd";
import { InboxOutlined } from "@ant-design/icons";
import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { useCreateProvince } from "./useCreateProvince";
import { useUpdateProvince } from "./useUpdateProvince";
import { useGetProvinceById } from "./useGetProvinceById";

const { Dragger } = Upload;

function ProvinceForm({ open, onClose, provinceId, mode }) {
	const [form] = Form.useForm();
	const isEdit = mode === "edit";
	const [imagePreview, setImagePreview] = useState(null);
	const [imageFile, setImageFile] = useState(null);

	// Query province detail for edit mode - only when modal is open and in edit mode
	const { province, isPending: isLoadingProvince } = useGetProvinceById(
		provinceId,
		open && isEdit // Only fetch when modal is open AND in edit mode
	);

	const createMutation = useCreateProvince();
	const updateMutation = useUpdateProvince();
	const [submitting, setSubmitting] = useState(false);

	// Set form fields when province data is loaded (for edit mode)
	useEffect(() => {
		if (province && isEdit) {
			form.setFieldsValue({
				name: province.name || "",
				provinceCode: province.provinceCode || "",
				nameNormalized: province.nameNormalized || "",
			});

			// Set image preview for existing image URL from database
			if (province.imageUrl) {
				setImagePreview(province.imageUrl);
			}
		}
	}, [province, form, isEdit]);

	// Reset form when modal is opened/closed
	useEffect(() => {
		if (open && !isEdit) {
			form.resetFields();
			setImagePreview(null);
			setImageFile(null);
		} else if (!open) {
			// Clean up when modal closes
			setImagePreview(null);
			setImageFile(null);
		}
	}, [open, form, isEdit]);

	const handleSubmit = async () => {
		const values = await form.validateFields();
		setSubmitting(true);

		// Prepare submit values
		// TODO: When upload API is ready, upload imageFile first to get URL
		// For now, keeping existing imageUrl if no new file uploaded
		const submitValues = {
			name: values.name,
			provinceCode: values.provinceCode,
			nameNormalized: values.nameNormalized,
			// If new file uploaded, backend will handle it via imageFile
			// If editing without new file, keep existing imageUrl
			imageFile: imageFile, // Backend will process this
		};

		if (isEdit) {
			updateMutation.mutate(
				{ id: provinceId, ...submitValues },
				{
					onSuccess: () => {
						onClose(true);
					},
					onSettled: () => {
						setSubmitting(false);
					},
				}
			);
		} else {
			createMutation.mutate(submitValues, {
				onSuccess: () => {
					onClose(true);
				},
				onSettled: () => {
					setSubmitting(false);
				},
			});
		}
	};

	// eslint-disable-next-line no-unused-vars
	const customRequest = ({ file, onSuccess, onProgress, onError }) => {
		if (file) {
			setImageFile(file);

			// Create preview immediately
			const reader = new FileReader();
			reader.addEventListener("load", () => {
				setImagePreview(reader.result);
			});
			reader.readAsDataURL(file);
		}

		setTimeout(() => {
			onSuccess("ok");
		}, 1000);
	};

	const handleRemoveFile = () => {
		setImageFile(null);
		setImagePreview(null);
	};

	const isSubmitting =
		submitting || createMutation.isPending || updateMutation.isPending;
	const modalTitle = isEdit ? "Edit Province" : "Create Province";

	return (
		<Modal
			title={modalTitle}
			open={open}
			onCancel={() => onClose(false)}
			width={600}
			footer={[
				<Button
					key="cancel"
					onClick={() => onClose(false)}
					disabled={isSubmitting}
				>
					Cancel
				</Button>,
				<Button
					key="submit"
					type="primary"
					loading={isSubmitting}
					onClick={handleSubmit}
					disabled={isSubmitting || (isEdit && isLoadingProvince)}
				>
					{isEdit ? "Update" : "Create"}
				</Button>,
			]}
			maskClosable={!isSubmitting}
			closable={!isSubmitting}
		>
			<Spin spinning={isEdit && isLoadingProvince}>
				<Form form={form} layout="vertical" disabled={isSubmitting}>
					<Form.Item
						name="name"
						label="Province Name"
						rules={[{ required: true, message: "Please enter province name" }]}
					>
						<Input placeholder="Enter province name" />
					</Form.Item>

					<Form.Item name="provinceCode" label="Province Code">
						<Input placeholder="Enter province code" />
					</Form.Item>

					<Form.Item name="nameNormalized" label="Name Normalized">
						<Input placeholder="Enter name normalized" />
					</Form.Item>

					{/* Image Upload with Preview */}
					<Form.Item label="Province Image">
						<div className="flex flex-col md:flex-row gap-4 items-start">
							{/* Image preview on the left */}
							<div className="w-full md:w-1/3 flex justify-center">
								{imagePreview ? (
									<img
										src={imagePreview}
										alt="Province Preview"
										style={{
											maxWidth: "100%",
											height: "auto",
											objectFit: "contain",
											borderRadius: "4px",
											border: "1px solid #d9d9d9",
										}}
										onError={(e) => {
											e.target.src =
												"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mN8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==";
											e.target.alt = "Failed to load image";
										}}
									/>
								) : (
									<div
										className="flex items-center justify-center bg-gray-100 text-gray-400"
										style={{
											width: "150px",
											height: "150px",
											borderRadius: "4px",
											border: "1px dashed #d9d9d9",
										}}
									>
										No Image
									</div>
								)}
							</div>

							{/* Upload control on the right */}
							<div className="w-full md:w-2/3">
								<Dragger
									name="image"
									accept="image/png, image/jpg, image/jpeg"
									customRequest={customRequest}
									onRemove={handleRemoveFile}
									multiple={false}
									maxCount={1}
									showUploadList={true}
								>
									<p className="ant-upload-drag-icon">
										<InboxOutlined />
									</p>
									<p className="ant-upload-text">
										Click or drag file to this area to upload
									</p>
									<p className="ant-upload-hint">
										Upload province image (jpg, jpeg, png)
									</p>
								</Dragger>
							</div>
						</div>
					</Form.Item>
				</Form>
			</Spin>
		</Modal>
	);
}

ProvinceForm.propTypes = {
	open: PropTypes.bool.isRequired,
	onClose: PropTypes.func.isRequired,
	provinceId: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
	mode: PropTypes.oneOf(["edit", "create"]).isRequired,
};

export default ProvinceForm;
