using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.ValueObjects
{
    public class TravelItinerary
    {
        [JsonPropertyName("days")]
        public List<AIDayItineraryDto> Days { get; set; } = new List<AIDayItineraryDto>();

        [JsonPropertyName("transportation_suggestions")]
        public List<AITransportationSuggestionDto> TransportationSuggestions { get; set; } = new List<AITransportationSuggestionDto>();

        [JsonPropertyName("total_cost")]
        public decimal TotalCost { get; set; }

        [JsonPropertyName("schedule_unavailable")]
        public bool ScheduleUnavailable { get; set; }

        [JsonPropertyName("warnings")]
        public string UnavailableReason { get; set; } = string.Empty;
    }

    public class AITransportationSuggestionDto
    {
        [JsonPropertyName("mode")]
        public string Mode { get; set; } = string.Empty;

        [JsonPropertyName("estimated_cost")]
        public decimal EstimatedCost { get; set; }

        [JsonPropertyName("date")]
        public DateTime Date { get; set; }

        [JsonPropertyName("details")]
        public string Details { get; set; } = string.Empty;
    }

    public class AIDayItineraryDto
    {
        [JsonPropertyName("day")]
        public int Day { get; set; }

        [JsonPropertyName("date")]
        public DateTime Date { get; set; }

        [JsonPropertyName("activities")]
        public List<AIActivityDto> Activities { get; set; } = new List<AIActivityDto>();

        [JsonPropertyName("notes")]
        public string Notes { get; set; } = string.Empty;
    }

    public class AIActivityDto
    {
        [JsonPropertyName("time")]
        public TimeOnly Time { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        [JsonPropertyName("place_id")]
        public string PlaceId { get; set; } = string.Empty;

        [JsonPropertyName("duration_hours")]
        public double DurationHours { get; set; }

        [JsonPropertyName("cost_estimate")]
        public decimal CostEstimate { get; set; }

        [JsonPropertyName("notes")]
        public string Notes { get; set; } = string.Empty;
    }
}
