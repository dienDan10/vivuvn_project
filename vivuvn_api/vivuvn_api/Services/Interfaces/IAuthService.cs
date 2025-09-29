using FluentResults;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface IAuthService
    {
        Task<Result<User>> RegisterAsync(RegisterRequestDto request);
        Task<Result<TokenResponseDto>> LoginAsync(LoginRequestDto request);
        Task<Result<TokenResponseDto>> RefreshTokenAsync(RefreshTokenRequestDto request);
    }
}
