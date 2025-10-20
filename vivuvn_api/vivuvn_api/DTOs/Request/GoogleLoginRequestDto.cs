using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class GoogleLoginRequestDto
    {
        [Required]
        public string IdToken { get; set; } = null!;
    }
}
