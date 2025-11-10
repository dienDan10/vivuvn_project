using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class ChangeAvatarRequest
    {
        [Required]
        public IFormFile Avatar { get; set; } = null!;
    }
}
