using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class LocationPhoto
    {
        [Key]
        public int Id { get; set; }

        public int LocationId { get; set; }
        public Location Location { get; set; } = null!;

        [Required]
        public string PhotoUrl { get; set; } = string.Empty;
    }
}
