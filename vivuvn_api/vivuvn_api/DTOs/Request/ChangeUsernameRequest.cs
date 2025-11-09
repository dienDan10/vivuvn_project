using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class ChangeUsernameRequest
    {
        [Required]
        public string Username { get; set; } = string.Empty;
    }
}
