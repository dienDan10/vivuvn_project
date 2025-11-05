using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Itinerary
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        [Required]
        public string Name { get; set; } = string.Empty;

        [Required]
        public int StartProvinceId { get; set; }
        public Province StartProvince { get; set; } = null!;

        [Required]
        public int DestinationProvinceId { get; set; }
        public Province DestinationProvince { get; set; } = null!;

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int DaysCount { get; set; }
        public int GroupSize { get; set; }

        public bool DeleteFlag { get; set; }

        public string? TransportationVehicle { get; set; }

        public bool IsPublic { get; set; } = false;

        [MaxLength(50)]
        public string? InviteCode { get; set; }
        public DateTime? InviteCodeGeneratedAt { get; set; }

        // Navigation
        public ICollection<ItineraryDay> Days { get; set; } = new List<ItineraryDay>();
        public Budget? Budget { get; set; }
        public ICollection<FavoritePlace> FavoritePlaces { get; set; } = new List<FavoritePlace>();
        public ICollection<ItineraryHotel> Hotels { get; set; } = new List<ItineraryHotel>();
        public ICollection<ItineraryRestaurant> Restaurants { get; set; } = new List<ItineraryRestaurant>();
        public ICollection<ItineraryMember> Members { get; set; } = new List<ItineraryMember>();
        public ICollection<ItineraryMessage> Messages { get; set; } = new List<ItineraryMessage>();
        public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    }
}
