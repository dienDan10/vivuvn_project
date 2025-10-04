using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IUserService
    {
        Task<UserDto> GetProfileAsync(string email);
    }
}
