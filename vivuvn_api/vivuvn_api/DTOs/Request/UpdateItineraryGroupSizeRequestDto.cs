using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryGroupSizeRequestDto
    {
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Group size must be at least 1.")]
        public int GroupSize { get; set; }
    }
}
