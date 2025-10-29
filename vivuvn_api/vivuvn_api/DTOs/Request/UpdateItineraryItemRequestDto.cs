namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryItemRequestDto
    {
        public string? Note { get; set; }
        public TimeOnly? StartTime { get; set; }
        public TimeOnly? EndTime { get; set; }
    }
}
