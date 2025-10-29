using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryGroupSizeRequestDto
    {
        [Required]
        public int GroupSize { get; set; }
    }
}
