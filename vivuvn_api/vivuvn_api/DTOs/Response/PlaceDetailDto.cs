using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class PlaceDetailDto
    {
        [JsonPropertyName("placeId")]
        public string PlaceId { get; set; } = string.Empty;

        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        [JsonPropertyName("formattedAddress")]
        public string? FormattedAddress { get; set; }

        [JsonPropertyName("latitude")]
        public double? Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double? Longitude { get; set; }

        [JsonPropertyName("rating")]
        public double? Rating { get; set; }

        [JsonPropertyName("userRatingCount")]
        public int? UserRatingCount { get; set; }

        [JsonPropertyName("googleMapsUri")]
        public string? GoogleMapsUri { get; set; }

        [JsonPropertyName("directionsUri")]
        public string? DirectionsUri { get; set; }

        [JsonPropertyName("reviewsUri")]
        public string? ReviewsUri { get; set; }
    }
}
