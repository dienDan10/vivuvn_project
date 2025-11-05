using System.Text;
using System.Text.Json;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

using ValidationException = vivuvn_api.Exceptions.ValidationException;

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

				// Read the response content
				var jsonResponse = await response.Content.ReadAsStringAsync();

				// Handle error responses from AI service
				if (!response.IsSuccessStatusCode)
				{
					await HandleAiServiceErrorAsync(response, jsonResponse);
				}

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

		private async Task HandleAiServiceErrorAsync(HttpResponseMessage response, string jsonResponse)
		{
			try
			{
				// Try to parse AI service error format: { "error": { "message": "...", "status_code": 400, "type": "...", "details": {} } }
				var errorResponse = JsonSerializer.Deserialize<JsonElement>(jsonResponse, _jsonOptions);
				
				if (errorResponse.TryGetProperty("error", out var errorObj))
				{
					var errorMessage = errorObj.TryGetProperty("message", out var msg) 
						? msg.GetString() ?? "Unknown error from AI service"
						: "Unknown error from AI service";
					
					var errorType = errorObj.TryGetProperty("type", out var type) 
						? type.GetString() ?? "AIServiceError"
						: "AIServiceError";

					// Map AI service status codes to appropriate backend exceptions
					var statusCode = (int)response.StatusCode;

					// Handle validation errors (422)
					if (statusCode == 422 && errorObj.TryGetProperty("details", out var detailsArray) && detailsArray.ValueKind == JsonValueKind.Array)
					{
						// Convert AI service validation error format to backend format
						// AI format: [{ "key": "budget", "msg": "Value error, Budget cannot be negative" }]
						// Backend format: { "budget": ["Value error, Budget cannot be negative"] }
						var errors = new Dictionary<string, string[]>();
						
						foreach (var detail in detailsArray.EnumerateArray())
						{
							if (detail.TryGetProperty("key", out var keyProp) && 
							    detail.TryGetProperty("msg", out var msgProp))
							{
								var key = keyProp.GetString() ?? "unknown";
								var message = msgProp.GetString() ?? "Validation error";
								
								if (errors.ContainsKey(key))
								{
									// If key already exists, append the message
									var existingMessages = errors[key].ToList();
									existingMessages.Add(message);
									errors[key] = existingMessages.ToArray();
								}
								else
								{
									errors[key] = new[] { message };
								}
							}
						}
						
						throw new ValidationException(errors);
					}

					throw statusCode switch
					{
						400 => new ArgumentException($"AI Service Error ({errorType}): {errorMessage}"),
						404 => new KeyNotFoundException($"AI Service Error ({errorType}): {errorMessage}"),
						401 or 403 => new UnauthorizedAccessException($"AI Service Error ({errorType}): {errorMessage}"),
						502 or 503 => new InvalidOperationException($"AI Service temporarily unavailable ({errorType}): {errorMessage}"),
						_ => new InvalidOperationException($"AI Service Error ({errorType}): {errorMessage}")
					};
				}
			}
			catch (JsonException)
			{
				// If we can't parse the error, fall back to generic error
			}

			// Fallback: throw generic error with status code
			throw new InvalidOperationException($"AI service returned error: {response.StatusCode} - {response.ReasonPhrase}");
		}
	}
}