using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.DTOs.Response
{
    public class MessagePageResponseDto
    {
        public List<ItineraryMessageDto> Messages { get; set; } = new();
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
        public int TotalMessages { get; set; }
        public bool HasNextPage { get; set; }
        public bool HasPreviousPage { get; set; }
    }
}
