using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Restaurant
    {
        [Key]
        public int Id { get; set; }
        public string? GooglePlaceId { get; set; } = string.Empty;
        public string? Name { get; set; } = string.Empty;
        public string? Address { get; set; } = string.Empty;
        public double? Rating { get; set; }
        public int? UserRatingCount { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? GoogleMapsUri { get; set; }
        public string? PriceLevel { get; set; }
        public bool DeleteFlag { get; set; }

        // Navigation
        public ICollection<Location> NearbyLocations { get; set; } = new List<Location>();
        public ICollection<Photo> Photos { get; set; } = new List<Photo>();
    }
}
