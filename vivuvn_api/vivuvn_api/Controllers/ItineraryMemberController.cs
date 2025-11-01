using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/members")]
    [ApiController]
    public class ItineraryMemberController(IItineraryMemberService _memberService) : ControllerBase
    {
        // get all members of an itinerary
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetMembers(int itineraryId)
        {
            var members = await _memberService.GetMembersAsync(itineraryId);
            return Ok(members);
        }

        // leave itinerary

        // kick member from itinerary

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
