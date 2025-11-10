using FirebaseAdmin.Messaging;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

using Notification = FirebaseAdmin.Messaging.Notification;

namespace vivuvn_api.Services.Implementations
{
    public class FcmService(IUnitOfWork _unitOfWork, IUserDeviceService _deviceService) : IFcmService
    {
        private const int FcmMaxTokensPerBatch = 500;

        public async Task SendNotificationToUserAsync(int userId, string title, string message, Dictionary<string, string>? data = null)
        {
            var devices = await _unitOfWork.UserDevices.GetAllAsync(d => d.UserId == userId && d.IsActive);

            if (!devices.Any()) return;

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
                    }

                    // Intentionally swallow other exceptions - notifications are non-critical
                    // and should not block the main operation flow
                }
            }
        }

        public async Task SendNotificationToMultipleUsersAsync(List<int> userIds, string title, string message, Dictionary<string, string>? data = null)
        {
            var devices = await _unitOfWork.UserDevices.GetAllAsync(d => userIds.Contains(d.UserId) && d.IsActive);

            if (!devices.Any()) return;

            var tokens = devices.Select(d => d.FcmToken).ToList();

            var batches = tokens.Chunk(FcmMaxTokensPerBatch);

            foreach (var batch in batches)
            {
                var multicastMessage = new MulticastMessage
                {
                    Tokens = batch.ToList(),
                    Notification = new Notification
                    {
                        Title = title,
                        Body = message,
                    },
                    Data = data ?? new Dictionary<string, string>(),
                    Android = new AndroidConfig
                    {
                        Priority = Priority.High,
                        Notification = new AndroidNotification
                        {
                            Title = title,
                            Body = message,
                            Sound = "default"
                        }
                    }
                };

                try
                {
                    var response = await FirebaseMessaging.DefaultInstance.SendEachForMulticastAsync(multicastMessage);

                    // Handle failed tokens
                    if (response.FailureCount > 0)
                    {
                        for (int i = 0; i < response.Responses.Count; i++)
                        {
                            if (!response.Responses[i].IsSuccess)
                            {
                                var error = response.Responses[i].Exception;
                                if (error is FirebaseMessagingException fex &&
                                    fex.MessagingErrorCode == MessagingErrorCode.Unregistered)
                                {
                                    await _deviceService.DeactivateDeviceAsync(batch.ElementAt(i));
                                }
                            }
                        }
                    }
                }
                catch (FirebaseMessagingException ex)
                {
                    // Intentionally swallow exceptions - notifications are non-critical
                }
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
                Data = data ?? new Dictionary<string, string>(),
                Android = new AndroidConfig
                {
                    Priority = Priority.High,
                    Notification = new AndroidNotification
                    {
                        Title = title,
                        Body = message,
                        Sound = "default",
                    }
                }
            };

            try
            {
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(messagePayload);
            }
            catch (FirebaseMessagingException ex)
            {
                throw; // Re-throw to handle in calling method
            }
        }

    }
}
