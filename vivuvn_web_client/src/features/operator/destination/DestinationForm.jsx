import { Modal, Form, Input, Button, Spin, Upload, Select } from "antd";
import { InboxOutlined } from "@ant-design/icons";
import PropTypes from "prop-types";
import { useEffect, useState } from "react";
import { useCreateDestination } from "./useCreateDestination";
import { useUpdateDestination } from "./useUpdateDestination";
import { useGetDestinationById } from "./useGetDestinationById";
import { useGetAllProvinces } from "./useGetAllProvinces";

const { Dragger } = Upload;
const { TextArea } = Input;

function DestinationForm({ open, onClose, destinationId, mode }) {
	const [form] = Form.useForm();
	const isEdit = mode === "edit";
	const [imagePreviews, setImagePreviews] = useState([]);
	const [imageFiles, setImageFiles] = useState([]);

	// Query destination detail for edit mode
	const { destination, isPending: isLoadingDestination } =
		useGetDestinationById(destinationId, open && isEdit);

	// Get provinces for dropdown
	const { provinces, isPending: isLoadingProvinces } = useGetAllProvinces();

	const createMutation = useCreateDestination();
	const updateMutation = useUpdateDestination();
	const [submitting, setSubmitting] = useState(false);

	// Set form fields when destination data is loaded (for edit mode)
	useEffect(() => {
		if (destination && isEdit) {
			let provinceIdValue;
			// If provinceId is not available but provinceName is, find the matching province
			if (destination.provinceName && provinces) {
				const matchingProvince = provinces.find(
					(p) => p.name === destination.provinceName
				);
				provinceIdValue = matchingProvince?.id;
			}

			form.setFieldsValue({
				name: destination.name || "",
				provinceId: provinceIdValue,
				description: destination.description || "",
				address: destination.address || "",
				websiteUri: destination.websiteUri || "",
			});

			// Set image previews for existing images from database
			if (destination.photos && destination.photos.length > 0) {
				setImagePreviews(destination.photos);
			}
		}
	}, [destination, form, isEdit, provinces]);

	// Reset form when modal is opened/closed
	useEffect(() => {
		if (open && !isEdit) {
			form.resetFields();
			setImagePreviews([]);
			setImageFiles([]);
		} else if (!open) {
			// Clean up when modal closes
			setImagePreviews([]);
			setImageFiles([]);
		}
	}, [open, form, isEdit]);

	const handleSubmit = async () => {
		const values = await form.validateFields();
		setSubmitting(true);

		const submitValues = {
			name: values.name,
			provinceId: values.provinceId,
			description: values.description,
			address: values.address,
			websiteUri: values.websiteUri,
			images: imageFiles, // Backend will process this array
		};

		if (isEdit) {
			updateMutation.mutate(
				{ id: destinationId, ...submitValues },
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

	const customRequest = ({ file, onSuccess }) => {
		if (file) {
			// Add file to the array
			setImageFiles((prev) => [...prev, file]);

			// Create preview
			const reader = new FileReader();
			reader.addEventListener("load", () => {
				setImagePreviews((prev) => [...prev, reader.result]);
			});
			reader.readAsDataURL(file);
		}

		setTimeout(() => {
			onSuccess("ok");
		}, 1000);
	};

	const handleRemoveFile = (file) => {
		// Find the index
		const index = imageFiles.findIndex((f) => f.uid === file.uid);
		if (index !== -1) {
			setImageFiles((prev) => prev.filter((_, i) => i !== index));
			setImagePreviews((prev) => prev.filter((_, i) => i !== index));
		}
	};

	const isSubmitting =
		submitting || createMutation.isPending || updateMutation.isPending;
	const modalTitle = isEdit ? "Edit Destination" : "Create Destination";

	return (
		<Modal
			title={modalTitle}
			open={open}
			onCancel={() => onClose(false)}
			width={800}
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
					disabled={isSubmitting || (isEdit && isLoadingDestination)}
				>
					{isEdit ? "Update" : "Create"}
				</Button>,
			]}
			maskClosable={!isSubmitting}
			closable={!isSubmitting}
		>
			<Spin spinning={(isEdit && isLoadingDestination) || isLoadingProvinces}>
				<Form form={form} layout="vertical" disabled={isSubmitting}>
					<Form.Item
						name="name"
						label="Destination Name"
						rules={[{ required: true, message: "Please enter destination name" }]}
					>
						<Input placeholder="Enter destination name" />
					</Form.Item>

					<Form.Item
						name="provinceId"
						label="Province"
						rules={[{ required: true, message: "Please select a province" }]}
					>
						<Select
							placeholder="Select province"
							showSearch
							filterOption={(input, option) =>
								(option?.label ?? "")
									.toLowerCase()
									.includes(input.toLowerCase())
							}
							options={provinces?.map((p) => ({
								value: p.id,
								label: p.name,
							}))}
						/>
					</Form.Item>

					<Form.Item name="description" label="Description">
						<TextArea rows={4} placeholder="Enter destination description" />
					</Form.Item>

					<Form.Item name="address" label="Address">
						<Input placeholder="Enter address" />
					</Form.Item>

					<Form.Item
						name="websiteUri"
						label="Website URL"
						rules={[
							{ type: "url", message: "Please enter a valid URL" },
						]}
					>
						<Input placeholder="https://example.com" />
					</Form.Item>

					{/* Image Upload with Preview Gallery */}
					<Form.Item
						label="Images"
						rules={[
							{
								validator: async () => {
									if (!isEdit && imageFiles.length === 0) {
										return Promise.reject(
											new Error("At least one image is required")
										);
									}
									return Promise.resolve();
								},
							},
						]}
					>
						{/* Image preview gallery */}
						{imagePreviews.length > 0 && (
							<div className="mb-4 grid grid-cols-3 gap-2">
								{imagePreviews.map((preview, index) => (
									<img
										key={index}
										src={preview}
										alt={`Preview ${index + 1}`}
										style={{
											width: "100%",
											height: "150px",
											objectFit: "cover",
											borderRadius: "4px",
											border: "1px solid #d9d9d9",
										}}
										onError={(e) => {
											e.target.src =
												"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mN8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==";
											e.target.alt = "Failed to load image";
										}}
									/>
								))}
							</div>
						)}

						{/* Upload control */}
						<Dragger
							name="images"
							accept="image/png, image/jpg, image/jpeg"
							customRequest={customRequest}
							onRemove={handleRemoveFile}
							multiple={true}
							showUploadList={true}
						>
							<p className="ant-upload-drag-icon">
								<InboxOutlined />
							</p>
							<p className="ant-upload-text">
								Click or drag files to this area to upload
							</p>
							<p className="ant-upload-hint">
								Upload destination images (jpg, jpeg, png). Multiple images
								supported.
								{!isEdit && " At least one image is required."}
							</p>
						</Dragger>
					</Form.Item>
				</Form>
			</Spin>
		</Modal>
	);
}

DestinationForm.propTypes = {
	open: PropTypes.bool.isRequired,
	onClose: PropTypes.func.isRequired,
	destinationId: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
	mode: PropTypes.oneOf(["edit", "create"]).isRequired,
};

export default DestinationForm;
