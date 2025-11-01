using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class JoinItineraryRequestDto
    {
        [Required]
        public string InviteCode { get; set; } = null!;
    }
}
