using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class UserDevice
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        public string FcmToken { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string DeviceType { get; set; } = string.Empty; // "web", "ios", "android"

        [MaxLength(100)]
        public string? DeviceName { get; set; } // "Chrome Browser", "iPhone 13"

        [Required]
        public DateTime CreatedAt { get; set; }

        [Required]
        public DateTime LastUsedAt { get; set; }

        public bool IsActive { get; set; } = true;
    }
}
