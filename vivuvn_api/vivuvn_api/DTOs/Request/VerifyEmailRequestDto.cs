using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class VerifyEmailRequestDto
    {
        [Required]
        public string Email { get; set; } = null!;
        [Required]
        public string Token { get; set; } = null!;
    }
}
