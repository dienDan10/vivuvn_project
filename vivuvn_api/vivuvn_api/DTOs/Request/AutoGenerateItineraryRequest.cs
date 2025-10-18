using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
	public class AutoGenerateItineraryRequest
	{
		public List<string> Preferences { get; set; } = new List<string>();

		[Range(1, 10)]
		public int GroupSize { get; set; } = 1;

		[Required]
		public long? Budget { get; set; }

		public string? SpecialRequirements { get; set; }
	}
}
