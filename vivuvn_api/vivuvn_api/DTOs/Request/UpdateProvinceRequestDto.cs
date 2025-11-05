using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
	public class UpdateProvinceRequestDto
	{
		[Required]
		public string? Name { get; set; }
		public string? ProvinceCode { get; set; }
		public IFormFile? Image { get; set; }
	}
}
