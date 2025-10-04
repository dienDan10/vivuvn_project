import { Form, Input } from "antd";
import { FaCircleUser, FaKey } from "react-icons/fa6";
import { IoIosMail } from "react-icons/io";
import { useNavigate } from "react-router-dom";
import { useLogin } from "./useLogin";
import { SpinnerSmall } from "../../components/Spinner";
import { useDispatch } from "react-redux";
import { doLoginAction } from "../../redux/userSlice";

function LoginForm() {
	const [form] = Form.useForm();
	const navigate = useNavigate();
	const dispatch = useDispatch();
	const { isPending, login } = useLogin();

	const onSubmit = ({ email, password }) => {
		login(
			{ email, password },
			{
				onSuccess: () => {
					dispatch(doLoginAction());
				},
			}
		);
	};

	return (
		<>
			<div className="w-full h-[calc(100vh-4rem)] flex items-center justify-center px-2 md:px-0">
				<div className="bg-white px-3 py-5 sm:px-10 sm:py-8 rounded-md max-w-[600px] w-full">
					<div className="text-center mb-6 flex flex-col items-center">
						<FaCircleUser className="text-6xl text-blue-700 mb-2" />
						<h1 className="text-2xl font-semibold text-gray-800">Sign In</h1>
						<p className="text-gray-500">
							Welcome back! Please sign in to your account.
						</p>
					</div>
					<Form form={form} onFinish={onSubmit}>
						<Form.Item
							name="email"
							required
							rules={[
								{ required: true, message: "Please input your email!" },
								{ type: "email", message: "Please enter a valid email!" },
							]}
						>
							<Input
								prefix={<IoIosMail className="text-slate-700 text-xl mx-2" />}
								placeholder="Email"
							/>
						</Form.Item>

						<Form.Item
							name="password"
							required
							rules={[
								{ required: true, message: "Please input your password!" },
							]}
						>
							<Input.Password
								prefix={<FaKey className="text-slate-700 mx-2" />}
								placeholder="Password"
							/>
						</Form.Item>
						{isPending ? (
							<div className="w-full flex justify-center items-center">
								<SpinnerSmall />
							</div>
						) : (
							<button
								type="button"
								onClick={() => form.submit()}
								className="w-full bg-blue-700 hover:cursor-pointer font-semibold text-white py-2 px-4 rounded-3xl shadow-sm hover:bg-blue-400 focus:outline-none focus:ring-2 focus:ring-gray-500 transition-colors duration-200"
							>
								Sign In
							</button>
						)}
					</Form>
				</div>
			</div>
		</>
	);
}

export default LoginForm;
