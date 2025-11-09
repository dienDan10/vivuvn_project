using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
	public class PlaceUpsertRequestDto
	{
		[Required]
		[StringLength(200, MinimumLength = 1)]
		[JsonPropertyName("name")]
		public string Name { get; set; } = string.Empty;

		[Required]
		[JsonPropertyName("googlePlaceId")]
		public string GooglePlaceId { get; set; } = string.Empty;

		[Required]
		[StringLength(int.MaxValue, MinimumLength = 10)]
		[JsonPropertyName("description")]
		public string Description { get; set; } = string.Empty;

		[Required]
		[StringLength(int.MaxValue, MinimumLength = 5)]
		[JsonPropertyName("address")]
		public string Address { get; set; } = string.Empty;

		[Required]
		[Range(-90.0, 90.0)]
		[JsonPropertyName("latitude")]
		public double Latitude { get; set; }

		[Required]
		[Range(-180.0, 180.0)]
		[JsonPropertyName("longitude")]
		public double Longitude { get; set; }

		[Required]
		[Range(0.0, 5.0)]
		[JsonPropertyName("rating")]
		public double Rating { get; set; }

		[Required]
		[StringLength(100, MinimumLength = 1)]
		[JsonPropertyName("province")]
		public string Province { get; set; } = string.Empty;
	}
}
