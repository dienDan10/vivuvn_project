using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
	public class AITravelItineraryGenerateRequest
	{

		[JsonPropertyName("origin")]
		public string? Origin { get; set; }

		[Required]
		[StringLength(100, MinimumLength = 2)]
		[JsonPropertyName("destination")]
		public string Destination { get; set; } = string.Empty;

		[Required]
		[JsonPropertyName("start_date")]
		public DateTime StartDate { get; set; }

		[Required]
		[JsonPropertyName("end_date")]
		public DateTime EndDate { get; set; }

		[JsonPropertyName("preferences")]
		public List<string> Preferences { get; set; } = new List<string>();

		[Range(1, 10)]
		[JsonPropertyName("group_size")]
		public int GroupSize { get; set; } = 1;

		[Required]
		[JsonPropertyName("budget")]
		public long? Budget { get; set; }

		[JsonPropertyName("special_requirements")]
		public string? SpecialRequirements { get; set; }
	}
}
