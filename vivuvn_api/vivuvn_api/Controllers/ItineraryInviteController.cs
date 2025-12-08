using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
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

        [HttpPost("join")]
        [Authorize]
        public async Task<IActionResult> JoinItinerary([FromBody] JoinItineraryRequestDto request)
        {
            var userId = GetCurrentUserId();
            await _memberService.JoinItineraryByInviteCodeAsync(userId, request.InviteCode);
            return Ok(new { message = "Tham gia lịch trình thành công." });
        }

        [HttpPost("{itineraryId}/public/join")]
        [Authorize]
        public async Task<IActionResult> JoinPublicItinerary(int itineraryId)
        {
            var userId = GetCurrentUserId();
            await _memberService.JoinPublicItineraryAsync(userId, itineraryId);
            return Ok(new { message = "Tham gia lịch trình công khai thành công." });
        }
    }
}
