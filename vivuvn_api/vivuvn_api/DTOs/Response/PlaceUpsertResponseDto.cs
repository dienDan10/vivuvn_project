using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
	public class PlaceUpsertResponseDto
	{
		[JsonPropertyName("success")]
		public bool Success { get; set; }

		[JsonPropertyName("message")]
		public string Message { get; set; } = string.Empty;

		[JsonPropertyName("place_id")]
		public string PlaceId { get; set; } = string.Empty;
	}
}
