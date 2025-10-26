using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class FetchGooglePlaceSimplifiedResponseDto
    {
        [JsonPropertyName("places")]
        public List<SimplifiedPlace> Places { get; set; } = new();
    }

    public class SimplifiedPlace
    {
        [JsonPropertyName("id")]
        public string GooglePlaceId { get; set; } = string.Empty;

        [JsonPropertyName("displayName")]
        public DisplayName? DisplayName { get; set; }

        [JsonPropertyName("formattedAddress")]
        public string? FormattedAddress { get; set; }
    }
}
