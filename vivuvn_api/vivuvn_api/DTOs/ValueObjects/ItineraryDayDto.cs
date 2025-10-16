namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryDayDto
    {
        public int Id { get; set; }
        public int DayNumber { get; set; }
        public DateTime Date { get; set; }

        public ICollection<ItineraryItemDto> Items { get; set; } = new List<ItineraryItemDto>();
    }
}
