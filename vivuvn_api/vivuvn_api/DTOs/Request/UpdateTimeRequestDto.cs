using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateTimeRequestDto
    {
        [Required]
        public TimeOnly Time { get; set; }
    }
}
