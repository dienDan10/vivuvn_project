using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryMessage
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        [Required]
        public int ItineraryMemberId { get; set; }
        public ItineraryMember ItineraryMember { get; set; } = null!;

        [Required]
        public string Message { get; set; } = string.Empty;

        [Required]
        public DateTime CreatedAt { get; set; }

        public bool DeleteFlag { get; set; } = false;

    }
}
