import { Form, Input, Modal } from "antd";
import { FaKey, FaCircleUser } from "react-icons/fa6";
import { useChangePassword } from "./useChangePassword";
import { SpinnerSmall } from "../../components/Spinner";
import { useEffect } from "react";

function ChangePasswordModel({ isModalOpen, setIsModalOpen }) {
  const [form] = Form.useForm();
  const {
    mutate: changeUserPassword,
    isPending,
    isSuccess,
  } = useChangePassword();

  const handleCancel = () => {
    form.resetFields();
    setIsModalOpen(false);
  };

  const onFinish = (values) => {
    changeUserPassword({
      oldPassword: values.oldPassword,
      newPassword: values.newPassword,
    });
  };

  // Close the modal and reset form after successful password change
  useEffect(() => {
    if (isSuccess && isModalOpen) {
      form.resetFields();
      setIsModalOpen(false);
    }
  }, [isSuccess, isModalOpen, form, setIsModalOpen]);

  return (
    <Modal
      title="Change Password"
      open={isModalOpen}
      onCancel={handleCancel}
      footer={null}
      centered
    >
      <div className="py-4">
        <div className="text-center mb-6 flex flex-col items-center">
          <FaCircleUser className="text-5xl text-red-700 mb-2" />
          <h1 className="text-xl font-semibold text-gray-800">
            Change Your Password
          </h1>
          <p className="text-gray-500">Please enter your new password below</p>
        </div>

        <Form form={form} onFinish={onFinish} layout="vertical">
          <Form.Item
            name="oldPassword"
            label="Current Password"
            required
            rules={[
              {
                required: true,
                whitespace: true,
                message: "Please enter your current password",
              },
            ]}
          >
            <Input.Password
              prefix={<FaKey className="text-slate-700 mx-2" />}
              placeholder="Current password"
            />
          </Form.Item>

          <Form.Item
            name="newPassword"
            label="New Password"
            required
            rules={[
              { required: true, message: "Please input your password!" },
              {
                min: 6,
                message: "Password must be at least 6 characters long!",
              },
              {
                max: 20,
                message: "Password must be at most 20 characters long!",
              },
              {
                pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\w\W]{6,20}$/,
                message:
                  "Password must contain at least one uppercase letter, one lowercase letter, and one number!",
              },
            ]}
          >
            <Input.Password
              prefix={<FaKey className="text-slate-700 mx-2" />}
              placeholder="New password"
            />
          </Form.Item>

          <Form.Item
            name="confirmPassword"
            label="Confirm Password"
            required
            dependencies={["newPassword"]}
            rules={[
              { required: true, message: "Please confirm your new password" },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue("newPassword") === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(
                    new Error("The two passwords do not match")
                  );
                },
              }),
            ]}
          >
            <Input.Password
              prefix={<FaKey className="text-slate-700 mx-2" />}
              placeholder="Confirm new password"
            />
          </Form.Item>

          <div className="mt-6">
            {isPending ? (
              <div className="w-full flex justify-center items-center">
                <SpinnerSmall />
              </div>
            ) : (
              <button
                type="button"
                onClick={() => form.submit()}
                className="w-full bg-red-700 hover:cursor-pointer font-semibold text-white py-2 px-4 rounded-3xl shadow-sm hover:bg-red-400 focus:outline-none focus:ring-2 focus:ring-gray-500 transition-colors duration-200"
              >
                Change Password
              </button>
            )}
          </div>
        </Form>
      </div>
    </Modal>
  );
}

export default ChangePasswordModel;
