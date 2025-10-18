using System.Text;
using System.Text.Json;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
	public class AiClientService(HttpClient _httpClient) : IAiClientService
	{
		private readonly JsonSerializerOptions _jsonOptions = new()
		{
			PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
			WriteIndented = false,
			Converters = { new TimeOnlyJsonConverter() }
		};

		public async Task<T> GenerateItineraryAsync<T>(AITravelItineraryGenerateRequest request)
		{
			try
			{
				// Serialize the request to JSON
				var jsonRequest = JsonSerializer.Serialize(request, _jsonOptions);
				var content = new StringContent(jsonRequest, Encoding.UTF8, "application/json");

				// Make HTTP POST request to AI service
				var response = await _httpClient.PostAsync("/api/v1/travel/generate-itinerary", content);

				// Ensure the response is successful
				response.EnsureSuccessStatusCode();

				// Read the response content
				var jsonResponse = await response.Content.ReadAsStringAsync();

				// Deserialize the response to the requested type
				var result = JsonSerializer.Deserialize<T>(jsonResponse, _jsonOptions);

				return result ?? throw new InvalidOperationException("Failed to deserialize AI service response");
			}
			catch (HttpRequestException ex)
			{
				throw new HttpRequestException($"Failed to communicate with AI service: {ex.Message}", ex);
			}
			catch (JsonException ex)
			{
				throw new InvalidOperationException($"Failed to process AI service response: {ex.Message}", ex);
			}
		}
	}
}