using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class SendMessageRequestDto
    {
        [Required(ErrorMessage = "Message is required")]
        [StringLength(2000, ErrorMessage = "Message cannot exceed 2000 characters")]
        public string Message { get; set; } = string.Empty;
    }
}
