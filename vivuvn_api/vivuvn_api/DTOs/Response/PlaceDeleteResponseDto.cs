using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Response
{
	public class PlaceDeleteResponseDto
	{
		[JsonPropertyName("success")]
		public bool Success { get; set; }

		[JsonPropertyName("message")]
		public string Message { get; set; } = string.Empty;

		[JsonPropertyName("item_id")]
		public string ItemId { get; set; } = string.Empty;
	}
}
