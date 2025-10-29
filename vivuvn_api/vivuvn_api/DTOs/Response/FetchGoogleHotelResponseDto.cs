using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class FetchGoogleHotelResponseDto
    {
        [JsonPropertyName("places")]
        public List<Place> Places { get; set; } = new();
    }
}
