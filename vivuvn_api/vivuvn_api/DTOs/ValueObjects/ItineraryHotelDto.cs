namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryHotelDto
    {
        public int Id { get; set; }
        public int? HotelId { get; set; }
        public HotelDto? Hotel { get; set; }

        public decimal? Cost { get; set; } = 0;

        public DateOnly CheckIn { get; set; }
        public DateOnly CheckOut { get; set; }

        public string? Notes { get; set; }
    }
}
