using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
	public class CreateOperatorRequestDto
	{
		[Required, EmailAddress]
		public string Email { get; set; } = string.Empty;

		[Required, MaxLength(50)]
		public string Username { get; set; } = string.Empty;

		[Required, MinLength(6)]
		public string Password { get; set; } = string.Empty;

		[Phone]
		public string? PhoneNumber { get; set; }
	}
}
