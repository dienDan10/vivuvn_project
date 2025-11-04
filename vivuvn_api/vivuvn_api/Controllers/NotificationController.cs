using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1")]
    [ApiController]
    public class NotificationController(INotificationService _notificationService, IItineraryMemberService _memberService) : ControllerBase
    {

        [HttpPost("itineraries/{itineraryId}/notifications")]
        [Authorize]
        public async Task<IActionResult> SendNotification(int itineraryId, [FromBody] CreateNotificationRequestDto request)
        {
            var userId = GetCurrentUserId();
            var notification = await _notificationService.SendNotificationToItineraryMembersAsync(itineraryId, userId, request);
            return Ok(notification);
        }

        [HttpGet("notifications")]
        [Authorize]
        public async Task<IActionResult> GetUserNotifications([FromQuery] bool unreadOnly = false)
        {
            var userId = GetCurrentUserId();
            var notifications = await _notificationService.GetUserNotificationsAsync(userId, unreadOnly);
            return Ok(notifications);
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }

    }
}
