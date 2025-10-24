namespace vivuvn_api.Data.DbInitializer
{
    public class RestaurantData
    {
        public string LocationGooglePlaceId { get; set; }
        public List<RestaurantDataItem> Restaurants { get; set; }
    }

    public class RestaurantDataItem
    {
        public string GooglePlaceId { get; set; }
        public string? Name { get; set; }
        public string? Address { get; set; }
        public double? Rating { get; set; }
        public int? UserRatingCount { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? GoogleMapsUri { get; set; }
        public string? PriceLevel { get; set; }
        public List<string>? Photos { get; set; }
    }
}
