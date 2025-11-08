using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class ForgotPasswordRequestDto
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
    }
}
