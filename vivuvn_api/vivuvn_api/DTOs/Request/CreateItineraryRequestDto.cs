using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class CreateItineraryRequestDto
    {
        [Required]
        public int StartProvinceId { get; set; }
        [Required]
        public int DestinationProvinceId { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;
        [Required]
        public DateTime StartDate { get; set; }
        [Required]
        public DateTime EndDate { get; set; }
    }
}
