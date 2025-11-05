namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryMemberDto
    {
        public int MemberId { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string? Photo { get; set; }
        public string? PhoneNumber { get; set; }
        public DateTime JoinedAt { get; set; }
        public string Role { get; set; } = "Member";
    }
}
