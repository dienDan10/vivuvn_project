using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateNoteRequestDto
    {
        [Required]
        public string Notes { get; set; } = string.Empty;
    }
}
