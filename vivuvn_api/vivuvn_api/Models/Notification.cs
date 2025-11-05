using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Notification
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        public int? ItineraryId { get; set; }
        public Itinerary? Itinerary { get; set; }

        [Required]
        [MaxLength(50)]
        public string Type { get; set; } = string.Empty;

        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        [Required]
        public string Message { get; set; } = string.Empty;

        public bool IsRead { get; set; } = false;

        [Required]
        public DateTime CreatedAt { get; set; }

        public bool DeleteFlag { get; set; } = false;
    }
}
