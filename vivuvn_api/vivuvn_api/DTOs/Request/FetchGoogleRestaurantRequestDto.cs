using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class FetchGoogleRestaurantRequestDto
    {
        [JsonPropertyName("includedTypes")]
        public List<string> IncludedTypes { get; set; } = new() { "restaurant", "cafe", "bar", "bakery", "meal_delivery", "meal_takeaway" };

        [JsonPropertyName("maxResultCount")]
        public int MaxResultCount { get; set; } = 20;

        [JsonPropertyName("locationRestriction")]
        public LocationRestriction LocationRestriction { get; set; } = new();

        [JsonPropertyName("languageCode")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? LanguageCode { get; set; } = "vi";
    }

    public class LocationRestriction
    {
        [JsonPropertyName("circle")]
        public Circle Circle { get; set; } = new();
    }

    public class Circle
    {
        [JsonPropertyName("center")]
        public LatLng Center { get; set; } = new();

        [JsonPropertyName("radius")]
        public double Radius { get; set; } = 10000.0; // Default 10km radius
    }

    public class LatLng
    {
        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }
    }
}
