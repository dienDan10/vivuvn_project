using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class AddFavoritePlaceRequestDto
    {
        [Required]
        public int LocationId { get; set; }
    }
}
