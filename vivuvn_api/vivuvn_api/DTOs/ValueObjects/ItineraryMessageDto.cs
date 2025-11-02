namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryMessageDto
    {
        public int Id { get; set; }
        public ItineraryMemberDto Sender { get; set; } = null!;
        public string Message { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
