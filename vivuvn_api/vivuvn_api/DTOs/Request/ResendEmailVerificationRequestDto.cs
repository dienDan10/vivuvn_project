using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class ResendEmailVerificationRequestDto
    {
        [Required]
        public string Email { get; set; } = null!;
    }
}
