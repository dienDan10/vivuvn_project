using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
    public class GetRouteInfoResponseDto
    {
        [JsonPropertyName("routes")]
        public List<RouteInfo> Routes { get; set; } = new();
    }

    public class RouteInfo
    {
        [JsonPropertyName("distanceMeters")]
        public int DistanceMeters { get; set; }

        [JsonPropertyName("duration")]
        public string Duration { get; set; } = string.Empty;
    }
}
