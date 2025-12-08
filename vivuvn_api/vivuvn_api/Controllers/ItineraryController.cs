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
        public async Task<IActionResult> GetAllItinerariesOfUser()
        {
            // get user id from token
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId == null)
            {
                return Unauthorized(new { message = "Thiếu thông tin định danh người dùng." });
            }

            // get all itineraries by user id
            var itineraries = await _itineraryService.GetAllItinerariesByUserIdAsync(int.Parse(userId));

            return Ok(itineraries);
        }

        [HttpGet("public")]
        [Authorize]
        public async Task<IActionResult> GetAllPublicItineraries([FromQuery] GetAllPublicItinerariesRequestDto request)
        {
            var response = await _itineraryService.GetAllPublicItinerariesAsync(request);
            return Ok(response);
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
                return Unauthorized(new { message = "Thiếu thông tin định danh người dùng." });
            }

            // create itinerary
            var response = await _itineraryService.CreateItineraryAsync(int.Parse(userId), request);

            return Ok(response);
        }

        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteItinerary(int id)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }

            var result = await _itineraryService.DeleteItineraryByIdAsync(id);

            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu." });
            }

            return NoContent();
        }

        [HttpPut("{id}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryDates(int id, [FromBody] UpdateItineraryDatesRequestDto request)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            await _itineraryService.UpdateItineraryDatesAsync(id, request);
            return Ok();
        }

        [HttpPut("{id}/name")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryName(int id, [FromBody] UpdateItineraryNameRequestDto request)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            var result = await _itineraryService.UpdateItineraryNameAsync(id, request.Name);
            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu" });
            }
            return Ok();
        }

        [HttpPut("{id}/group-size")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryGroupSize(int id, [FromBody] UpdateItineraryGroupSizeRequestDto request)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            var result = await _itineraryService.UpdateItineraryGroupSizeAsync(id, request.GroupSize);
            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu." });
            }
            return Ok();
        }

        [HttpPut("{id}/transportation")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryTransportation(int id, [FromBody] UpdateItineraryTransportationRequestDto request)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            var result = await _itineraryService.UpdateItineraryTransportationAsync(id, request.Transportation);
            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu." });
            }
            return Ok();
        }

        [HttpPut("{id}/public")]
        [Authorize]
        public async Task<IActionResult> SetItineraryToPublic(int id)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            var result = await _itineraryService.SetItineraryToPublicAsync(id);
            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu." });
            }
            return Ok();
        }

        [HttpPut("{id}/private")]
        [Authorize]
        public async Task<IActionResult> SetItineraryToPrivate(int id)
        {
            if (!await IsOwner(id))
            {
                return BadRequest("Bạn không phải là chủ của lịch trình này.");
            }
            var result = await _itineraryService.SetItineraryToPrivateAsync(id);
            if (!result)
            {
                return NotFound(new { message = $"Không tìm thấy lịch trình yêu cầu." });
            }
            return Ok();
        }

        private async Task<bool> IsOwner(int itineraryId)
        {
            var userId = GetCurrentUserId();
            return await _memberService.IsOwnerAsync(itineraryId, userId);
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}
