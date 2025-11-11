namespace vivuvn_api.DTOs.Request
{
    public class GetAnalyticsRequestDto
    {
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Limit { get; set; }
        public string? GroupBy { get; set; } // "day", "week", "month"
    }
}
