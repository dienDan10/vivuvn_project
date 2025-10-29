using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryNameRequestDto
    {
        [Required]
        public string Name { get; set; }
    }
}
