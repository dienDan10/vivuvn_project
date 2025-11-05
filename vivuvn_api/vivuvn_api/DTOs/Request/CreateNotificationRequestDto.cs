using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class CreateNotificationRequestDto
    {
        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [MaxLength(2000)]
        public string Message { get; set; } = string.Empty;

        public bool SendEmail { get; set; } = false; // Optional: also send email notification
    }
}
