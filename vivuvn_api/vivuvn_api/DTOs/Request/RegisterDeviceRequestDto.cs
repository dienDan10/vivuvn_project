using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class RegisterDeviceRequestDto
    {
        [Required]
        [MaxLength(255)]
        public string FcmToken { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string DeviceType { get; set; } = string.Empty; // "web", "ios", "android"

        [MaxLength(100)]
        public string? DeviceName { get; set; }
    }
}
