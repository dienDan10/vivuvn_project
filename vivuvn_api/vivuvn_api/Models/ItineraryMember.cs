using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryMember
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        [Required]
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        [Required]
        public DateTime JoinedAt { get; set; }

        [Required]
        [MaxLength(20)]
        public string Role { get; set; } = "Member";

        public bool DeleteFlag { get; set; } = false;
    }
}
