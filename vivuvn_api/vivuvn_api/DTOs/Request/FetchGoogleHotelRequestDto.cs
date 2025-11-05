using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class FetchGoogleHotelRequestDto
    {
        [JsonPropertyName("includedTypes")]
        public List<string> IncludedTypes { get; set; } = new() { "lodging", "hotel", "resort_hotel", "motel", "guest_house", "hostel" };

        [JsonPropertyName("maxResultCount")]
        public int MaxResultCount { get; set; } = 20;

        [JsonPropertyName("locationRestriction")]
        public LocationRestriction LocationRestriction { get; set; } = new();

        [JsonPropertyName("languageCode")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? LanguageCode { get; set; } = "vi";
    }
}
