namespace vivuvn_api.DTOs.ValueObjects
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string? UserPhoto { get; set; }
        public string? PhoneNumber { get; set; }
        public string? GoogleIdToken { get; set; }
        public List<string> Roles { get; set; } = new List<string>();
    }
}
