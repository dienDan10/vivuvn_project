using System.Text.Json.Serialization;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.DTOs.Response
{
	public class AutoGenerateItineraryResponse
	{
		/// <summary>
		/// Whether the itinerary generation was successful
		/// </summary>
		[JsonPropertyName("success")]
		public bool Success { get; set; }

		/// <summary>
		/// Response message
		/// </summary>
		[JsonPropertyName("message")]
		public string Message { get; set; } = string.Empty;

		/// <summary>
		/// Generated travel itinerary
		/// </summary>
		[JsonPropertyName("itinerary")]
		public TravelItinerary? Itinerary { get; set; }
	}
}
