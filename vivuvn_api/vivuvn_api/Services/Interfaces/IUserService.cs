using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IUserService
    {
        Task<UserDto> GetProfileAsync(string email);
        Task<UserDto?> LockUserAccountAsync(int userId);
        Task<UserDto?> UnlockUserAccountAsync(int userId);
    }
}
