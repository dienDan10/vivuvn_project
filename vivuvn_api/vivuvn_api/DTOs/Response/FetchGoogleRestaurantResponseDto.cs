using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class FetchGoogleRestaurantResponseDto
    {
        [JsonPropertyName("places")]
        public List<Place> Places { get; set; } = new();
    }

    public class Place
    {
        [JsonPropertyName("id")]
        public string Id { get; set; } = string.Empty;

        [JsonPropertyName("displayName")]
        public DisplayName? DisplayName { get; set; }

        [JsonPropertyName("formattedAddress")]
        public string? FormattedAddress { get; set; }

        [JsonPropertyName("rating")]
        public double? Rating { get; set; }

        [JsonPropertyName("userRatingCount")]
        public int? UserRatingCount { get; set; }

        [JsonPropertyName("location")]
        public PlaceLocation? Location { get; set; }

        [JsonPropertyName("googleMapsUri")]
        public string? GoogleMapsUri { get; set; }

        [JsonPropertyName("priceLevel")]
        public string? PriceLevel { get; set; }

        [JsonPropertyName("photos")]
        public List<Photo>? Photos { get; set; }
    }

    public class DisplayName
    {
        [JsonPropertyName("text")]
        public string Text { get; set; } = string.Empty;

        [JsonPropertyName("languageCode")]
        public string? LanguageCode { get; set; }
    }

    public class PlaceLocation
    {
        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }
    }

    public class Photo
    {
        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        [JsonPropertyName("widthPx")]
        public int? WidthPx { get; set; }

        [JsonPropertyName("heightPx")]
        public int? HeightPx { get; set; }

        [JsonPropertyName("authorAttributions")]
        public List<AuthorAttribution>? AuthorAttributions { get; set; }
    }

    public class AuthorAttribution
    {
        [JsonPropertyName("displayName")]
        public string? DisplayName { get; set; }

        [JsonPropertyName("uri")]
        public string? Uri { get; set; }

        [JsonPropertyName("photoUri")]
        public string? PhotoUri { get; set; }
    }
}
