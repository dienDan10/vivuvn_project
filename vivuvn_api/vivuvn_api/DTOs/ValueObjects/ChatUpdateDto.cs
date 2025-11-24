namespace vivuvn_api.DTOs.ValueObjects
{
    public class ChatUpdateDto
    {
        public List<ItineraryMessageDto> NewMessages { get; set; }
        public List<int> DeletedMessageIds { get; set; }
    }
}
