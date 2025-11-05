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
            var isOwner = await _memberService.IsOwnerAsync(itineraryId, userId);

            if (!isOwner)
            {
                return BadRequest("Only onwer can send notification to members");
            }

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

        [HttpGet("notifications/unread/count")]
        [Authorize]
        public async Task<IActionResult> GetUnreadCount()
        {
            var userId = GetCurrentUserId();
            var count = await _notificationService.GetUnreadCountAsync(userId);
            return Ok(count);
        }

        [HttpPut("notifications/{notificationId}/read")]
        [Authorize]
        public async Task<IActionResult> MarkAsRead(int notificationId)
        {
            var userId = GetCurrentUserId();
            await _notificationService.MarkAsReadAsync(notificationId, userId);
            return Ok();
        }

        [HttpPut("notifications/mark-all-read")]
        [Authorize]
        public async Task<IActionResult> MarkAllAsRead()
        {
            var userId = GetCurrentUserId();
            await _notificationService.MarkAllAsReadAsync(userId);
            return Ok();
        }

        [HttpDelete("notifications/{notificationId}")]
        [Authorize]
        public async Task<IActionResult> DeleteNotification(int notificationId)
        {
            var userId = GetCurrentUserId();
            await _notificationService.DeleteNotificationAsync(notificationId, userId);
            return NoContent();
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }

    }
}
