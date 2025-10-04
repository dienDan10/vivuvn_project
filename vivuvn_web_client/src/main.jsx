import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.jsx";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import { Provider } from "react-redux";
import store from "./store.js";

const queryClient = new QueryClient({
	defaultOptions: {
		queries: {
			refetchOnWindowFocus: true,
			refetchOnReconnect: true,
			refetchOnMount: true,
			staleTime: 0,
		},
		mutations: {
			retry: false,
		},
	},
});

createRoot(document.getElementById("root")).render(
	<StrictMode>
		<QueryClientProvider client={queryClient}>
			<ReactQueryDevtools
				initialIsOpen={false}
				buttonPosition="bottom-left"
				position="left"
			/>
			<Provider store={store}>
				<App />
			</Provider>
		</QueryClientProvider>
	</StrictMode>
);
