using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Location
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;

        public int ProvinceId { get; set; }
        public Province? Province { get; set; }

        public string? Description { get; set; }
        public string? BannerPhoto { get; set; }

        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? Address { get; set; }

        public double? Rating { get; set; }
        public int ReviewCount { get; set; }

        public string? MapPlaceId { get; set; }
        public string? OpenTime { get; set; }
        public string? CloseTime { get; set; }
        public string? WebsiteUri { get; set; }

        public bool DeleteFlag { get; set; }

        // Navigation
        public ICollection<LocationPhoto> LocationPhotos { get; set; } = new List<LocationPhoto>();
    }
}
