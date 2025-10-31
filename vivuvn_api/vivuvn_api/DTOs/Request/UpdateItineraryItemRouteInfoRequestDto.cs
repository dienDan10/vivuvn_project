using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryItemRouteInfoRequestDto
    {
        [Required]
        public string TravelMode { get; set; }
    }
}
