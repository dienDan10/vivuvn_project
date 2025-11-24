using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/chat")]
    [ApiController]
    public class ItineraryChatController(IItineraryMessageService _messageService, IItineraryMemberService _memberService) : ControllerBase
    {
        // Get message (paginated)
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetMessages(int itineraryId, [FromQuery] int page = 1, [FromQuery] int pageSize = 50)
        {
            // check for if user is member of itinerary
            int userId = GetCurrentUserId();
            bool isMember = await _memberService.IsMemberAsync(itineraryId, userId);
            if (!isMember)
            {
                return BadRequest("Bạn không phải là thành viên của lịch trình này.");
            }
            var messagePage = await _messageService.GetMessagesAsync(itineraryId, userId, page, pageSize);
            return Ok(messagePage);
        }

        // Get new message after a message (for polling)
        [HttpGet("new")]
        [Authorize]
        public async Task<IActionResult> GetChatUpdates(int itineraryId, [FromQuery] int lastMessageId, [FromQuery] DateTime? lastPolledAt)
        {
            // check for if user is member of itinerary
            int userId = GetCurrentUserId();
            bool isMember = await _memberService.IsMemberAsync(itineraryId, userId);
            if (!isMember)
            {
                return BadRequest("Bạn không phải là thành viên của lịch trình này.");
            }
            var updates = await _messageService.GetChatUpdatesAsync(itineraryId, userId, lastMessageId, lastPolledAt);
            return Ok(updates);
        }

        // Send message
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> SendMessage(int itineraryId, [FromBody] SendMessageRequestDto request)
        {
            // check for if user is member of itinerary
            int userId = GetCurrentUserId();
            bool isMember = await _memberService.IsMemberAsync(itineraryId, userId);
            if (!isMember)
            {
                return BadRequest("Bạn không phải là thành viên của lịch trình này.");
            }
            var message = await _messageService.SendMessageAsync(itineraryId, userId, request);
            return Ok(message);
        }

        // delete message
        [HttpDelete("{messageId}")]
        [Authorize]
        public async Task<IActionResult> DeleteMessage(int itineraryId, int messageId)
        {
            // check for if user is member of itinerary
            int userId = GetCurrentUserId();
            await _messageService.DeleteMessageAsync(itineraryId, messageId, userId);
            return NoContent();
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
