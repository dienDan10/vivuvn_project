using FirebaseAdmin.Messaging;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class FcmService(IUnitOfWork _unitOfWork, IUserDeviceService _deviceService) : IFcmService
    {
        public async Task SendNotificationToUserAsync(int userId, string title, string message, Dictionary<string, string>? data = null)
        {
            var devices = await _unitOfWork.UserDevices.GetAllAsync(d => d.UserId == userId && d.IsActive);

            foreach (var device in devices)
            {
                try
                {
                    await SendNotificationToDeviceAsync(device.FcmToken, title, message, data);
                }
                catch (FirebaseMessagingException ex)
                {
                    if (ex.MessagingErrorCode == MessagingErrorCode.Unregistered)
                    {
                        await _deviceService.DeactivateDeviceAsync(device.FcmToken);
                        Console.WriteLine($"❌ Deactivated invalid token for UserId: {userId}");
                    }
                    else
                    {
                        Console.WriteLine($"❌ FCM error: {ex.Message}");
                    }
                }
            }
        }
        public async Task SendNotificationToMultipleUsersAsync(List<int> userIds, string title, string message, Dictionary<string, string>? data = null)
        {
            foreach (var userId in userIds)
            {
                await SendNotificationToUserAsync(userId, title, message, data);
            }
        }


        public async Task SendNotificationToDeviceAsync(string fcmToken, string title, string message, Dictionary<string, string>? data = null)
        {
            var messagePayload = new Message()
            {
                Token = fcmToken,
                Notification = new Notification()
                {
                    Title = title,
                    Body = message
                },
                Data = data ?? new Dictionary<string, string>()
            };

            try
            {
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(messagePayload);
                Console.WriteLine($"✅ Successfully sent notification: {response}");
            }
            catch (FirebaseMessagingException ex)
            {
                Console.WriteLine($"❌ Failed to send notification: {ex.Message}");
                throw; // Re-throw to handle in calling method
            }
        }


    }
}
