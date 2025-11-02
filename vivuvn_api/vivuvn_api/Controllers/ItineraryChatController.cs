using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
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
                return Forbid("You are not a member of this itinerary.");
            }
            var messagePage = await _messageService.GetMessagesAsync(itineraryId, userId, page, pageSize);
            return Ok(messagePage);
        }

        // Get new message after a message (for polling)

        // Send message

        // delete message

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
