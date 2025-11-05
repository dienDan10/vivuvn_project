namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryMessageDto
    {
        public int Id { get; set; }
        public int MemberId { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string? Photo { get; set; }
        public string Message { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public bool IsOwnMessage { get; set; } = false;
    }
}
