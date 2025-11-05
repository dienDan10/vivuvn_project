using vivuvn_api.DTOs.Request;

namespace vivuvn_api.Services.Interfaces
{
    public interface IUserDeviceService
    {
        Task RegisterDeviceAsync(int userId, RegisterDeviceRequestDto request);
        Task DeactivateDeviceAsync(string fcmToken);
        Task CleanupStaleDevicesAsync(int daysThreshold = 30);
    }
}
