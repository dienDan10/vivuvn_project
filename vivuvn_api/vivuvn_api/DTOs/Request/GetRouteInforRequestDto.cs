using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class GetRouteInforRequestDto
    {
        [JsonPropertyName("origin")]
        public OriginDestination Origin { get; set; } = null!;

        [JsonPropertyName("destination")]
        public OriginDestination Destination { get; set; } = null!;

        [JsonPropertyName("travelMode")]
        public string TravelMode { get; set; } = "DRIVE";

        [JsonPropertyName("languageCode")]
        public string LanguageCode { get; set; } = "vi";

        [JsonPropertyName("units")]
        public string Units { get; set; } = "METRIC";

    }

    public class OriginDestination
    {
        [JsonPropertyName("placeId")]
        public string? PlaceId { get; set; }
    }
}


