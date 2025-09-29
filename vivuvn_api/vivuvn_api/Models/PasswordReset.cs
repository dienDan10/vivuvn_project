using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class PasswordReset
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public string PasswordResetToken { get; set; } = string.Empty;

        public DateTime ExpireDate { get; set; }

        // Navigation
        public User User { get; set; } = null!;
    }
}
