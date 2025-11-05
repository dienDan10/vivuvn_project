using System.Text.Json.Serialization;
using vivuvn_api.Helpers;

namespace vivuvn_api.DTOs.Request
{
    public class ComputeRouteRequestDto
    {
        [JsonPropertyName("origin")]
        public OriginDestination Origin { get; set; } = null!;

        [JsonPropertyName("destination")]
        public OriginDestination Destination { get; set; } = null!;

        [JsonPropertyName("travelMode")]
        public string TravelMode { get; set; } = Constants.TravelMode_Driving;

        //[JsonPropertyName("routingPreference")]
        //public string RoutingPreference { get; set; } = "TRAFFIC_AWARE";

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

    public class RouteModifiers
    {
        [JsonPropertyName("avoidTolls")]
        public bool AvoidTolls { get; set; } = false;

        [JsonPropertyName("avoidHighways")]
        public bool AvoidHighways { get; set; } = false;

        [JsonPropertyName("avoidFerries")]
        public bool AvoidFerries { get; set; } = false;
    }
}


