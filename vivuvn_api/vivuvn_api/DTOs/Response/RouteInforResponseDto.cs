using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class RouteInforResponseDto
    {
        [JsonPropertyName("routes")]
        public List<Route> Routes { get; set; } = new();
    }

    public class Route
    {
        [JsonPropertyName("duration")]
        public string Duration { get; set; } = string.Empty;

        [JsonPropertyName("distanceMeters")]
        public int DistanceMeters { get; set; }

    }

}
