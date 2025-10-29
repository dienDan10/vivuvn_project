using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.ValueObjects
{
    /// <summary>
    /// Transportation suggestion for inter-city travel.
    /// Used for long-distance travel between cities/provinces.
    /// Maps to Python TransportationSuggestion model from AI service.
    /// </summary>
    public class AITransportationSuggestionDto
    {
        /// <summary>
        /// Mode of transportation: máy bay, xe khách, tàu hỏa, ô tô cá nhân
        /// </summary>
        [JsonPropertyName("mode")]
        public string Mode { get; set; } = string.Empty;

        /// <summary>
        /// Estimated cost in VND (total for group if applicable)
        /// </summary>
        [JsonPropertyName("estimated_cost")]
        public decimal EstimatedCost { get; set; }

        /// <summary>
        /// Date of travel
        /// </summary>
        [JsonPropertyName("date")]
        public DateTime Date { get; set; }

        /// <summary>
        /// Route and additional details (e.g., 'Hà Nội → Đà Nẵng, chuyến sáng 07:00-08:30')
        /// </summary>
        [JsonPropertyName("details")]
        public string Details { get; set; } = string.Empty;
    }
}
