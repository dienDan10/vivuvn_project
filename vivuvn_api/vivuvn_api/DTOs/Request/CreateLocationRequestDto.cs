using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
	public class CreateLocationRequestDto
	{
		[Required(ErrorMessage = "Name is required")]
		public string Name { get; set; } = string.Empty;

		[Required(ErrorMessage = "Province is required")]
		public int ProvinceId { get; set; }

		public string? Description { get; set; }

		public string? Address { get; set; }

		public string? WebsiteUri { get; set; }

		[Required(ErrorMessage = "At least one image is required")]
		[MinLength(1, ErrorMessage = "At least one image is required")]
		public List<IFormFile> Images { get; set; } = new List<IFormFile>();
	}
}
