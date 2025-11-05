using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class NotificationService(IUnitOfWork _unitOfWork,
        IMapper _mapper,
        IFcmService _fcmService,
        IEmailService _emailService) : INotificationService
    {

        public async Task<NotificationDto> SendNotificationToItineraryMembersAsync(int itineraryId, int senderId, CreateNotificationRequestDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            // get all members except owner
            var members = await _unitOfWork.ItineraryMembers.GetAllAsync(im => im.ItineraryId == itineraryId && !im.DeleteFlag);

            var reveiverIds = members
                .Where(m => m.UserId != senderId)
                .Select(m => m.UserId)
                .ToList();

            // save notification for each member
            foreach (var receiverId in reveiverIds)
            {
                var notification = new Notification
                {
                    UserId = receiverId,
                    ItineraryId = itineraryId,
                    Type = Constants.NotificationType_OwnerAnnouncement,
                    Title = request.Title,
                    Message = request.Message,
                    CreatedAt = DateTime.UtcNow,
                };
                await _unitOfWork.Notifications.AddAsync(notification);
            }

            await _unitOfWork.SaveChangesAsync();

            // send push notification to all members
            var fcmData = new Dictionary<string, string>
            {
                {"itineraryId", itineraryId.ToString() },
                {"type", Constants.NotificationType_OwnerAnnouncement }
            };

            await _fcmService.SendNotificationToMultipleUsersAsync(reveiverIds, request.Title, request.Message, fcmData);

            if (request.SendEmail)
            {
                // send email notification to all members
                await SendEmailNotificationAsync(reveiverIds, request.Title, request.Message, itinerary.Name);
            }

            // return the created notification
            return new NotificationDto
            {
                Type = Constants.NotificationType_OwnerAnnouncement,
                Title = request.Title,
                Message = request.Message,
                IsRead = false,
                CreatedAt = DateTime.UtcNow,
                ItineraryId = itineraryId,
                ItineraryName = itinerary.Name
            };
        }

        public async Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(int userId, bool unreadOnly = false)
        {
            var notifications = await _unitOfWork.Notifications.GetAllAsync(
                filter: n => n.UserId == userId && (!unreadOnly || !n.IsRead),
                orderBy: q => q.OrderByDescending(n => n.CreatedAt),
                includeProperties: "Itinerary"
            );

            return _mapper.Map<IEnumerable<NotificationDto>>(notifications);
        }

        public async Task<UnreadNotificationCountDto> GetUnreadCountAsync(int userId)
        {
            var count = await _unitOfWork.Notifications.GetUnreadCountAsync(userId);
            return new UnreadNotificationCountDto { UnreadCount = count };
        }

        public async Task MarkAsReadAsync(int notificationId, int userId)
        {
            var notification = await _unitOfWork.Notifications
                .GetOneAsync(n => n.Id == notificationId && n.UserId == userId)
                ?? throw new ArgumentException("Notification not found");


            notification.IsRead = true;
            _unitOfWork.Notifications.Update(notification);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task MarkAllAsReadAsync(int userId)
        {
            var notifications = await _unitOfWork.Notifications.GetAllAsync(n => n.UserId == userId && !n.IsRead);

            foreach (var notification in notifications)
            {
                notification.IsRead = true;
                _unitOfWork.Notifications.Update(notification);
            }

            await _unitOfWork.SaveChangesAsync();
        }

        public async Task DeleteNotificationAsync(int notificationId, int userId)
        {
            var notification = await _unitOfWork.Notifications
                .GetOneAsync(n => n.Id == notificationId && n.UserId == userId)
                ?? throw new ArgumentException("Notification not found");

            notification.DeleteFlag = true;
            _unitOfWork.Notifications.Update(notification);
            await _unitOfWork.SaveChangesAsync();
        }

        private async Task SendEmailNotificationAsync(List<int> recipientIds, string title, string message, string itineraryName)
        {
            foreach (var recipientId in recipientIds)
            {
                var user = await _unitOfWork.Users.GetByIdAsync(recipientId);
                if (user != null && !string.IsNullOrEmpty(user.Email))
                {
                    var emailBody = $@"
                            <h2>{title}</h2>
                            <p>{message}</p>
                            <p><strong>Itinerary:</strong> {itineraryName}</p>
                            <br>
                            <p>Open the app to view more details.</p>
                        ";

                    await _emailService.SendEmailAsync(
                        user.Email,
                        $"[{itineraryName}] {title}",
                        emailBody
                    );
                }
            }
        }


    }
}
