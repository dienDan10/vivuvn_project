using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class AddHotelToItineraryFromSuggestionDto
    {
        [Required]
        public int HotelId { get; set; }
    }
}
