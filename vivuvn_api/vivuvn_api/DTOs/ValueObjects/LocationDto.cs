namespace vivuvn_api.DTOs.ValueObjects
{
    public class LocationDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;

        public string ProvinceName { get; set; } = string.Empty;

        public string? Description { get; set; }

        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? Address { get; set; }

        public double? Rating { get; set; }
        public int? RatingCount { get; set; }

        public string? GooglePlaceId { get; set; }
        public string? PlaceUri { get; set; }
        public string? DirectionsUri { get; set; }
        public string? ReviewUri { get; set; }
        public string? WebsiteUri { get; set; }

        // Navigation
        public ICollection<string> Photos { get; set; } = new List<string>();
    }
}
