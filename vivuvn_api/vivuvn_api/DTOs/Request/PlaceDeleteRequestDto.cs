using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
	public class PlaceDeleteRequestDto
	{
		[Required]
		[JsonPropertyName("item_id")]
		public string ItemId { get; set; } = string.Empty;
	}
}
