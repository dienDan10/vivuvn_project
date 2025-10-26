using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class AddRestaurantToItineraryFromSuggestionDto
    {
        [Required]
        public int RestaurantId { get; set; }
    }
}
