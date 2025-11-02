using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateDateRequestDto
    {
        [Required]
        public DateOnly Date { get; set; }
    }
}
