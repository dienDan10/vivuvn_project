using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/hotels")]
    [ApiController]
    public class ItineraryHotelController(IitineraryHotelService _itineraryHotelService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetHotelsInItinerary(int itineraryId)
        {
            var hotels = await _itineraryHotelService.GetHotelsInItineraryAsync(itineraryId);
            return Ok(hotels);
        }

        [HttpPost("suggestions")]
        [Authorize]
        public async Task<IActionResult> AddHotelToItineraryFromSuggestion(int itineraryId, [FromBody] AddHotelToItineraryFromSuggestionDto request)
        {
            await _itineraryHotelService.AddHotelToItineraryFromSuggestionAsync(itineraryId, request);

            return Ok(new { message = "Hotel added to itinerary successfully." });
        }

        [HttpPost("search")]
        [Authorize]
        public async Task<IActionResult> AddHotelToItineraryFromSearch(int itineraryId, [FromBody] AddHotelToItineraryFromSearch request)
        {
            await _itineraryHotelService.AddHotelToItineraryFromSearchAsync(itineraryId, request);
            return Ok(new { message = "Hotel added to itinerary successfully." });
        }
    }
}
