using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Photo
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string PhotoUrl { get; set; } = string.Empty;

        public bool DeleteFlag { get; set; }

    }
}
