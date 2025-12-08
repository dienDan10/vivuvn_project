namespace vivuvn_api.DTOs.ValueObjects
{
    public class SearchItineraryDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string StartProvinceName { get; set; } = string.Empty;
        public string DestinationProvinceName { get; set; } = string.Empty;
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string? ImageUrl { get; set; }
    }
}
