using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries")]
    [ApiController]
    public class ItineraryController(IItineraryService _itineraryService, IItineraryMemberService _memberService) : ControllerBase
    {
        // Get all itineraries of the user (include joined itineraries)
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetAllItineraries()
        {
            // get user id from token
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId == null)
            {
                return Unauthorized(new { message = "User ID claim is missing." });
            }

            // get all itineraries by user id
            var itineraries = await _itineraryService.GetAllItinerariesByUserIdAsync(int.Parse(userId));

            return Ok(itineraries);
        }

        [HttpGet("{id}")]
        [Authorize]
        public async Task<IActionResult> GetItineraryById(int id)
        {
            var userId = GetCurrentUserId();
            var itinerary = await _itineraryService.GetItineraryByIdAsync(id, userId);

            return Ok(itinerary);
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> CreateItinerary([FromBody] CreateItineraryRequestDto request)
        {
            // get user id from token
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId == null)
            {
                return Unauthorized(new { message = "User ID claim is missing." });
            }

            // create itinerary
            var response = await _itineraryService.CreateItineraryAsync(int.Parse(userId), request);

            return Ok(response);
        }

        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteItinerary(int id)
        {
            var userId = GetCurrentUserId();
            var isOwner = await _memberService.IsOwnerAsync(id, userId);

            if (!isOwner)
            {
                return BadRequest("You are not the owner of this itinerary.");
            }

            var result = await _itineraryService.DeleteItineraryByIdAsync(id);

            if (!result)
            {
                return NotFound(new { message = $"Itinerary with id {id} not found." });
            }

            return NoContent();
        }

        [HttpPut("{id}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryDates(int id, [FromBody] UpdateItineraryDatesRequestDto request)
        {
            await _itineraryService.UpdateItineraryDatesAsync(id, request);
            return Ok();
        }

        [HttpPut("{id}/name")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryName(int id, [FromBody] UpdateItineraryNameRequestDto request)
        {
            var result = await _itineraryService.UpdateItineraryNameAsync(id, request.Name);
            if (!result)
            {
                return NotFound(new { message = $"Itinerary with id {id} not found." });
            }
            return Ok();
        }

        [HttpPut("{id}/group-size")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryGroupSize(int id, [FromBody] UpdateItineraryGroupSizeRequestDto request)
        {
            var result = await _itineraryService.UpdateItineraryGroupSizeAsync(id, request.GroupSize);
            if (!result)
            {
                return NotFound(new { message = $"Itinerary with id {id} not found." });
            }
            return Ok();
        }

        [HttpPut("{id}/public")]
        [Authorize]
        public async Task<IActionResult> SetItineraryToPublic(int id)
        {
            var result = await _itineraryService.SetItineraryToPublicAsync(id);
            if (!result)
            {
                return NotFound(new { message = $"Itinerary with id {id} not found." });
            }
            return Ok();
        }

        [HttpPut("{id}/private")]
        [Authorize]
        public async Task<IActionResult> SetItineraryToPrivate(int id)
        {
            var result = await _itineraryService.SetItineraryToPrivateAsync(id);
            if (!result)
            {
                return NotFound(new { message = $"Itinerary with id {id} not found." });
            }
            return Ok();
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
