using System.Text;
using System.Text.Json;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class GoogleMapRouteService(HttpClient _httpClient, IConfiguration _configuration) : IGoogleMapRouteService
    {
        public async Task<GetRouteInfoResponseDto?> GetRouteInformationAsync(ComputeRouteRequestDto request)
        {
            string apiKey = _configuration.GetValue<string>("GoogleMapService:ApiKey") ?? "";
            var jsonBody = JsonSerializer.Serialize(request);
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            try
            {
                var requestMessage = new HttpRequestMessage(HttpMethod.Post, "./directions/v2:computeRoutes")
                {
                    Content = content
                };

                requestMessage.Headers.Add("X-Goog-Api-Key", apiKey);
                requestMessage.Headers.Add("X-Goog-FieldMask", "routes.duration,routes.distanceMeters");

                var response = await _httpClient.SendAsync(requestMessage);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine("=== Route Request Failed ===");
                    Console.WriteLine($"Status Code : {(int)response.StatusCode} ({response.StatusCode})");
                    Console.WriteLine($"Reason      : {response.ReasonPhrase}");
                    Console.WriteLine($"Request URL : {requestMessage.RequestUri}");
                    Console.WriteLine($"Error Body  : {errorContent}");
                    Console.WriteLine("=============================");
                }

                response.EnsureSuccessStatusCode();

                var responseContent = await response.Content.ReadFromJsonAsync<GetRouteInfoResponseDto>();

                return responseContent;
            }
            catch (Exception e)
            {
                return null;
            }
        }
    }
}
