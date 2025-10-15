using System.Text;
using System.Text.Json;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class GoogleMapRouteService(HttpClient _httpClient, IConfiguration _configuration) : IGoogleMapRouteService
    {
        public async Task<RouteInforResponseDto?> GetRouteInformationAsync(GetRouteInforRequestDto request)
        {
            string apiKey = _configuration.GetValue<string>("GoogleMapService:ApiKey") ?? "";
            var jsonBody = JsonSerializer.Serialize(request);
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Add("X-Goog-Api_Key", apiKey);
            try
            {
                var response = await _httpClient.PostAsync("", content: content);

                response.EnsureSuccessStatusCode();

                var responseContent = await response.Content.ReadFromJsonAsync<RouteInforResponseDto>();

                return responseContent;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
