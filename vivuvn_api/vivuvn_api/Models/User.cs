using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required, MaxLength(50)]
        public string Username { get; set; } = string.Empty;

        [Required]
        public string PasswordHash { get; set; } = string.Empty;

        public string? UserPhoto { get; set; }
        public string? PhoneNumber { get; set; }

        public string? RefreshToken { get; set; }
        public DateTime? RefreshTokenExpireDate { get; set; }

        public string? GoogleIdToken { get; set; }

        public bool IsEmailVerified { get; set; }
        public string? EmailVerificationToken { get; set; }
        public DateTime? EmailVerificationTokenExpireDate { get; set; }

        public DateTime? LockoutEnd { get; set; }

        public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
        public ICollection<Itinerary> Itineraries { get; set; } = new List<Itinerary>();

        public ICollection<ItineraryMember> ItineraryMemberships { get; set; } = new List<ItineraryMember>(); // Itineraries user is a member of
        public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    }
}
