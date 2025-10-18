using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.ValueObjects
{
    /// <summary>
    /// Individual activity within a day's itinerary.
    /// Maps to Python Activity model from AI service.
    /// </summary>
    public class AIActivityDto
    {
        /// <summary>
        /// Start time in HH:MM format (e.g., 09:00)
        /// </summary>
        [JsonPropertyName("time")]
        public TimeOnly Time { get; set; }

        /// <summary>
        /// Activity name - matches database place name
        /// </summary>
        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        /// <summary>
        /// Google Place ID from database (required foreign key)
        /// </summary>
        [JsonPropertyName("place_id")]
        public string PlaceId { get; set; } = string.Empty;

        /// <summary>
        /// Duration in hours (e.g., 2.0, 0.5, 1.5)
        /// Minimum 0.5h, maximum 8.0h
        /// </summary>
        [JsonPropertyName("duration_hours")]
        public double DurationHours { get; set; }

        /// <summary>
        /// Estimated cost in VND (0 for free activities)
        /// </summary>
        [JsonPropertyName("cost_estimate")]
        public decimal CostEstimate { get; set; }

        /// <summary>
        /// Activity category: food, sightseeing, culture, history, nature,
        /// adventure, shopping, entertainment, relaxation
        /// </summary>
        [JsonPropertyName("category")]
        public string Category { get; set; } = string.Empty;
    }
}
