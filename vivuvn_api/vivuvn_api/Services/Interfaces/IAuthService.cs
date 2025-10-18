using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;

namespace vivuvn_api.Services.Interfaces
{
    public interface IAuthService
    {
        Task RegisterAsync(RegisterRequestDto request);
        Task<TokenResponseDto> LoginAsync(LoginRequestDto request);
        Task<TokenResponseDto> GoogleLoginAsync(GoogleLoginRequestDto request);
        Task VerifyEmailAsync(VerifyEmailRequestDto request);
        Task ResendEmailVerificationAsync(ResendEmailVerificationRequestDto request);
        Task<TokenResponseDto> RefreshTokenAsync(RefreshTokenRequestDto request);
    }
}
