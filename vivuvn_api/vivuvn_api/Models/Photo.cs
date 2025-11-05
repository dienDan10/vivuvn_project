using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Photo
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string PhotoUrl { get; set; } = string.Empty;

        public int? RestaurantId { get; set; }
        public Restaurant? Restaurant { get; set; }

        public int? LocationId { get; set; }
        public Location? Location { get; set; }

        public int? HotelId { get; set; }
        public Hotel? Hotel { get; set; }

    }
}
