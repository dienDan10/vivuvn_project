using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
	public class UpdateLocationRequestDto
	{
		[Required(ErrorMessage = "Name is required")]
		public string Name { get; set; } = string.Empty;

		public int? ProvinceId { get; set; }

		public string? Description { get; set; }

		public string? Address { get; set; }

		public string? WebsiteUri { get; set; }

		// Optional - for manual entry
		public double? Latitude { get; set; }

		public double? Longitude { get; set; }

		public string? GooglePlaceId { get; set; }

		public string? PlaceUri { get; set; }

		public string? DirectionsUri { get; set; }

		public string? ReviewUri { get; set; }

		// Multiple images support - optional for update (keep existing if not provided)
		public List<IFormFile>? Images { get; set; }
	}
}
