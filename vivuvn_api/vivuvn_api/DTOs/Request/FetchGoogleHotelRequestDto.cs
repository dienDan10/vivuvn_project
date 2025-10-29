using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class FetchGoogleHotelRequestDto
    {
        [JsonPropertyName("includedTypes")]
        public List<string> IncludedTypes { get; set; } = new() { "restaurant" };

        [JsonPropertyName("maxResultCount")]
        public int MaxResultCount { get; set; } = 15;

        [JsonPropertyName("locationRestriction")]
        public LocationRestriction LocationRestriction { get; set; } = new();

        [JsonPropertyName("languageCode")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? LanguageCode { get; set; } = "vi";
    }
}
