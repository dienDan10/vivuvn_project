namespace vivuvn_api.Data
{
    public class ProvinceData
    {
        public string Province { get; set; }
        public string ImageUrl { get; set; }
        public List<LocationData> Places { get; set; }
    }

    public class LocationData
    {
        public string Name { get; set; }
        public string? Description { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? Address { get; set; }
        public double? Rating { get; set; }
        public int? UserRatingCount { get; set; }
        public string? GooglePlaceId { get; set; }
        public string? PlaceUri { get; set; }
        public string? DirectionsUri { get; set; }
        public string? ReviewUri { get; set; }
        public string? WebsiteUri { get; set; }
        public List<string>? Pictures { get; set; }
    }
}
