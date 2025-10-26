using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class AddRestaurantToItineraryFromSearch
    {
        [Required]
        public int GooglePlaceId { get; set; }

        [Required]
        public DateOnly Date { get; set; }

        [Required]
        public TimeOnly Time { get; set; }
    }
}
