using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.ValueObjects
{
	public class TravelItinerary
	{
		/// <summary>
		/// List of daily itineraries
		/// </summary>
		[JsonPropertyName("days")]
		public List<AIDayItineraryDto> Days { get; set; } = new List<AIDayItineraryDto>();

		/// <summary>
		/// Transportation suggestions from origin to destination and vice versa
		/// </summary>
		[JsonPropertyName("transportation_suggestions")]
		public List<AITransportationSuggestionDto> TransportationSuggestions { get; set; } = new List<AITransportationSuggestionDto>();

		/// <summary>
		/// Total trip cost in VND
		/// </summary>
		[JsonPropertyName("total_cost")]
		public decimal TotalCost { get; set; }

		/// <summary>
		/// True if itinerary could not be fully scheduled due to constraints
		/// </summary>
		[JsonPropertyName("schedule_unavailable")]
		public bool ScheduleUnavailable { get; set; }

		/// <summary>
		/// Reason why itinerary could not be fully scheduled, if applicable
		/// </summary>
		[JsonPropertyName("unavailable_reason")]
		public string UnavailableReason { get; set; } = string.Empty;
	}
}
