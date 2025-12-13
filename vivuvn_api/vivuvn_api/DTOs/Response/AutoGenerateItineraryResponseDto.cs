namespace vivuvn_api.DTOs.Response
{
    public class AutoGenerateItineraryResponseDto
    {
        public string Status { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public int ItineraryId { get; set; }
        public string[] Warnings { get; set; } = [];
    }
}
