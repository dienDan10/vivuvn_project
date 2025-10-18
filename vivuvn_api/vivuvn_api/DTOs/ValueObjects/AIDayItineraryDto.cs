using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.ValueObjects
{
    /// <summary>
    /// Itinerary for a single day.
    /// Maps to Python DayItinerary model from AI service.
    /// </summary>
    public class AIDayItineraryDto
    {
        /// <summary>
        /// Day number (1, 2, 3...)
        /// </summary>
        [JsonPropertyName("day")]
        public int Day { get; set; }

        /// <summary>
        /// Date in YYYY-MM-DD format
        /// </summary>
        [JsonPropertyName("date")]
        public DateTime Date { get; set; }

        /// <summary>
        /// List of activities for the day
        /// </summary>
        [JsonPropertyName("activities")]
        public List<AIActivityDto> Activities { get; set; } = new List<AIActivityDto>();

        /// <summary>
        /// Total estimated cost for the day in VND
        /// </summary>
        [JsonPropertyName("estimated_cost")]
        public decimal? EstimatedCost { get; set; }

        /// <summary>
        /// Daily tips and recommendations
        /// </summary>
        [JsonPropertyName("notes")]
        public string Notes { get; set; } = string.Empty;
    }
}
