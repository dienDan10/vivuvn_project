namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryRestaurantDto
    {
        public int Id { get; set; }
        public int? RestaurantId { get; set; }
        public RestaurantDto? Restaurant { get; set; }

        public decimal? Cost { get; set; }

        public DateOnly Date { get; set; }
        public TimeOnly Time { get; set; }

        public string? Notes { get; set; }
    }
}
