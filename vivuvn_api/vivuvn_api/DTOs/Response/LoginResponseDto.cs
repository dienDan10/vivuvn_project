using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.DTOs.Response
{
    public class LoginResponseDto
    {
        public required string AccessToken { get; set; }
        public required string RefreshToken { get; set; }
        public UserDto User { get; set; }
    }
}
