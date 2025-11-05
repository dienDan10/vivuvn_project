namespace vivuvn_api.Services.Interfaces
{
    public interface IFcmService
    {
        Task SendNotificationToUserAsync(int userId, string title, string message, Dictionary<string, string>? data = null);
        Task SendNotificationToMultipleUsersAsync(List<int> userIds, string title, string message, Dictionary<string, string>? data = null);
        Task SendNotificationToDeviceAsync(string fcmToken, string title, string message, Dictionary<string, string>? data = null);
    }
}
