using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
	public class CreateProvinceRequestDto
	{
		[Required]
		public string Name { get; set; } = string.Empty;
		public string ProvinceCode { get; set; } = string.Empty;
		public IFormFile Image { get; set; } = null!;
	}
}
