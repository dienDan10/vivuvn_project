using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries")]
    [ApiController]
    public class ItineraryInviteController(IItineraryMemberService _memberService) : ControllerBase
    {
        [HttpPost("{itineraryId}/invite-code")]
        [Authorize]
        public async Task<IActionResult> GenerateInviteCode(int itineraryId)
        {
            var userId = GetCurrentUserId();
            var inviteCode = await _memberService.GenerateInviteCodeAsync(itineraryId, userId);
            return Ok(inviteCode);
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
