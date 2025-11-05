using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class AddHotelToItineraryFromSearch
    {
        [Required]
        public string GooglePlaceId { get; set; } = string.Empty;

        [Required]
        public DateOnly CheckIn { get; set; }

        [Required]
        public DateOnly CheckOut { get; set; }
    }
}
